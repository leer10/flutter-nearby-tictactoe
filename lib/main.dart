import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_sub/pub_sub.dart';
import 'package:pub_sub/json_rpc_2.dart';
import 'dart:async';
import 'package:stream_channel/stream_channel.dart';
import 'package:minigames/classes/NearbyClasses.dart';
import 'package:uuid/uuid.dart';

//Classes
import 'package:minigames/classes/playerClasses.dart';
import 'package:minigames/proto/cell.pb.dart'; // for tictactoe
import 'dart:math' as dartMath; //for random numbers

//actual multiplayer
import 'package:minigames/Manager.dart';
import 'package:minigames/Customer.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';

//using hive as a backend
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

//Screens
import 'package:minigames/screens/OpeningScreen.dart';
import 'package:minigames/screens/WelcomeScreen.dart';
import 'package:minigames/screens/OfferScreen.dart';
import 'package:minigames/screens/JoinScreen.dart';
import 'package:minigames/screens/LobbyScreen.dart';
import 'package:minigames/screens/GameScreen.dart';

void main() => runApp(
    ChangeNotifierProvider(builder: (context) => GameState(), child: MyApp()));

Future setupBox() async {
  var directory = await getTemporaryDirectory();
  Hive.init(directory.path);
  Box theboxBox = await Hive.openBox('thebox');
  Box playersBox = await Hive.openBox('players');
  Box gameBox = await Hive.openBox('game');
  Box clientBox = await Hive.openBox("client");
  Box managerPlayersBox = await Hive.openBox('manager_players');
  await theboxBox.clear();
  await playersBox.clear();
  await gameBox.clear();
  await managerPlayersBox.clear();
  await clientBox.clear();
  await Hive.openBox('players');
  await Hive.openBox('manager_players');
  await Hive.openBox('game');
  await Hive.openBox("client");
  return await Hive.openBox('thebox');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nearby Minigames',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => StartingScreen(),
          '/welcome': (context) => WelcomeScreen(),
          '/welcome/offer': (context) => OfferScreen(),
          '/welcome/join': (context) => JoinScreen(),
          '/lobby': (context) => LobbyScreen(),
          '/game': (context) => GameScreen(),
        });
  }
}

class GameState with ChangeNotifier {
  String uuid = Uuid().v4();
  List<Player> playerList = [];
  Player selfPlayer;
  bool desireToSpectate = false;
  // For server
  bool isServerInitalized = false;
  Server server;
  StreamController<StreamChannel<String>> controller;
  Stream<StreamChannel<String>> incomingConnections;
  JsonRpc2Adapter adapter;
  Manager manager;
  Customer customer;

  // For client
  bool isClientInitalized = false;
  JsonRpc2Client client;

  // For Multiplayer logic self-hosted (currently Nearby only) (the "server" in client-server)
  bool isManagerInitalized = false;
  JsonRpc2Client managertoServer;

  void setDesireToSpectate(bool value) {
    desireToSpectate = value;
    notifyListeners();
  }

  void addSelf(String name) {
    selfPlayer = Player(fancyName: name, isSelf: true, deviceID: "This Device");
    playerList.add(selfPlayer);
  }

  void addPlayer({@required fancyName, @required deviceID, isHost}) {
    playerList
        .add(Player(fancyName: fancyName, deviceID: deviceID, isHost: isHost));
    notifyListeners();
  }

  void removePlayerbyID({@required String deviceID}) {
    playerList.removeWhere((player) => player.deviceID == deviceID);
    notifyListeners();
  }

  void initalizeServer() {
    if (!isServerInitalized) {
      print("Initalizing server");
      controller = StreamController<StreamChannel<String>>();
      incomingConnections = controller.stream;
      adapter = JsonRpc2Adapter(incomingConnections, isTrusted: true);
      server = Server([adapter])..start();
      managerInitWithSelf();
      connectWithSelf();
      isServerInitalized = true;
    } else {
      print("server already initalized!");
    }
  }

  void connectWithClient(String id) {
    StreamChannel<String> clientChannel =
        StreamChannel(NearbyStream(id).stream, NearbyStream(id).sink);
    controller.add(clientChannel);
    print("added client $id");
  }

  void connectWithSelf() {
    LoopbackStream loopbackStream = LoopbackStream();
    StreamChannel<String> localClientChannel =
        StreamChannel(loopbackStream.clientStream, loopbackStream.clientSink);
    StreamChannel<String> localServerChannel =
        StreamChannel(loopbackStream.serverStream, loopbackStream.serverSink);
    client = JsonRpc2Client(null, localClientChannel);
    controller.add(localServerChannel);
    print("added self");
    connectCommon(type: SerializablePlayer_ConnectionType.Loopback);
  }

  void connectWithServer(String id) {
    StreamChannel<String> serverChannel =
        StreamChannel(NearbyStream(id).stream, NearbyStream(id).sink);
    client = JsonRpc2Client(null, serverChannel);
    connectCommon(type: SerializablePlayer_ConnectionType.Nearby, id: id);
  }

  void connectCommon({SerializablePlayer_ConnectionType type, String id}) {
    SerializablePlayer serializableSelf = SerializablePlayer();
    serializableSelf.fancyName = selfPlayer.fancyName;
    serializableSelf.intentPlay = !selfPlayer.desireToSpectate;
    serializableSelf.id = uuid;
    if (selfPlayer.isHost == true) {
      serializableSelf.isHost = true;
    }
    if (type == SerializablePlayer_ConnectionType.Nearby) {
      serializableSelf.nearbyID = id;
    }
    customer = Customer(client, notifyListeners);
    customer.announceSelf(serializableSelf);
  }

  void managerInitWithSelf() {
    if (!isManagerInitalized) {
      LoopbackStream managerLoopbackStream = LoopbackStream();
      StreamChannel<String> managerlocalClientChannel = StreamChannel(
          managerLoopbackStream.clientStream, managerLoopbackStream.clientSink);
      StreamChannel<String> managerlocalServerChannel = StreamChannel(
          managerLoopbackStream.serverStream, managerLoopbackStream.serverSink);
      managertoServer = JsonRpc2Client(null, managerlocalClientChannel);
      controller.add(managerlocalServerChannel);
      manager = Manager(managertoServer);
      print("added manager");
      isManagerInitalized = true;
    } else {
      print("manager already init");
    }
  }

  // Tic Tac Toe
  bool isBoardInitalized = false;
  List<List<Cell>> _ticTacToeData;
  void initalizeticTacToeBoard() {
    if (!isBoardInitalized) {
      _ticTacToeData = List<List<Cell>>.generate(
          3,
          (i) => List<Cell>.generate(3, (j) {
                Cell aCell = Cell();
                aCell.symbol = Cell_Symbol.blank;
                return aCell;
              })); // u/kevmoo
      for (var i = 0; i < _ticTacToeData[0].length; i++) {
        _ticTacToeData[0][i].y = i;
        _ticTacToeData[0][i].x = 0;
      }
      for (var i = 0; i < _ticTacToeData[1].length; i++) {
        _ticTacToeData[1][i].y = i;
        _ticTacToeData[1][i].x = 1;
      }
      for (var i = 0; i < _ticTacToeData[2].length; i++) {
        _ticTacToeData[2][i].y = i;
        _ticTacToeData[2][i].x = 2;
      }
      /*_ticTacToeData[0][0].color = Cell_Color.blue;
  _ticTacToeData[0][0].symbol = Cell_Symbol.cross;
  _ticTacToeData[2][0].color = Cell_Color.red;
  _ticTacToeData[2][0].symbol = Cell_Symbol.circle;
  _ticTacToeData[1][1].symbol = Cell_Symbol.blank;
  */
      var ticTacToeEventCatch = client.subscribe("ticTacToeEvent");
      ticTacToeEventCatch.then((sub) {
        print("listening to ticTacToe events");
        sub.listen((msg) {
          Cell newpiece = Cell.fromJson(msg);
          _ticTacToeData[newpiece.x][newpiece.y] = newpiece;
          notifyListeners();
        });
      });

      isBoardInitalized = true;
    }
  }

  List<List<Cell>> get ticTacToeData => _ticTacToeData;

  Cell getPiece(x, y) {
    return _ticTacToeData[x][y];
  }

  void setCellColor(int x, int y, Cell_Color color) {
    _ticTacToeData[x][y].color = color;
    notifyListeners();
    client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
  }

  void setCell(int x, int y, Cell_Color color, Cell_Symbol symbol) {
    _ticTacToeData[x][y].color = color;
    _ticTacToeData[x][y].symbol = symbol;
    notifyListeners();
    client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
    client.publish("finishedTurn", "");
  }

  void setToRedO(x, y) {
    print(_ticTacToeData[x][y]);
    print("$x $y set to red o");
    _ticTacToeData[x][y].symbol = Cell_Symbol.circle;
    _ticTacToeData[x][y].color = Cell_Color.red;
    //print(_ticTacToeData[x][y]);
    notifyListeners();
    client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
  }

  void setToRandomColor(x, y) {
    dartMath.Random random = dartMath.Random();
    int randomInt = random.nextInt(3);
    _ticTacToeData[x][y].color = Cell_Color.valueOf(randomInt);
    notifyListeners();
    client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
  }

  void setToRandomSymbol(x, y) {
    dartMath.Random random = dartMath.Random();
    int randomInt = random.nextInt(3);
    _ticTacToeData[x][y].symbol = Cell_Symbol.valueOf(randomInt);
    notifyListeners();
    client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
  }
}

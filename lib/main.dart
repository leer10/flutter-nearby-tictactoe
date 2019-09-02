import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_sub/pub_sub.dart';
import 'package:pub_sub/json_rpc_2.dart';
import 'dart:async';
import 'package:stream_channel/stream_channel.dart';
import 'package:minigames/NearbyClasses.dart';


//Classes
import 'package:minigames/playerClasses.dart';
import 'package:minigames/TicTacToe.dart';
import 'package:piecemeal/piecemeal.dart'; // for tictactoe
import 'package:minigames/proto/cell.pb.dart'; // for tictactoe
import 'dart:math' as dartMath; //for random numbers


//Screens
import 'package:minigames/OpeningScreen.dart';
import 'package:minigames/WelcomeScreen.dart';
import 'package:minigames/OfferScreen.dart';
import 'package:minigames/JoinScreen.dart';
import 'package:minigames/LobbyScreen.dart';

void main() => runApp(
    ChangeNotifierProvider(builder: (context) => GameState(), child: MyApp()));

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
          '/': (context) => StartingPage(),
          '/welcome': (context) => WelcomePage(),
          '/welcome/offer': (context) => OfferPage(),
          '/welcome/join': (context) => JoinPage(),
          '/lobby': (context) => LobbyPage(),
        });
  }
}

class GameState with ChangeNotifier {
  List<Player> PlayerList = [];
  Player selfPlayer;
  // For server
  bool isServerInitalized = false;
  Server server;
  StreamController<StreamChannel<String>> controller;
  Stream<StreamChannel<String>> incomingConnections;
  JsonRpc2Adapter adapter;

  // For client
  bool isClientInitalized = false;
  JsonRpc2Client client;



  void addSelf(String name) {
    selfPlayer = Player(fancyName: name, isSelf: true, deviceID: "This Device");
    PlayerList.add(selfPlayer);

  }
  void addPlayer({@required fancyName, @required deviceID, isHost}){
    PlayerList.add(Player(fancyName: fancyName, deviceID: deviceID, isHost: isHost));
    notifyListeners();
  }

  void initalizeServer() {
    if (!isServerInitalized) {
    print("Initalizing server");
    controller = StreamController<StreamChannel<String>>();
    incomingConnections = controller.stream;
    adapter = JsonRpc2Adapter(incomingConnections, isTrusted: true);
    server = Server([adapter])
    ..start();
    connectWithSelf();
  isServerInitalized = true;} else {print("server already initalized!");}
  }

  void connectWithClient(String id){
    StreamChannel<String> clientChannel = StreamChannel(NearbyStream(id).stream, NearbyStream(id).sink);
    controller.add(clientChannel);
    print("added client $id");
  }

  void connectWithSelf(){
    LoopbackStream loopbackStream = LoopbackStream();
    StreamChannel<String> localClientChannel = StreamChannel(loopbackStream.clientStream, loopbackStream.clientSink);
    StreamChannel<String> localServerChannel = StreamChannel(loopbackStream.serverStream, loopbackStream.serverSink);
    client = JsonRpc2Client(null, localClientChannel);
    controller.add(localServerChannel);
    print("added self");
  }

  void connectWithServer(String id){
    StreamChannel<String> serverChannel = StreamChannel(NearbyStream(id).stream, NearbyStream(id).sink);
    client = JsonRpc2Client(null, serverChannel);
  }

  // Tic Tac Toe
bool isBoardInitalized = false;
List<List<Cell>> _ticTacToeData;
void initalizeticTacToeBoard(){
  if (!isBoardInitalized){
  _ticTacToeData = List<List<Cell>>.generate( 3, (i) => List<Cell>.generate(3, (j) => Cell())); // u/kevmoo
  for (var i = 0; i < _ticTacToeData[0].length; i++){
    _ticTacToeData[0][i].y = i;
    _ticTacToeData[0][i].x = 0;
  }
  for (var i = 0; i < _ticTacToeData[1].length; i++){
    _ticTacToeData[1][i].y = i;
    _ticTacToeData[1][i].x = 1;
  }
  for (var i = 0; i < _ticTacToeData[2].length; i++){
    _ticTacToeData[2][i].y = i;
    _ticTacToeData[2][i].x = 2;
  }
  _ticTacToeData[0][0].color = Cell_Color.blue;
  _ticTacToeData[0][0].symbol = Cell_Symbol.cross;
  _ticTacToeData[2][0].color = Cell_Color.red;
  _ticTacToeData[2][0].symbol = Cell_Symbol.circle;
  _ticTacToeData[1][1].symbol = Cell_Symbol.blank;

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
}}

List<List<Cell>> get ticTacToeData => _ticTacToeData;

Cell getPiece (x, y){
  return _ticTacToeData[x][y];
}

void setCellColor(int x, int y, Cell_Color color){
_ticTacToeData[x][y].color = color;
notifyListeners();
client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
}

void setToRedO(x, y){
  print(_ticTacToeData[x][y]);
  print("$x $y set to red o");
  _ticTacToeData[x][y].symbol = Cell_Symbol.circle;
  _ticTacToeData[x][y].color = Cell_Color.red;
  //print(_ticTacToeData[x][y]);
  notifyListeners();
  client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
}

void setToRandomColor(x, y){
dartMath.Random random = dartMath.Random();
  int randomInt = random.nextInt(3);
  _ticTacToeData[x][y].color = Cell_Color.valueOf(randomInt);
  notifyListeners();
  client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
}

void setToRandomSymbol(x, y){
dartMath.Random random = dartMath.Random();
  int randomInt = random.nextInt(3);
  _ticTacToeData[x][y].symbol = Cell_Symbol.valueOf(randomInt);
  notifyListeners();
  client.publish("ticTacToeEvent", _ticTacToeData[x][y].writeToJson());
}
}

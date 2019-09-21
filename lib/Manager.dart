import 'package:minigames/TicTacToe.dart';
import 'package:minigames/proto/cell.pb.dart';
import 'package:pub_sub/json_rpc_2.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';
import 'package:minigames/proto/tictactoe.pb.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:typed_data';

class Manager {
  JsonRpc2Client client;
  Box playersBox = Hive.box('manager_players');
  Box gameBox = Hive.box('game');
  int currentTurnIndex = 0;
  RoleList roleList = RoleList();

  List<List<Cell>> authortativeTicTacToeBoard = [];

  Manager(this.client) {
    authortativeTicTacToeBoard = genTicTacToeData();
    var announceSelfCatch = client.subscribe("announceSelf");
    announceSelfCatch.then((sub) {
      print("manager: listening to self announcements");
      sub.listen((msg) {
        SerializablePlayer newPlayer = SerializablePlayer.fromJson(msg);
        playersBox.add(newPlayer.writeToBuffer());
        print("Player ${newPlayer.fancyName} added");
      });
    });

    var requestPlayerListCatch = client.subscribe("requestPlayerList");
    requestPlayerListCatch.then((sub) {
      print("manager: listening to player list requests");
      sub.listen((msg) {
        client.publish("playerListAnnounce", jsonEncode(playersBox.toMap()));
      });
    });

    var ticTacToeEventCatch = client.subscribe("ticTacToeEvent");
    ticTacToeEventCatch.then((sub) {
      print("manager: listening to ticTacToe events");
      sub.listen((msg) {
        Cell newpiece = Cell.fromJson(msg);
        authortativeTicTacToeBoard[newpiece.x][newpiece.y] = newpiece;
        print("New piece $newpiece");
      });
    });

    var finishedTurnCatch = client.subscribe("finishedTurn");
    finishedTurnCatch.then((sub) {
      print("manager: listening to finished turn");
      sub.listen((msg) {
        //print("Caught finished turn");
        if (checkForWin(authortativeTicTacToeBoard) != Cell_Symbol.blank) {
          print(
              "Current winnner is: ${checkForWin(authortativeTicTacToeBoard).toString()}");
          PlayerWithRole winner;
          switch (checkForWin(authortativeTicTacToeBoard)) {
            case Cell_Symbol.circle:
              winner = roleList.player.firstWhere(
                  (player) => player.symbol == PlayerWithRole_Symbol.circle);
              break;
            case Cell_Symbol.cross:
              winner = roleList.player.firstWhere(
                  (player) => player.symbol == PlayerWithRole_Symbol.cross);
              break;
            default:
              throw "unknown symbol: ${checkForWin(authortativeTicTacToeBoard)}";
          }
          print("Winner is ${winner.fancyName}");
          TurnAnnounce turnAnnounce = TurnAnnounce();
          turnAnnounce.uuid = winner.uuid;
          client.publish("announceWin", turnAnnounce.writeToJson());
        } else {
          nextTurn();
        }
      });
    });

    var startGameCatch = client.subscribe("startGame");
    startGameCatch.then((sub) {
      sub.listen((msg) {
        print("manager: starting game");
        List<PlayerWithRole_Color> colorList =
            List.from(PlayerWithRole_Color.values);
        List<PlayerWithRole_Symbol> symbolList =
            List.from(PlayerWithRole_Symbol.values);
        colorList.shuffle();
        symbolList.shuffle();
        List<SerializablePlayer> listofPlayers = playersBox
            .toMap()
            .cast<String, Uint8List>()
            .values
            .map((f) => SerializablePlayer.fromBuffer(f))
            .where((player) => player.intentPlay == true)
            .toList();
        listofPlayers.shuffle();
        for (SerializablePlayer player in listofPlayers.take(2)) {
          PlayerWithRole aPlayer1 = PlayerWithRole();
          aPlayer1.uuid = player.id;
          aPlayer1.fancyName = player.fancyName;
          aPlayer1.symbol = symbolList.removeLast();
          aPlayer1.color = colorList.removeLast();
          roleList.player.add(aPlayer1);
        }
        gameBox.put("rolesList", roleList.writeToBuffer());
        client.publish("roleListAnnounce", roleList.writeToJson());
        nextTurn();
      });
    });
  }

  void nextTurn() {
    TurnAnnounce turnAnnounce = TurnAnnounce();
    print("these are the roles: $roleList");
    turnAnnounce.uuid = roleList.player[currentTurnIndex].uuid;
    client.publish("turnAnnounce", turnAnnounce.writeToJson());
    incrementTurn();
  }

  void incrementTurn() {
    print(currentTurnIndex);
    if (currentTurnIndex >= roleList.player.length - 1) {
      currentTurnIndex = 0;
    } else {
      ++currentTurnIndex;
    }
  }
}

Cell_Symbol checkForWin(List<List<Cell>> authortativeTicTacToeBoard) {
  // Check all of one direction
  for (var i = 0; i < 3; i++) {
    switch (threeCellCheck(authortativeTicTacToeBoard[i])) {
      case Cell_Symbol.blank:
        {
          break;
        }
      case Cell_Symbol.circle:
        {
          return Cell_Symbol.circle;
        }
      case Cell_Symbol.cross:
        {
          return Cell_Symbol.cross;
        }
    }
  }
  //check the harder direction
  for (var i = 0; i < 3; i++) {
    List<Cell> crossAxis = [
      authortativeTicTacToeBoard[0][i],
      authortativeTicTacToeBoard[1][i],
      authortativeTicTacToeBoard[2][i]
    ];
    switch (threeCellCheck(crossAxis)) {
      case Cell_Symbol.blank:
        {
          break;
        }
      case Cell_Symbol.circle:
        {
          return Cell_Symbol.circle;
        }
      case Cell_Symbol.cross:
        {
          return Cell_Symbol.cross;
        }
    }
  }

  //check diagonals

  List<Cell> downRightDiagnonal = [
    authortativeTicTacToeBoard[0][0],
    authortativeTicTacToeBoard[1][1],
    authortativeTicTacToeBoard[2][2]
  ];
  switch (threeCellCheck(downRightDiagnonal)) {
    case Cell_Symbol.blank:
      {
        break;
      }
    case Cell_Symbol.circle:
      {
        return Cell_Symbol.circle;
      }
    case Cell_Symbol.cross:
      {
        return Cell_Symbol.cross;
      }
  }

  List<Cell> downLeftDiagnonal = [
    authortativeTicTacToeBoard[2][0],
    authortativeTicTacToeBoard[1][1],
    authortativeTicTacToeBoard[0][2]
  ];
  switch (threeCellCheck(downLeftDiagnonal)) {
    case Cell_Symbol.blank:
      {
        break;
      }
    case Cell_Symbol.circle:
      {
        return Cell_Symbol.circle;
      }
    case Cell_Symbol.cross:
      {
        return Cell_Symbol.cross;
      }
  }
  return Cell_Symbol.blank;
}

Cell_Symbol threeCellCheck(List<Cell> threeCells) {
  if (threeCells.every((cell) => cell.symbol == Cell_Symbol.circle)) {
    return Cell_Symbol.circle;
  } else if (threeCells.every((cell) => cell.symbol == Cell_Symbol.cross)) {
    return Cell_Symbol.cross;
  } else {
    return Cell_Symbol.blank;
  }
}

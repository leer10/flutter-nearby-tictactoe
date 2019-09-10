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
  Manager(this.client) {
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
        RoleList roleList = RoleList();
        List<SerializablePlayer> listofPlayers = playersBox
            .toMap()
            .cast<String, Uint8List>()
            .values
            .map((f) => SerializablePlayer.fromBuffer(f))
            .where((player) => player.intentPlay == true);
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
        client.publish("rolesListAnnounce", roleList.writeToJson());
      });
    });
  }
}

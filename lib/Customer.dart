import 'dart:async';

import 'package:minigames/proto/tictactoe.pb.dart';
import 'package:pub_sub/json_rpc_2.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

class Customer {
  JsonRpc2Client client;
  Box playersBox = Hive.box('players');
  Box clientBox = Hive.box('client');
  RoleList _roleList;
  PlayerWithRole myRole;
  PlayerWithRole noBody = PlayerWithRole();
  PlayerWithRole whoseTurn;
  Customer(this.client, void notifyListeners()) {
    noBody.fancyName = "Nobody"; // Set current turn to nobody
    noBody.uuid = "nobody";
    whoseTurn = noBody;

    var playerListAnnounceCatch = client.subscribe("playerListAnnounce");
    playerListAnnounceCatch.then((sub) {
      print("customer: listening to playerList announcements");
      sub.listen((msg) {
        var playerList = jsonDecode(msg);
        playersBox.putAll(playerList);
        print("customer: Merged new player list data");
      });
    });

    var roleListAnnounceCatch = client.subscribe("roleListAnnounce");
    roleListAnnounceCatch.then((sub) {
      print("customer: listening to roleList announcements");
      sub.listen((msg) {
        _roleList = RoleList.fromJson(msg);
        print("got a rolelist");
        print(_roleList);
        clientBox.put('roleList', _roleList.writeToBuffer());
      });
    });

    var announceSelfCatch = client.subscribe("announceSelf");
    announceSelfCatch.then((sub) {
      print("customer: listening to self announcements");
      sub.listen((msg) {
        SerializablePlayer newPlayer = SerializablePlayer.fromJson(msg);
        playersBox.add(newPlayer.writeToBuffer());
        print("Player ${newPlayer.fancyName} added");
      });
    });

    var turnAnnounceCatch = client.subscribe("turnAnnounce");
    turnAnnounceCatch.then((sub) {
      print("customer: listening to turn announcements");
      sub.listen((msg) {
        TurnAnnounce turnAnnounce = TurnAnnounce.fromJson(msg);
        if (!turnAnnounce.isAck) {
          RoleList roleList = RoleList.fromBuffer(clientBox.get("roleList"));
          whoseTurn = roleList.player
              .firstWhere((player) => player.uuid == turnAnnounce.uuid);
          print("customer: caught a new turn for ${whoseTurn.fancyName}");
          notifyListeners();
          /* // ack response not used yet
          if (whoseTurn == myRole) {
            TurnAnnounce turnAnnounceACK = TurnAnnounce();
            turnAnnounceACK.uuid = myRole.uuid;
            turnAnnounceACK.isAck = true;
            client.publish("turnAnnounce", turnAnnounceACK.writeToJson());
          }*/
        }
      });
    });
  }

  void announceSelf(SerializablePlayer self) {
    client.publish("announceSelf", self.writeToJson());
    playersBox.add(self.writeToBuffer());
    print("self has been announced");
  }
}

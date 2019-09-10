import 'package:pub_sub/json_rpc_2.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

class Customer {
  JsonRpc2Client client;
  Box playersBox = Hive.box('players');
  Customer(this.client) {
    var playerListAnnounceCatch = client.subscribe("playerListAnnounce");
    playerListAnnounceCatch.then((sub) {
      print("customer: listening to playerList announcements");
      sub.listen((msg) {
        var playerList = jsonDecode(msg);
        playersBox.putAll(playerList);
        print("customer: Merged new player list data");
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
  }

  void announceSelf(SerializablePlayer self) {
    client.publish("announceSelf", self.writeToJson());
    playersBox.add(self.writeToBuffer());
    print("self has been announced");
  }
}

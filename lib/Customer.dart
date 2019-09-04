import 'package:pub_sub/json_rpc_2.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';
import 'dart:async';

class Customer {
  JsonRpc2Client client;
  Customer(this.client){

    var playerListAnnounceCatch = client.subscribe("playerListAnnounce");
    playerListAnnounceCatch.then((sub) {
      print("listening to playerList announcements");
sub.listen((msg) {
  serializablePlayerList.mergeFromJson(msg);
  print("Merged new player list data");
});
});

  }

Future<Stream<SerializablePlayerList>> streamofPlayerList() async {
  var playerListAnnounceCatch = await client.subscribe("playerListAnnounce");
  client.publish("playerListRequest", "");
  return playerListAnnounceCatch.cast();
}

  SerializablePlayerList serializablePlayerList = SerializablePlayerList();

  void serializablePlayerListAdd (SerializablePlayer player){
    serializablePlayerList.players.add(player);
    client.publish("playerListAnnounce", serializablePlayerList.writeToJson());
  }

  void announceSelf (SerializablePlayer self){
    client.publish("announceSelf", self.writeToJson());
  }

}

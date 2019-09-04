import 'package:pub_sub/json_rpc_2.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';

class Manager {
  JsonRpc2Client client;
  Manager(this.client){

    var announceSelfCatch = client.subscribe("announceSelf");
    announceSelfCatch.then((sub) {
      print("listening to self announcements");
sub.listen((msg) {
  SerializablePlayer newPlayer = SerializablePlayer.fromJson(msg);
  serializablePlayerListAdd(newPlayer);
  print("Player ${newPlayer.fancyName} added");
});
});

    var requestPlayerListCatch = client.subscribe("requestPlayerList");
    announceSelfCatch.then((sub) {
      print("listening to player list requests");
sub.listen((msg) {
  client.publish("playerListAnnounce", serializablePlayerList.writeToJson());
});
});


  }


  SerializablePlayerList serializablePlayerList = SerializablePlayerList();

  void serializablePlayerListAdd (SerializablePlayer player){
    serializablePlayerList.players.add(player);
    client.publish("playerListAnnounce", serializablePlayerList.writeToJson());
  }

}

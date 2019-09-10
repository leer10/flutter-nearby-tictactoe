import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';


import 'package:minigames/TicTacToe.dart';

class LobbyPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Provider.of<GameState>(context).initalizeticTacToeBoard();
    return Scaffold(
      appBar: AppBar(title: Text("${Provider.of<GameState>(context).PlayerList.firstWhere((player) => player.isHost == true).fancyName}'s Lobby"),),
      //body: Placeholder(),
      body: Column(
        children: <Widget>[
          if (Provider.of<GameState>(context).selfPlayer.isHost == true)
          RaisedButton(
            child: Text("Start Game"),
            onPressed: (){
              Provider.of<GameState>(context).client.publish("startGame", "");
            }
          ),
          Expanded(
            child: WatchBoxBuilder(
              box: Hive.box('players'),
              builder: (context, box) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (BuildContext context, int index) {
                    SerializablePlayer playerInstance = SerializablePlayer.fromBuffer(box.getAt(index));
                    return ListTile(
                      title: Text(playerInstance.fancyName),
                      subtitle: Text(playerInstance.id),
                    );
                  }
                );
              }
            ),
          )
        ],
      )
    );
  }
}


class MessageForm extends StatefulWidget{
  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final myController = TextEditingController();

  @override
  void dispose(){
myController.dispose();
super.dispose();
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: myController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Enter a greeting"
              )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: (){
              Provider.of<GameState>(context).client.publish("greeting", myController.text);
            }
          ),
        ),
      ],
    );
  }
}

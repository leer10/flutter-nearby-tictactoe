import 'package:flutter/material.dart';
import 'package:minigames/proto/tictactoe.pb.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';

class LobbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<GameState>(context).initalizeticTacToeBoard();
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${Provider.of<GameState>(context).playerList.firstWhere((player) => player.isHost == true).fancyName}'s Lobby"),
        ),
        //body: Placeholder(),
        body: WatchBoxBuilder(
            box: Hive.box("client"),
            watchKeys: ["roleList"],
            builder: (context, box) {
              if (box.containsKey("roleList")) {
                RoleList roleList = RoleList.fromBuffer(box.get("roleList"));
                PlayerWithRole you = roleList.player.firstWhere((player) =>
                    player.uuid == Provider.of<GameState>(context).uuid);
                Provider.of<GameState>(context).customer.myRole = you;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("You are ready to go!",
                          style: TextStyle(fontSize: 32)),
                      Text(you.fancyName, style: TextStyle(fontSize: 24)),
                      Text(you.color.name, style: TextStyle(fontSize: 24)),
                      Text(you.symbol.name, style: TextStyle(fontSize: 24)),
                      RaisedButton(
                          child: Text("Go!"),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/game', (_) => false);
                          })
                    ],
                  ),
                );
              } else {
                return LobbyPage();
              }
            }));
  }
}

class LobbyPage extends StatelessWidget {
  const LobbyPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: WatchBoxBuilder(
              box: Hive.box('players'),
              builder: (context, box) {
                return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (BuildContext context, int index) {
                      SerializablePlayer playerInstance =
                          SerializablePlayer.fromBuffer(box.getAt(index));
                      return ListTile(
                        title: Text(playerInstance.fancyName),
                        subtitle: Text(playerInstance.id),
                      );
                    });
              }),
        ),
        if (Provider.of<GameState>(context).selfPlayer.isHost == true)
          RaisedButton(
              child: Text("Start Game"),
              onPressed: () {
                Provider.of<GameState>(context).client.publish("startGame", "");
              })
      ],
    );
  }
}

class MessageForm extends StatefulWidget {
  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: myController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: "Enter a greeting")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                Provider.of<GameState>(context)
                    .client
                    .publish("greeting", myController.text);
              }),
        ),
      ],
    );
  }
}

class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

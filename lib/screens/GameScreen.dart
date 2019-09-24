import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minigames/TicTacToe.dart';
import 'package:minigames/main.dart';
import 'package:minigames/proto/tictactoe.pb.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
        box: Hive.box("client"),
        watchKeys: ["roleList"],
        builder: (context, box) {
          if (box.get("roleList") != null)
            return GameScreenBody();
          else
            Navigator.pushNamedAndRemoveUntil(context, '/lobby', (_) => false);
          return Placeholder();
        });
  }
}

class GameScreenBody extends StatelessWidget {
  const GameScreenBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerWithRole myRole = Provider.of<GameState>(context).customer.myRole;
    return Scaffold(
        appBar: AppBar(
          title: Text('Game'),
        ),
        floatingActionButton: Provider.of<GameState>(context).selfPlayer.isHost
            ? FloatingActionButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  Provider.of<GameState>(context).manager.announceReset();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/lobby', (_) => false);
                },
              )
            : null,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("You are a ${myRole.symbol.name} with ${myRole.color.name}",
                style: TextStyle(fontSize: 18)),
            if (Provider.of<GameState>(context).customer.winner != null)
              Text(
                "${Provider.of<GameState>(context).customer.winner.fancyName} won!",
                style: TextStyle(fontSize: 24),
              )
            else if (Provider.of<GameState>(context).customer.myRole ==
                Provider.of<GameState>(context).customer.whoseTurn)
              Text(
                "It is your turn!",
                style: TextStyle(fontSize: 24),
              )
            else
              Text(
                "It is ${Provider.of<GameState>(context).customer.whoseTurn.fancyName}'s turn!",
                style: TextStyle(fontSize: 24),
              ),
            TicTacToeBoard(),
          ],
        )));
  }
}

import 'package:flutter/material.dart';
import 'package:minigames/TicTacToe.dart';
import 'package:minigames/main.dart';
import 'package:minigames/proto/tictactoe.pb.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayerWithRole myRole = Provider.of<GameState>(context).customer.myRole;
    return Scaffold(
        appBar: AppBar(
          title: Text('Game'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            Provider.of<GameState>(context).manager.nextTurn();
          },
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("You are a ${myRole.symbol.name} with ${myRole.color.name}",
                style: TextStyle(fontSize: 18)),
            if (Provider.of<GameState>(context).customer.myRole ==
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

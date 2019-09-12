import 'package:flutter/material.dart';
import 'package:minigames/proto/tictactoe.pbenum.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:minigames/proto/cell.pb.dart';

class CellWidget extends StatelessWidget {
  final Cell cell;

  CellWidget(this.cell);

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData symbol;
    try {
      Cell thisCell = cell;
      if (thisCell.hasColor()) {
        switch (thisCell.color) {
          case Cell_Color.black:
            color = Colors.black;
            break;
          case Cell_Color.blue:
            color = Colors.blue;
            break;
          case Cell_Color.red:
            color = Colors.red;
            break;
        }
      } else {
        color = Colors.purple;
      }
      if (thisCell.hasSymbol()) {
        switch (thisCell.symbol) {
          case Cell_Symbol.cross:
            symbol = Icons.close;
            break;
          case Cell_Symbol.circle:
            symbol = Icons.radio_button_unchecked;
            break;
          case Cell_Symbol.blank:
            symbol = Icons.help_outline;
            color = Colors.transparent;
        }
      } else {
        symbol = Icons.help;
      }
    } on RangeError {
      print("range error");
      symbol = Icons.help;
      color = Colors.black;
    }
    return InkWell(
        onTap: () {
          print("I am ${cell.x} ${cell.y}");
          //Provider.of<GameState>(context).setCellColor(cell.x, cell.y, Cell_Color.blue);
          //Provider.of<GameState>(context).setToRedO(cell.x, cell.y);
          if (Provider.of<GameState>(context).customer.myRole !=
              Provider.of<GameState>(context).customer.whoseTurn) {
            print(
                "It's ${Provider.of<GameState>(context).customer.whoseTurn.fancyName}'s turn!");
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                    "It's ${Provider.of<GameState>(context).customer.whoseTurn.fancyName}'s turn!")));
          } else if (cell.hasSymbol() && (cell.symbol != Cell_Symbol.blank)) {
            print("already played!");
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Cell already played")));
            print(cell.symbol.name);
          } else if (Provider.of<GameState>(context)
              .customer
              .myRole
              .hasSymbol()) {
            Cell_Color color;
            switch (Provider.of<GameState>(context).customer.myRole.color) {
              case PlayerWithRole_Color.black:
                color = Cell_Color.black;
                break;
              case PlayerWithRole_Color.red:
                color = Cell_Color.red;
                break;
              case PlayerWithRole_Color.blue:
                color = Cell_Color.blue;
                break;
            }
            Cell_Symbol symbol;
            switch (Provider.of<GameState>(context).customer.myRole.symbol) {
              case PlayerWithRole_Symbol.circle:
                symbol = Cell_Symbol.circle;
                break;
              case PlayerWithRole_Symbol.cross:
                symbol = Cell_Symbol.cross;
                break;
            }
            Provider.of<GameState>(context)
                .setCell(cell.x, cell.y, color, symbol);
          } else {
            print("no assigned");
          }
        },
        child: SizedBox(
            height: 80,
            width: 80,
            child: Icon(symbol, color: color, size: 48)));
    // SizedBox(height: 80, width: 80, child: Icon(Icons.close, color: Colors.red, size: 48));
    // Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 48),
  }
}

//enum Symbol {cross, circle, blank}

class TicTacToeBoard extends StatefulWidget {
  @override
  _TicTacToeBoardState createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 240,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Consumer<GameState>(builder: (_, gameState, __) {
          print(gameState.ticTacToeData[0][0]);
          return Table(
              border: TableBorder.symmetric(inside: BorderSide()),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  CellWidget(gameState.ticTacToeData[0][0]),
                  CellWidget(gameState.ticTacToeData[0][1]),
                  CellWidget(gameState.ticTacToeData[0][2]),
                ]),
                TableRow(children: [
                  CellWidget(gameState.ticTacToeData[1][0]),
                  CellWidget(gameState.ticTacToeData[1][1]),
                  CellWidget(gameState.ticTacToeData[1][2]),
                ]),
                TableRow(children: [
                  CellWidget(gameState.ticTacToeData[2][0]),
                  CellWidget(gameState.ticTacToeData[2][1]),
                  CellWidget(gameState.ticTacToeData[2][2]),
                ]),
              ]);
        }),
      ),
    );
  }
}

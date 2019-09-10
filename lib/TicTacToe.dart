import 'package:flutter/material.dart';
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
          Provider.of<GameState>(context).setToRandomSymbol(cell.x, cell.y);
        },
        onLongPress: () {
          Provider.of<GameState>(context).setToRandomColor(cell.x, cell.y);
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

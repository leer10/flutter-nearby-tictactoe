import 'package:piecemeal/piecemeal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:minigames/proto/cell.pb.dart';

class CellWidget extends StatelessWidget{
  final Cell cell;

  CellWidget(this.cell);

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData symbol;
    try {
    Cell thisCell = cell;
    if (thisCell. is Color) {color = thisCell[0];}
    if (thisCell[1] is Symbol) {
      switch (thisCell[1]){
        case Symbol.cross:
        symbol = Icons.close;
        break;
        case Symbol.circle:
        symbol = Icons.radio_button_unchecked;
        break;
        case Symbol.blank:
        symbol = Icons.help_outline;
        color = Colors.transparent;
      }
    } else {symbol = Icons.help;}}
    on RangeError {
      print("$x, $y has no data");
      symbol = Icons.help;
      color = Colors.black;
    }
    return InkWell(
      onTap: (){
        print("I am $x $y");
        Provider.of<GameState>(context).setToRedO(x, y);
      },
      child: SizedBox(height: 80, width: 80, child: Icon(symbol, color: color, size: 48)));
    // SizedBox(height: 80, width: 80, child: Icon(Icons.close, color: Colors.red, size: 48));
    // Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 48),
  }

}

//enum Symbol {cross, circle, blank}

class TicTacToeBoard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 240,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Table(
          border: TableBorder.symmetric(inside: BorderSide()),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Cell(0,0),
                Cell(0,1),
                Cell(0,2),
              ]
            ),TableRow(
              children: [
                Cell(1,0),
                Cell(1,1),
                Cell(1,2),
              ]
            ),TableRow(
              children: [
                Cell(2,0),
                Cell(2,1),
                Cell(2,2)
              ]
            ),
          ]
        ),
      ),
    );
  }

}

///
//  Generated code. Do not modify.
//  source: cell.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class Cell_Symbol extends $pb.ProtobufEnum {
  static const Cell_Symbol blank = Cell_Symbol._(0, 'blank');
  static const Cell_Symbol cross = Cell_Symbol._(1, 'cross');
  static const Cell_Symbol circle = Cell_Symbol._(2, 'circle');

  static const $core.List<Cell_Symbol> values = <Cell_Symbol> [
    blank,
    cross,
    circle,
  ];

  static final $core.Map<$core.int, Cell_Symbol> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Cell_Symbol valueOf($core.int value) => _byValue[value];

  const Cell_Symbol._($core.int v, $core.String n) : super(v, n);
}

class Cell_Color extends $pb.ProtobufEnum {
  static const Cell_Color black = Cell_Color._(0, 'black');
  static const Cell_Color blue = Cell_Color._(1, 'blue');
  static const Cell_Color red = Cell_Color._(2, 'red');

  static const $core.List<Cell_Color> values = <Cell_Color> [
    black,
    blue,
    red,
  ];

  static final $core.Map<$core.int, Cell_Color> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Cell_Color valueOf($core.int value) => _byValue[value];

  const Cell_Color._($core.int v, $core.String n) : super(v, n);
}


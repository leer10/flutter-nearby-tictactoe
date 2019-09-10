///
//  Generated code. Do not modify.
//  source: tictactoe
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class PlayerWithRole_Symbol extends $pb.ProtobufEnum {
  static const PlayerWithRole_Symbol cross = PlayerWithRole_Symbol._(0, 'cross');
  static const PlayerWithRole_Symbol circle = PlayerWithRole_Symbol._(1, 'circle');

  static const $core.List<PlayerWithRole_Symbol> values = <PlayerWithRole_Symbol> [
    cross,
    circle,
  ];

  static final $core.Map<$core.int, PlayerWithRole_Symbol> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PlayerWithRole_Symbol valueOf($core.int value) => _byValue[value];

  const PlayerWithRole_Symbol._($core.int v, $core.String n) : super(v, n);
}

class PlayerWithRole_Color extends $pb.ProtobufEnum {
  static const PlayerWithRole_Color red = PlayerWithRole_Color._(0, 'red');
  static const PlayerWithRole_Color blue = PlayerWithRole_Color._(1, 'blue');
  static const PlayerWithRole_Color black = PlayerWithRole_Color._(2, 'black');

  static const $core.List<PlayerWithRole_Color> values = <PlayerWithRole_Color> [
    red,
    blue,
    black,
  ];

  static final $core.Map<$core.int, PlayerWithRole_Color> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PlayerWithRole_Color valueOf($core.int value) => _byValue[value];

  const PlayerWithRole_Color._($core.int v, $core.String n) : super(v, n);
}


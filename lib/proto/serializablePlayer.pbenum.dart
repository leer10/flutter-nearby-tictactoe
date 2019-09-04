///
//  Generated code. Do not modify.
//  source: serializablePlayer.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class SerializablePlayer_ConnectionType extends $pb.ProtobufEnum {
  static const SerializablePlayer_ConnectionType Unknown = SerializablePlayer_ConnectionType._(0, 'Unknown');
  static const SerializablePlayer_ConnectionType Loopback = SerializablePlayer_ConnectionType._(1, 'Loopback');
  static const SerializablePlayer_ConnectionType Nearby = SerializablePlayer_ConnectionType._(2, 'Nearby');

  static const $core.List<SerializablePlayer_ConnectionType> values = <SerializablePlayer_ConnectionType> [
    Unknown,
    Loopback,
    Nearby,
  ];

  static final $core.Map<$core.int, SerializablePlayer_ConnectionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SerializablePlayer_ConnectionType valueOf($core.int value) => _byValue[value];

  const SerializablePlayer_ConnectionType._($core.int v, $core.String n) : super(v, n);
}


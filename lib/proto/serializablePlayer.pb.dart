///
//  Generated code. Do not modify.
//  source: serializablePlayer.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'serializablePlayer.pbenum.dart';

export 'serializablePlayer.pbenum.dart';

enum SerializablePlayer_ConnectionID {
  nearbyID, 
  notSet
}

class SerializablePlayer extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, SerializablePlayer_ConnectionID> _SerializablePlayer_ConnectionIDByTag = {
    9 : SerializablePlayer_ConnectionID.nearbyID,
    0 : SerializablePlayer_ConnectionID.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SerializablePlayer', package: const $pb.PackageName('minigames'))
    ..oo(0, [9])
    ..aOS(1, 'fancyName')
    ..a<$core.int>(2, 'id', $pb.PbFieldType.O3)
    ..aOB(3, 'isCreator')
    ..aOB(4, 'isHost')
    ..aOB(5, 'isSpectator')
    ..aOB(6, 'intentPlay')
    ..a<$core.int>(7, 'randomID', $pb.PbFieldType.O3)
    ..e<SerializablePlayer_ConnectionType>(8, 'connectionType', $pb.PbFieldType.OE, SerializablePlayer_ConnectionType.Unknown, SerializablePlayer_ConnectionType.valueOf, SerializablePlayer_ConnectionType.values)
    ..aOS(9, 'nearbyID')
    ..hasRequiredFields = false
  ;

  SerializablePlayer._() : super();
  factory SerializablePlayer() => create();
  factory SerializablePlayer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePlayer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SerializablePlayer clone() => SerializablePlayer()..mergeFromMessage(this);
  SerializablePlayer copyWith(void Function(SerializablePlayer) updates) => super.copyWith((message) => updates(message as SerializablePlayer));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePlayer create() => SerializablePlayer._();
  SerializablePlayer createEmptyInstance() => create();
  static $pb.PbList<SerializablePlayer> createRepeated() => $pb.PbList<SerializablePlayer>();
  static SerializablePlayer getDefault() => _defaultInstance ??= create()..freeze();
  static SerializablePlayer _defaultInstance;

  SerializablePlayer_ConnectionID whichConnectionID() => _SerializablePlayer_ConnectionIDByTag[$_whichOneof(0)];
  void clearConnectionID() => clearField($_whichOneof(0));

  $core.String get fancyName => $_getS(0, '');
  set fancyName($core.String v) { $_setString(0, v); }
  $core.bool hasFancyName() => $_has(0);
  void clearFancyName() => clearField(1);

  $core.int get id => $_get(1, 0);
  set id($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasId() => $_has(1);
  void clearId() => clearField(2);

  $core.bool get isCreator => $_get(2, false);
  set isCreator($core.bool v) { $_setBool(2, v); }
  $core.bool hasIsCreator() => $_has(2);
  void clearIsCreator() => clearField(3);

  $core.bool get isHost => $_get(3, false);
  set isHost($core.bool v) { $_setBool(3, v); }
  $core.bool hasIsHost() => $_has(3);
  void clearIsHost() => clearField(4);

  $core.bool get isSpectator => $_get(4, false);
  set isSpectator($core.bool v) { $_setBool(4, v); }
  $core.bool hasIsSpectator() => $_has(4);
  void clearIsSpectator() => clearField(5);

  $core.bool get intentPlay => $_get(5, false);
  set intentPlay($core.bool v) { $_setBool(5, v); }
  $core.bool hasIntentPlay() => $_has(5);
  void clearIntentPlay() => clearField(6);

  $core.int get randomID => $_get(6, 0);
  set randomID($core.int v) { $_setSignedInt32(6, v); }
  $core.bool hasRandomID() => $_has(6);
  void clearRandomID() => clearField(7);

  SerializablePlayer_ConnectionType get connectionType => $_getN(7);
  set connectionType(SerializablePlayer_ConnectionType v) { setField(8, v); }
  $core.bool hasConnectionType() => $_has(7);
  void clearConnectionType() => clearField(8);

  $core.String get nearbyID => $_getS(8, '');
  set nearbyID($core.String v) { $_setString(8, v); }
  $core.bool hasNearbyID() => $_has(8);
  void clearNearbyID() => clearField(9);
}

class SerializablePlayerList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SerializablePlayerList', package: const $pb.PackageName('minigames'))
    ..pc<SerializablePlayer>(1, 'players', $pb.PbFieldType.PM,SerializablePlayer.create)
    ..hasRequiredFields = false
  ;

  SerializablePlayerList._() : super();
  factory SerializablePlayerList() => create();
  factory SerializablePlayerList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePlayerList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SerializablePlayerList clone() => SerializablePlayerList()..mergeFromMessage(this);
  SerializablePlayerList copyWith(void Function(SerializablePlayerList) updates) => super.copyWith((message) => updates(message as SerializablePlayerList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePlayerList create() => SerializablePlayerList._();
  SerializablePlayerList createEmptyInstance() => create();
  static $pb.PbList<SerializablePlayerList> createRepeated() => $pb.PbList<SerializablePlayerList>();
  static SerializablePlayerList getDefault() => _defaultInstance ??= create()..freeze();
  static SerializablePlayerList _defaultInstance;

  $core.List<SerializablePlayer> get players => $_getList(0);
}


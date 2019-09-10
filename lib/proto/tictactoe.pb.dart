///
//  Generated code. Do not modify.
//  source: tictactoe
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'tictactoe.pbenum.dart';

export 'tictactoe.pbenum.dart';

class RoleList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RoleList', package: const $pb.PackageName('minigames'))
    ..pc<PlayerWithRole>(1, 'player', $pb.PbFieldType.PM,PlayerWithRole.create)
    ..hasRequiredFields = false
  ;

  RoleList._() : super();
  factory RoleList() => create();
  factory RoleList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoleList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RoleList clone() => RoleList()..mergeFromMessage(this);
  RoleList copyWith(void Function(RoleList) updates) => super.copyWith((message) => updates(message as RoleList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RoleList create() => RoleList._();
  RoleList createEmptyInstance() => create();
  static $pb.PbList<RoleList> createRepeated() => $pb.PbList<RoleList>();
  static RoleList getDefault() => _defaultInstance ??= create()..freeze();
  static RoleList _defaultInstance;

  $core.List<PlayerWithRole> get player => $_getList(0);
}

class PlayerWithRole extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PlayerWithRole', package: const $pb.PackageName('minigames'))
    ..aOS(1, 'uuid')
    ..aOS(2, 'fancyName')
    ..e<PlayerWithRole_Symbol>(3, 'symbol', $pb.PbFieldType.OE, PlayerWithRole_Symbol.cross, PlayerWithRole_Symbol.valueOf, PlayerWithRole_Symbol.values)
    ..e<PlayerWithRole_Color>(4, 'color', $pb.PbFieldType.OE, PlayerWithRole_Color.red, PlayerWithRole_Color.valueOf, PlayerWithRole_Color.values)
    ..hasRequiredFields = false
  ;

  PlayerWithRole._() : super();
  factory PlayerWithRole() => create();
  factory PlayerWithRole.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerWithRole.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PlayerWithRole clone() => PlayerWithRole()..mergeFromMessage(this);
  PlayerWithRole copyWith(void Function(PlayerWithRole) updates) => super.copyWith((message) => updates(message as PlayerWithRole));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerWithRole create() => PlayerWithRole._();
  PlayerWithRole createEmptyInstance() => create();
  static $pb.PbList<PlayerWithRole> createRepeated() => $pb.PbList<PlayerWithRole>();
  static PlayerWithRole getDefault() => _defaultInstance ??= create()..freeze();
  static PlayerWithRole _defaultInstance;

  $core.String get uuid => $_getS(0, '');
  set uuid($core.String v) { $_setString(0, v); }
  $core.bool hasUuid() => $_has(0);
  void clearUuid() => clearField(1);

  $core.String get fancyName => $_getS(1, '');
  set fancyName($core.String v) { $_setString(1, v); }
  $core.bool hasFancyName() => $_has(1);
  void clearFancyName() => clearField(2);

  PlayerWithRole_Symbol get symbol => $_getN(2);
  set symbol(PlayerWithRole_Symbol v) { setField(3, v); }
  $core.bool hasSymbol() => $_has(2);
  void clearSymbol() => clearField(3);

  PlayerWithRole_Color get color => $_getN(3);
  set color(PlayerWithRole_Color v) { setField(4, v); }
  $core.bool hasColor() => $_has(3);
  void clearColor() => clearField(4);
}


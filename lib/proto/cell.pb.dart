///
//  Generated code. Do not modify.
//  source: cell.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

export 'cell.pbenum.dart';

class Cell extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Cell', package: const $pb.PackageName('minigames'))
    ..hasRequiredFields = false
  ;

  Cell._() : super();
  factory Cell() => create();
  factory Cell.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Cell.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Cell clone() => Cell()..mergeFromMessage(this);
  Cell copyWith(void Function(Cell) updates) => super.copyWith((message) => updates(message as Cell));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Cell create() => Cell._();
  Cell createEmptyInstance() => create();
  static $pb.PbList<Cell> createRepeated() => $pb.PbList<Cell>();
  static Cell getDefault() => _defaultInstance ??= create()..freeze();
  static Cell _defaultInstance;
}


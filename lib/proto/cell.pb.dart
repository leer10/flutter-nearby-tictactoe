///
//  Generated code. Do not modify.
//  source: cell.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'cell.pbenum.dart';

export 'cell.pbenum.dart';

class Cell extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Cell', package: const $pb.PackageName('minigames'))
    ..a<$core.int>(1, 'x', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'y', $pb.PbFieldType.O3)
    ..e<Cell_Symbol>(3, 'symbol', $pb.PbFieldType.OE, Cell_Symbol.blank, Cell_Symbol.valueOf, Cell_Symbol.values)
    ..e<Cell_Color>(4, 'color', $pb.PbFieldType.OE, Cell_Color.black, Cell_Color.valueOf, Cell_Color.values)
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

  $core.int get x => $_get(0, 0);
  set x($core.int v) { $_setSignedInt32(0, v); }
  $core.bool hasX() => $_has(0);
  void clearX() => clearField(1);

  $core.int get y => $_get(1, 0);
  set y($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasY() => $_has(1);
  void clearY() => clearField(2);

  Cell_Symbol get symbol => $_getN(2);
  set symbol(Cell_Symbol v) { setField(3, v); }
  $core.bool hasSymbol() => $_has(2);
  void clearSymbol() => clearField(3);

  Cell_Color get color => $_getN(3);
  set color(Cell_Color v) { setField(4, v); }
  $core.bool hasColor() => $_has(3);
  void clearColor() => clearField(4);
}


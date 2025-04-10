// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../rezept.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Rezept _$RezeptFromJson(Map<String, dynamic> json) {
  return _Rezept.fromJson(json);
}

/// @nodoc
mixin _$Rezept {
  String get id => throw _privateConstructorUsedError;
  DateTime get ausgestelltAm => throw _privateConstructorUsedError;
  double get preisGesamt => throw _privateConstructorUsedError;
  IList<RezeptPos> get positionen => throw _privateConstructorUsedError;

  /// Serializes this Rezept to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RezeptCopyWith<Rezept> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RezeptCopyWith<$Res> {
  factory $RezeptCopyWith(Rezept value, $Res Function(Rezept) then) =
      _$RezeptCopyWithImpl<$Res, Rezept>;
  @useResult
  $Res call(
      {String id,
      DateTime ausgestelltAm,
      double preisGesamt,
      IList<RezeptPos> positionen});
}

/// @nodoc
class _$RezeptCopyWithImpl<$Res, $Val extends Rezept>
    implements $RezeptCopyWith<$Res> {
  _$RezeptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ausgestelltAm = null,
    Object? preisGesamt = null,
    Object? positionen = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ausgestelltAm: null == ausgestelltAm
          ? _value.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preisGesamt: null == preisGesamt
          ? _value.preisGesamt
          : preisGesamt // ignore: cast_nullable_to_non_nullable
              as double,
      positionen: null == positionen
          ? _value.positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as IList<RezeptPos>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RezeptImplCopyWith<$Res> implements $RezeptCopyWith<$Res> {
  factory _$$RezeptImplCopyWith(
          _$RezeptImpl value, $Res Function(_$RezeptImpl) then) =
      __$$RezeptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime ausgestelltAm,
      double preisGesamt,
      IList<RezeptPos> positionen});
}

/// @nodoc
class __$$RezeptImplCopyWithImpl<$Res>
    extends _$RezeptCopyWithImpl<$Res, _$RezeptImpl>
    implements _$$RezeptImplCopyWith<$Res> {
  __$$RezeptImplCopyWithImpl(
      _$RezeptImpl _value, $Res Function(_$RezeptImpl) _then)
      : super(_value, _then);

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ausgestelltAm = null,
    Object? preisGesamt = null,
    Object? positionen = null,
  }) {
    return _then(_$RezeptImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ausgestelltAm: null == ausgestelltAm
          ? _value.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preisGesamt: null == preisGesamt
          ? _value.preisGesamt
          : preisGesamt // ignore: cast_nullable_to_non_nullable
              as double,
      positionen: null == positionen
          ? _value.positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as IList<RezeptPos>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RezeptImpl extends _Rezept {
  const _$RezeptImpl(
      {required this.id,
      required this.ausgestelltAm,
      required this.preisGesamt,
      this.positionen = const IListConst([])})
      : super._();

  factory _$RezeptImpl.fromJson(Map<String, dynamic> json) =>
      _$$RezeptImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime ausgestelltAm;
  @override
  final double preisGesamt;
  @override
  @JsonKey()
  final IList<RezeptPos> positionen;

  @override
  String toString() {
    return 'Rezept(id: $id, ausgestelltAm: $ausgestelltAm, preisGesamt: $preisGesamt, positionen: $positionen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RezeptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            (identical(other.preisGesamt, preisGesamt) ||
                other.preisGesamt == preisGesamt) &&
            const DeepCollectionEquality()
                .equals(other.positionen, positionen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ausgestelltAm, preisGesamt,
      const DeepCollectionEquality().hash(positionen));

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RezeptImplCopyWith<_$RezeptImpl> get copyWith =>
      __$$RezeptImplCopyWithImpl<_$RezeptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RezeptImplToJson(
      this,
    );
  }
}

abstract class _Rezept extends Rezept {
  const factory _Rezept(
      {required final String id,
      required final DateTime ausgestelltAm,
      required final double preisGesamt,
      final IList<RezeptPos> positionen}) = _$RezeptImpl;
  const _Rezept._() : super._();

  factory _Rezept.fromJson(Map<String, dynamic> json) = _$RezeptImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get ausgestelltAm;
  @override
  double get preisGesamt;
  @override
  IList<RezeptPos> get positionen;

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RezeptImplCopyWith<_$RezeptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RezeptPos _$RezeptPosFromJson(Map<String, dynamic> json) {
  return _RezeptPos.fromJson(json);
}

/// @nodoc
mixin _$RezeptPos {
  int get anzahl => throw _privateConstructorUsedError;
  Behandlungsart get behandlungsart => throw _privateConstructorUsedError;

  /// Serializes this RezeptPos to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RezeptPosCopyWith<RezeptPos> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RezeptPosCopyWith<$Res> {
  factory $RezeptPosCopyWith(RezeptPos value, $Res Function(RezeptPos) then) =
      _$RezeptPosCopyWithImpl<$Res, RezeptPos>;
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class _$RezeptPosCopyWithImpl<$Res, $Val extends RezeptPos>
    implements $RezeptPosCopyWith<$Res> {
  _$RezeptPosCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anzahl = null,
    Object? behandlungsart = null,
  }) {
    return _then(_value.copyWith(
      anzahl: null == anzahl
          ? _value.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
      behandlungsart: null == behandlungsart
          ? _value.behandlungsart
          : behandlungsart // ignore: cast_nullable_to_non_nullable
              as Behandlungsart,
    ) as $Val);
  }

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BehandlungsartCopyWith<$Res> get behandlungsart {
    return $BehandlungsartCopyWith<$Res>(_value.behandlungsart, (value) {
      return _then(_value.copyWith(behandlungsart: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RezeptPosImplCopyWith<$Res>
    implements $RezeptPosCopyWith<$Res> {
  factory _$$RezeptPosImplCopyWith(
          _$RezeptPosImpl value, $Res Function(_$RezeptPosImpl) then) =
      __$$RezeptPosImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  @override
  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class __$$RezeptPosImplCopyWithImpl<$Res>
    extends _$RezeptPosCopyWithImpl<$Res, _$RezeptPosImpl>
    implements _$$RezeptPosImplCopyWith<$Res> {
  __$$RezeptPosImplCopyWithImpl(
      _$RezeptPosImpl _value, $Res Function(_$RezeptPosImpl) _then)
      : super(_value, _then);

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anzahl = null,
    Object? behandlungsart = null,
  }) {
    return _then(_$RezeptPosImpl(
      anzahl: null == anzahl
          ? _value.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
      behandlungsart: null == behandlungsart
          ? _value.behandlungsart
          : behandlungsart // ignore: cast_nullable_to_non_nullable
              as Behandlungsart,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RezeptPosImpl extends _RezeptPos {
  const _$RezeptPosImpl({required this.anzahl, required this.behandlungsart})
      : super._();

  factory _$RezeptPosImpl.fromJson(Map<String, dynamic> json) =>
      _$$RezeptPosImplFromJson(json);

  @override
  final int anzahl;
  @override
  final Behandlungsart behandlungsart;

  @override
  String toString() {
    return 'RezeptPos(anzahl: $anzahl, behandlungsart: $behandlungsart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RezeptPosImpl &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl) &&
            (identical(other.behandlungsart, behandlungsart) ||
                other.behandlungsart == behandlungsart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, anzahl, behandlungsart);

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RezeptPosImplCopyWith<_$RezeptPosImpl> get copyWith =>
      __$$RezeptPosImplCopyWithImpl<_$RezeptPosImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RezeptPosImplToJson(
      this,
    );
  }
}

abstract class _RezeptPos extends RezeptPos {
  const factory _RezeptPos(
      {required final int anzahl,
      required final Behandlungsart behandlungsart}) = _$RezeptPosImpl;
  const _RezeptPos._() : super._();

  factory _RezeptPos.fromJson(Map<String, dynamic> json) =
      _$RezeptPosImpl.fromJson;

  @override
  int get anzahl;
  @override
  Behandlungsart get behandlungsart;

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RezeptPosImplCopyWith<_$RezeptPosImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Behandlungsart _$BehandlungsartFromJson(Map<String, dynamic> json) {
  return _Behandlungsart.fromJson(json);
}

/// @nodoc
mixin _$Behandlungsart {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get preis => throw _privateConstructorUsedError;

  /// Serializes this Behandlungsart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BehandlungsartCopyWith<Behandlungsart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BehandlungsartCopyWith<$Res> {
  factory $BehandlungsartCopyWith(
          Behandlungsart value, $Res Function(Behandlungsart) then) =
      _$BehandlungsartCopyWithImpl<$Res, Behandlungsart>;
  @useResult
  $Res call({String id, String name, double preis});
}

/// @nodoc
class _$BehandlungsartCopyWithImpl<$Res, $Val extends Behandlungsart>
    implements $BehandlungsartCopyWith<$Res> {
  _$BehandlungsartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? preis = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      preis: null == preis
          ? _value.preis
          : preis // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BehandlungsartImplCopyWith<$Res>
    implements $BehandlungsartCopyWith<$Res> {
  factory _$$BehandlungsartImplCopyWith(_$BehandlungsartImpl value,
          $Res Function(_$BehandlungsartImpl) then) =
      __$$BehandlungsartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, double preis});
}

/// @nodoc
class __$$BehandlungsartImplCopyWithImpl<$Res>
    extends _$BehandlungsartCopyWithImpl<$Res, _$BehandlungsartImpl>
    implements _$$BehandlungsartImplCopyWith<$Res> {
  __$$BehandlungsartImplCopyWithImpl(
      _$BehandlungsartImpl _value, $Res Function(_$BehandlungsartImpl) _then)
      : super(_value, _then);

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? preis = null,
  }) {
    return _then(_$BehandlungsartImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      preis: null == preis
          ? _value.preis
          : preis // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BehandlungsartImpl extends _Behandlungsart {
  const _$BehandlungsartImpl(
      {required this.id, required this.name, required this.preis})
      : super._();

  factory _$BehandlungsartImpl.fromJson(Map<String, dynamic> json) =>
      _$$BehandlungsartImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double preis;

  @override
  String toString() {
    return 'Behandlungsart(id: $id, name: $name, preis: $preis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BehandlungsartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.preis, preis) || other.preis == preis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, preis);

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BehandlungsartImplCopyWith<_$BehandlungsartImpl> get copyWith =>
      __$$BehandlungsartImplCopyWithImpl<_$BehandlungsartImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BehandlungsartImplToJson(
      this,
    );
  }
}

abstract class _Behandlungsart extends Behandlungsart {
  const factory _Behandlungsart(
      {required final String id,
      required final String name,
      required final double preis}) = _$BehandlungsartImpl;
  const _Behandlungsart._() : super._();

  factory _Behandlungsart.fromJson(Map<String, dynamic> json) =
      _$BehandlungsartImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get preis;

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BehandlungsartImplCopyWith<_$BehandlungsartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

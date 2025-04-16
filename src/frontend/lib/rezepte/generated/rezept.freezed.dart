// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../rezept.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Rezept {
  String get id;
  @JsonKey(includeIfNull: false)
  String? get patientId;
  DateTime get ausgestelltAm;
  double get preisGesamt;
  IList<RezeptPos> get positionen;

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RezeptCopyWith<Rezept> get copyWith =>
      _$RezeptCopyWithImpl<Rezept>(this as Rezept, _$identity);

  /// Serializes this Rezept to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Rezept &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            (identical(other.preisGesamt, preisGesamt) ||
                other.preisGesamt == preisGesamt) &&
            const DeepCollectionEquality()
                .equals(other.positionen, positionen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, patientId, ausgestelltAm,
      preisGesamt, const DeepCollectionEquality().hash(positionen));

  @override
  String toString() {
    return 'Rezept(id: $id, patientId: $patientId, ausgestelltAm: $ausgestelltAm, preisGesamt: $preisGesamt, positionen: $positionen)';
  }
}

/// @nodoc
abstract mixin class $RezeptCopyWith<$Res> {
  factory $RezeptCopyWith(Rezept value, $Res Function(Rezept) _then) =
      _$RezeptCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(includeIfNull: false) String? patientId,
      DateTime ausgestelltAm,
      double preisGesamt,
      IList<RezeptPos> positionen});
}

/// @nodoc
class _$RezeptCopyWithImpl<$Res> implements $RezeptCopyWith<$Res> {
  _$RezeptCopyWithImpl(this._self, this._then);

  final Rezept _self;
  final $Res Function(Rezept) _then;

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = freezed,
    Object? ausgestelltAm = null,
    Object? preisGesamt = null,
    Object? positionen = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: freezed == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String?,
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preisGesamt: null == preisGesamt
          ? _self.preisGesamt
          : preisGesamt // ignore: cast_nullable_to_non_nullable
              as double,
      positionen: null == positionen
          ? _self.positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as IList<RezeptPos>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Rezept extends Rezept {
  const _Rezept(
      {required this.id,
      @JsonKey(includeIfNull: false) this.patientId,
      required this.ausgestelltAm,
      required this.preisGesamt,
      this.positionen = const IListConst([])})
      : super._();
  factory _Rezept.fromJson(Map<String, dynamic> json) => _$RezeptFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(includeIfNull: false)
  final String? patientId;
  @override
  final DateTime ausgestelltAm;
  @override
  final double preisGesamt;
  @override
  @JsonKey()
  final IList<RezeptPos> positionen;

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RezeptCopyWith<_Rezept> get copyWith =>
      __$RezeptCopyWithImpl<_Rezept>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RezeptToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Rezept &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            (identical(other.preisGesamt, preisGesamt) ||
                other.preisGesamt == preisGesamt) &&
            const DeepCollectionEquality()
                .equals(other.positionen, positionen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, patientId, ausgestelltAm,
      preisGesamt, const DeepCollectionEquality().hash(positionen));

  @override
  String toString() {
    return 'Rezept(id: $id, patientId: $patientId, ausgestelltAm: $ausgestelltAm, preisGesamt: $preisGesamt, positionen: $positionen)';
  }
}

/// @nodoc
abstract mixin class _$RezeptCopyWith<$Res> implements $RezeptCopyWith<$Res> {
  factory _$RezeptCopyWith(_Rezept value, $Res Function(_Rezept) _then) =
      __$RezeptCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(includeIfNull: false) String? patientId,
      DateTime ausgestelltAm,
      double preisGesamt,
      IList<RezeptPos> positionen});
}

/// @nodoc
class __$RezeptCopyWithImpl<$Res> implements _$RezeptCopyWith<$Res> {
  __$RezeptCopyWithImpl(this._self, this._then);

  final _Rezept _self;
  final $Res Function(_Rezept) _then;

  /// Create a copy of Rezept
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? patientId = freezed,
    Object? ausgestelltAm = null,
    Object? preisGesamt = null,
    Object? positionen = null,
  }) {
    return _then(_Rezept(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: freezed == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String?,
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preisGesamt: null == preisGesamt
          ? _self.preisGesamt
          : preisGesamt // ignore: cast_nullable_to_non_nullable
              as double,
      positionen: null == positionen
          ? _self.positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as IList<RezeptPos>,
    ));
  }
}

/// @nodoc
mixin _$RezeptPos {
  int get anzahl;
  Behandlungsart get behandlungsart;

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RezeptPosCopyWith<RezeptPos> get copyWith =>
      _$RezeptPosCopyWithImpl<RezeptPos>(this as RezeptPos, _$identity);

  /// Serializes this RezeptPos to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RezeptPos &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl) &&
            (identical(other.behandlungsart, behandlungsart) ||
                other.behandlungsart == behandlungsart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, anzahl, behandlungsart);

  @override
  String toString() {
    return 'RezeptPos(anzahl: $anzahl, behandlungsart: $behandlungsart)';
  }
}

/// @nodoc
abstract mixin class $RezeptPosCopyWith<$Res> {
  factory $RezeptPosCopyWith(RezeptPos value, $Res Function(RezeptPos) _then) =
      _$RezeptPosCopyWithImpl;
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class _$RezeptPosCopyWithImpl<$Res> implements $RezeptPosCopyWith<$Res> {
  _$RezeptPosCopyWithImpl(this._self, this._then);

  final RezeptPos _self;
  final $Res Function(RezeptPos) _then;

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anzahl = null,
    Object? behandlungsart = null,
  }) {
    return _then(_self.copyWith(
      anzahl: null == anzahl
          ? _self.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
      behandlungsart: null == behandlungsart
          ? _self.behandlungsart
          : behandlungsart // ignore: cast_nullable_to_non_nullable
              as Behandlungsart,
    ));
  }

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BehandlungsartCopyWith<$Res> get behandlungsart {
    return $BehandlungsartCopyWith<$Res>(_self.behandlungsart, (value) {
      return _then(_self.copyWith(behandlungsart: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _RezeptPos extends RezeptPos {
  const _RezeptPos({required this.anzahl, required this.behandlungsart})
      : super._();
  factory _RezeptPos.fromJson(Map<String, dynamic> json) =>
      _$RezeptPosFromJson(json);

  @override
  final int anzahl;
  @override
  final Behandlungsart behandlungsart;

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RezeptPosCopyWith<_RezeptPos> get copyWith =>
      __$RezeptPosCopyWithImpl<_RezeptPos>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RezeptPosToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RezeptPos &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl) &&
            (identical(other.behandlungsart, behandlungsart) ||
                other.behandlungsart == behandlungsart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, anzahl, behandlungsart);

  @override
  String toString() {
    return 'RezeptPos(anzahl: $anzahl, behandlungsart: $behandlungsart)';
  }
}

/// @nodoc
abstract mixin class _$RezeptPosCopyWith<$Res>
    implements $RezeptPosCopyWith<$Res> {
  factory _$RezeptPosCopyWith(
          _RezeptPos value, $Res Function(_RezeptPos) _then) =
      __$RezeptPosCopyWithImpl;
  @override
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  @override
  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class __$RezeptPosCopyWithImpl<$Res> implements _$RezeptPosCopyWith<$Res> {
  __$RezeptPosCopyWithImpl(this._self, this._then);

  final _RezeptPos _self;
  final $Res Function(_RezeptPos) _then;

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? anzahl = null,
    Object? behandlungsart = null,
  }) {
    return _then(_RezeptPos(
      anzahl: null == anzahl
          ? _self.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
      behandlungsart: null == behandlungsart
          ? _self.behandlungsart
          : behandlungsart // ignore: cast_nullable_to_non_nullable
              as Behandlungsart,
    ));
  }

  /// Create a copy of RezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BehandlungsartCopyWith<$Res> get behandlungsart {
    return $BehandlungsartCopyWith<$Res>(_self.behandlungsart, (value) {
      return _then(_self.copyWith(behandlungsart: value));
    });
  }
}

/// @nodoc
mixin _$Behandlungsart {
  String get id;
  String get name;
  double get preis;

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BehandlungsartCopyWith<Behandlungsart> get copyWith =>
      _$BehandlungsartCopyWithImpl<Behandlungsart>(
          this as Behandlungsart, _$identity);

  /// Serializes this Behandlungsart to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Behandlungsart &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.preis, preis) || other.preis == preis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, preis);

  @override
  String toString() {
    return 'Behandlungsart(id: $id, name: $name, preis: $preis)';
  }
}

/// @nodoc
abstract mixin class $BehandlungsartCopyWith<$Res> {
  factory $BehandlungsartCopyWith(
          Behandlungsart value, $Res Function(Behandlungsart) _then) =
      _$BehandlungsartCopyWithImpl;
  @useResult
  $Res call({String id, String name, double preis});
}

/// @nodoc
class _$BehandlungsartCopyWithImpl<$Res>
    implements $BehandlungsartCopyWith<$Res> {
  _$BehandlungsartCopyWithImpl(this._self, this._then);

  final Behandlungsart _self;
  final $Res Function(Behandlungsart) _then;

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? preis = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      preis: null == preis
          ? _self.preis
          : preis // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Behandlungsart extends Behandlungsart {
  const _Behandlungsart(
      {required this.id, required this.name, required this.preis})
      : super._();
  factory _Behandlungsart.fromJson(Map<String, dynamic> json) =>
      _$BehandlungsartFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double preis;

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BehandlungsartCopyWith<_Behandlungsart> get copyWith =>
      __$BehandlungsartCopyWithImpl<_Behandlungsart>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BehandlungsartToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Behandlungsart &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.preis, preis) || other.preis == preis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, preis);

  @override
  String toString() {
    return 'Behandlungsart(id: $id, name: $name, preis: $preis)';
  }
}

/// @nodoc
abstract mixin class _$BehandlungsartCopyWith<$Res>
    implements $BehandlungsartCopyWith<$Res> {
  factory _$BehandlungsartCopyWith(
          _Behandlungsart value, $Res Function(_Behandlungsart) _then) =
      __$BehandlungsartCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, double preis});
}

/// @nodoc
class __$BehandlungsartCopyWithImpl<$Res>
    implements _$BehandlungsartCopyWith<$Res> {
  __$BehandlungsartCopyWithImpl(this._self, this._then);

  final _Behandlungsart _self;
  final $Res Function(_Behandlungsart) _then;

  /// Create a copy of Behandlungsart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? preis = null,
  }) {
    return _then(_Behandlungsart(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      preis: null == preis
          ? _self.preis
          : preis // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on

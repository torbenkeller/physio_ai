// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../rezept_form_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RezeptFormDto {
  String get patientId;
  DateTime get ausgestelltAm;
  List<RezeptPositionDto> get positionen;

  /// Create a copy of RezeptFormDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RezeptFormDtoCopyWith<RezeptFormDto> get copyWith =>
      _$RezeptFormDtoCopyWithImpl<RezeptFormDto>(
          this as RezeptFormDto, _$identity);

  /// Serializes this RezeptFormDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RezeptFormDto &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            const DeepCollectionEquality()
                .equals(other.positionen, positionen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, patientId, ausgestelltAm,
      const DeepCollectionEquality().hash(positionen));

  @override
  String toString() {
    return 'RezeptFormDto(patientId: $patientId, ausgestelltAm: $ausgestelltAm, positionen: $positionen)';
  }
}

/// @nodoc
abstract mixin class $RezeptFormDtoCopyWith<$Res> {
  factory $RezeptFormDtoCopyWith(
          RezeptFormDto value, $Res Function(RezeptFormDto) _then) =
      _$RezeptFormDtoCopyWithImpl;
  @useResult
  $Res call(
      {String patientId,
      DateTime ausgestelltAm,
      List<RezeptPositionDto> positionen});
}

/// @nodoc
class _$RezeptFormDtoCopyWithImpl<$Res>
    implements $RezeptFormDtoCopyWith<$Res> {
  _$RezeptFormDtoCopyWithImpl(this._self, this._then);

  final RezeptFormDto _self;
  final $Res Function(RezeptFormDto) _then;

  /// Create a copy of RezeptFormDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? ausgestelltAm = null,
    Object? positionen = null,
  }) {
    return _then(_self.copyWith(
      patientId: null == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      positionen: null == positionen
          ? _self.positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as List<RezeptPositionDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RezeptFormDto extends RezeptFormDto {
  const _RezeptFormDto(
      {required this.patientId,
      required this.ausgestelltAm,
      required final List<RezeptPositionDto> positionen})
      : _positionen = positionen,
        super._();
  factory _RezeptFormDto.fromJson(Map<String, dynamic> json) =>
      _$RezeptFormDtoFromJson(json);

  @override
  final String patientId;
  @override
  final DateTime ausgestelltAm;
  final List<RezeptPositionDto> _positionen;
  @override
  List<RezeptPositionDto> get positionen {
    if (_positionen is EqualUnmodifiableListView) return _positionen;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_positionen);
  }

  /// Create a copy of RezeptFormDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RezeptFormDtoCopyWith<_RezeptFormDto> get copyWith =>
      __$RezeptFormDtoCopyWithImpl<_RezeptFormDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RezeptFormDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RezeptFormDto &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            const DeepCollectionEquality()
                .equals(other._positionen, _positionen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, patientId, ausgestelltAm,
      const DeepCollectionEquality().hash(_positionen));

  @override
  String toString() {
    return 'RezeptFormDto(patientId: $patientId, ausgestelltAm: $ausgestelltAm, positionen: $positionen)';
  }
}

/// @nodoc
abstract mixin class _$RezeptFormDtoCopyWith<$Res>
    implements $RezeptFormDtoCopyWith<$Res> {
  factory _$RezeptFormDtoCopyWith(
          _RezeptFormDto value, $Res Function(_RezeptFormDto) _then) =
      __$RezeptFormDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String patientId,
      DateTime ausgestelltAm,
      List<RezeptPositionDto> positionen});
}

/// @nodoc
class __$RezeptFormDtoCopyWithImpl<$Res>
    implements _$RezeptFormDtoCopyWith<$Res> {
  __$RezeptFormDtoCopyWithImpl(this._self, this._then);

  final _RezeptFormDto _self;
  final $Res Function(_RezeptFormDto) _then;

  /// Create a copy of RezeptFormDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? patientId = null,
    Object? ausgestelltAm = null,
    Object? positionen = null,
  }) {
    return _then(_RezeptFormDto(
      patientId: null == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      positionen: null == positionen
          ? _self._positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as List<RezeptPositionDto>,
    ));
  }
}

/// @nodoc
mixin _$RezeptPositionDto {
  String get behandlungsartId;
  int get anzahl;

  /// Create a copy of RezeptPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RezeptPositionDtoCopyWith<RezeptPositionDto> get copyWith =>
      _$RezeptPositionDtoCopyWithImpl<RezeptPositionDto>(
          this as RezeptPositionDto, _$identity);

  /// Serializes this RezeptPositionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RezeptPositionDto &&
            (identical(other.behandlungsartId, behandlungsartId) ||
                other.behandlungsartId == behandlungsartId) &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, behandlungsartId, anzahl);

  @override
  String toString() {
    return 'RezeptPositionDto(behandlungsartId: $behandlungsartId, anzahl: $anzahl)';
  }
}

/// @nodoc
abstract mixin class $RezeptPositionDtoCopyWith<$Res> {
  factory $RezeptPositionDtoCopyWith(
          RezeptPositionDto value, $Res Function(RezeptPositionDto) _then) =
      _$RezeptPositionDtoCopyWithImpl;
  @useResult
  $Res call({String behandlungsartId, int anzahl});
}

/// @nodoc
class _$RezeptPositionDtoCopyWithImpl<$Res>
    implements $RezeptPositionDtoCopyWith<$Res> {
  _$RezeptPositionDtoCopyWithImpl(this._self, this._then);

  final RezeptPositionDto _self;
  final $Res Function(RezeptPositionDto) _then;

  /// Create a copy of RezeptPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? behandlungsartId = null,
    Object? anzahl = null,
  }) {
    return _then(_self.copyWith(
      behandlungsartId: null == behandlungsartId
          ? _self.behandlungsartId
          : behandlungsartId // ignore: cast_nullable_to_non_nullable
              as String,
      anzahl: null == anzahl
          ? _self.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RezeptPositionDto extends RezeptPositionDto {
  const _RezeptPositionDto(
      {required this.behandlungsartId, required this.anzahl})
      : super._();
  factory _RezeptPositionDto.fromJson(Map<String, dynamic> json) =>
      _$RezeptPositionDtoFromJson(json);

  @override
  final String behandlungsartId;
  @override
  final int anzahl;

  /// Create a copy of RezeptPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RezeptPositionDtoCopyWith<_RezeptPositionDto> get copyWith =>
      __$RezeptPositionDtoCopyWithImpl<_RezeptPositionDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RezeptPositionDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RezeptPositionDto &&
            (identical(other.behandlungsartId, behandlungsartId) ||
                other.behandlungsartId == behandlungsartId) &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, behandlungsartId, anzahl);

  @override
  String toString() {
    return 'RezeptPositionDto(behandlungsartId: $behandlungsartId, anzahl: $anzahl)';
  }
}

/// @nodoc
abstract mixin class _$RezeptPositionDtoCopyWith<$Res>
    implements $RezeptPositionDtoCopyWith<$Res> {
  factory _$RezeptPositionDtoCopyWith(
          _RezeptPositionDto value, $Res Function(_RezeptPositionDto) _then) =
      __$RezeptPositionDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String behandlungsartId, int anzahl});
}

/// @nodoc
class __$RezeptPositionDtoCopyWithImpl<$Res>
    implements _$RezeptPositionDtoCopyWith<$Res> {
  __$RezeptPositionDtoCopyWithImpl(this._self, this._then);

  final _RezeptPositionDto _self;
  final $Res Function(_RezeptPositionDto) _then;

  /// Create a copy of RezeptPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? behandlungsartId = null,
    Object? anzahl = null,
  }) {
    return _then(_RezeptPositionDto(
      behandlungsartId: null == behandlungsartId
          ? _self.behandlungsartId
          : behandlungsartId // ignore: cast_nullable_to_non_nullable
              as String,
      anzahl: null == anzahl
          ? _self.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on

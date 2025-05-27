// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../behandlung_form_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BehandlungFormDto {
  String get patientId;
  DateTime get startZeit;
  DateTime get endZeit;
  String? get rezeptId;

  /// Create a copy of BehandlungFormDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BehandlungFormDtoCopyWith<BehandlungFormDto> get copyWith =>
      _$BehandlungFormDtoCopyWithImpl<BehandlungFormDto>(
          this as BehandlungFormDto, _$identity);

  /// Serializes this BehandlungFormDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BehandlungFormDto &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.startZeit, startZeit) ||
                other.startZeit == startZeit) &&
            (identical(other.endZeit, endZeit) || other.endZeit == endZeit) &&
            (identical(other.rezeptId, rezeptId) ||
                other.rezeptId == rezeptId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, patientId, startZeit, endZeit, rezeptId);

  @override
  String toString() {
    return 'BehandlungFormDto(patientId: $patientId, startZeit: $startZeit, endZeit: $endZeit, rezeptId: $rezeptId)';
  }
}

/// @nodoc
abstract mixin class $BehandlungFormDtoCopyWith<$Res> {
  factory $BehandlungFormDtoCopyWith(
          BehandlungFormDto value, $Res Function(BehandlungFormDto) _then) =
      _$BehandlungFormDtoCopyWithImpl;
  @useResult
  $Res call(
      {String patientId,
      DateTime startZeit,
      DateTime endZeit,
      String? rezeptId});
}

/// @nodoc
class _$BehandlungFormDtoCopyWithImpl<$Res>
    implements $BehandlungFormDtoCopyWith<$Res> {
  _$BehandlungFormDtoCopyWithImpl(this._self, this._then);

  final BehandlungFormDto _self;
  final $Res Function(BehandlungFormDto) _then;

  /// Create a copy of BehandlungFormDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? startZeit = null,
    Object? endZeit = null,
    Object? rezeptId = freezed,
  }) {
    return _then(_self.copyWith(
      patientId: null == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      startZeit: null == startZeit
          ? _self.startZeit
          : startZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endZeit: null == endZeit
          ? _self.endZeit
          : endZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rezeptId: freezed == rezeptId
          ? _self.rezeptId
          : rezeptId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BehandlungFormDto implements BehandlungFormDto {
  const _BehandlungFormDto(
      {required this.patientId,
      required this.startZeit,
      required this.endZeit,
      this.rezeptId});
  factory _BehandlungFormDto.fromJson(Map<String, dynamic> json) =>
      _$BehandlungFormDtoFromJson(json);

  @override
  final String patientId;
  @override
  final DateTime startZeit;
  @override
  final DateTime endZeit;
  @override
  final String? rezeptId;

  /// Create a copy of BehandlungFormDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BehandlungFormDtoCopyWith<_BehandlungFormDto> get copyWith =>
      __$BehandlungFormDtoCopyWithImpl<_BehandlungFormDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BehandlungFormDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BehandlungFormDto &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.startZeit, startZeit) ||
                other.startZeit == startZeit) &&
            (identical(other.endZeit, endZeit) || other.endZeit == endZeit) &&
            (identical(other.rezeptId, rezeptId) ||
                other.rezeptId == rezeptId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, patientId, startZeit, endZeit, rezeptId);

  @override
  String toString() {
    return 'BehandlungFormDto(patientId: $patientId, startZeit: $startZeit, endZeit: $endZeit, rezeptId: $rezeptId)';
  }
}

/// @nodoc
abstract mixin class _$BehandlungFormDtoCopyWith<$Res>
    implements $BehandlungFormDtoCopyWith<$Res> {
  factory _$BehandlungFormDtoCopyWith(
          _BehandlungFormDto value, $Res Function(_BehandlungFormDto) _then) =
      __$BehandlungFormDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String patientId,
      DateTime startZeit,
      DateTime endZeit,
      String? rezeptId});
}

/// @nodoc
class __$BehandlungFormDtoCopyWithImpl<$Res>
    implements _$BehandlungFormDtoCopyWith<$Res> {
  __$BehandlungFormDtoCopyWithImpl(this._self, this._then);

  final _BehandlungFormDto _self;
  final $Res Function(_BehandlungFormDto) _then;

  /// Create a copy of BehandlungFormDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? patientId = null,
    Object? startZeit = null,
    Object? endZeit = null,
    Object? rezeptId = freezed,
  }) {
    return _then(_BehandlungFormDto(
      patientId: null == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      startZeit: null == startZeit
          ? _self.startZeit
          : startZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endZeit: null == endZeit
          ? _self.endZeit
          : endZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rezeptId: freezed == rezeptId
          ? _self.rezeptId
          : rezeptId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

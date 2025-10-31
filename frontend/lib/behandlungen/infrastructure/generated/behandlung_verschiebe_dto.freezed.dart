// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../behandlung_verschiebe_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BehandlungVerschiebeDto {

 DateTime get nach;
/// Create a copy of BehandlungVerschiebeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BehandlungVerschiebeDtoCopyWith<BehandlungVerschiebeDto> get copyWith => _$BehandlungVerschiebeDtoCopyWithImpl<BehandlungVerschiebeDto>(this as BehandlungVerschiebeDto, _$identity);

  /// Serializes this BehandlungVerschiebeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BehandlungVerschiebeDto&&(identical(other.nach, nach) || other.nach == nach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nach);

@override
String toString() {
  return 'BehandlungVerschiebeDto(nach: $nach)';
}


}

/// @nodoc
abstract mixin class $BehandlungVerschiebeDtoCopyWith<$Res>  {
  factory $BehandlungVerschiebeDtoCopyWith(BehandlungVerschiebeDto value, $Res Function(BehandlungVerschiebeDto) _then) = _$BehandlungVerschiebeDtoCopyWithImpl;
@useResult
$Res call({
 DateTime nach
});




}
/// @nodoc
class _$BehandlungVerschiebeDtoCopyWithImpl<$Res>
    implements $BehandlungVerschiebeDtoCopyWith<$Res> {
  _$BehandlungVerschiebeDtoCopyWithImpl(this._self, this._then);

  final BehandlungVerschiebeDto _self;
  final $Res Function(BehandlungVerschiebeDto) _then;

/// Create a copy of BehandlungVerschiebeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nach = null,}) {
  return _then(_self.copyWith(
nach: null == nach ? _self.nach : nach // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BehandlungVerschiebeDto extends BehandlungVerschiebeDto {
  const _BehandlungVerschiebeDto({required this.nach}): super._();
  factory _BehandlungVerschiebeDto.fromJson(Map<String, dynamic> json) => _$BehandlungVerschiebeDtoFromJson(json);

@override final  DateTime nach;

/// Create a copy of BehandlungVerschiebeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BehandlungVerschiebeDtoCopyWith<_BehandlungVerschiebeDto> get copyWith => __$BehandlungVerschiebeDtoCopyWithImpl<_BehandlungVerschiebeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BehandlungVerschiebeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BehandlungVerschiebeDto&&(identical(other.nach, nach) || other.nach == nach));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nach);

@override
String toString() {
  return 'BehandlungVerschiebeDto(nach: $nach)';
}


}

/// @nodoc
abstract mixin class _$BehandlungVerschiebeDtoCopyWith<$Res> implements $BehandlungVerschiebeDtoCopyWith<$Res> {
  factory _$BehandlungVerschiebeDtoCopyWith(_BehandlungVerschiebeDto value, $Res Function(_BehandlungVerschiebeDto) _then) = __$BehandlungVerschiebeDtoCopyWithImpl;
@override @useResult
$Res call({
 DateTime nach
});




}
/// @nodoc
class __$BehandlungVerschiebeDtoCopyWithImpl<$Res>
    implements _$BehandlungVerschiebeDtoCopyWith<$Res> {
  __$BehandlungVerschiebeDtoCopyWithImpl(this._self, this._then);

  final _BehandlungVerschiebeDto _self;
  final $Res Function(_BehandlungVerschiebeDto) _then;

/// Create a copy of BehandlungVerschiebeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nach = null,}) {
  return _then(_BehandlungVerschiebeDto(
nach: null == nach ? _self.nach : nach // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

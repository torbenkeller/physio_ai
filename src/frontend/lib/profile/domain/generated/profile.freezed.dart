// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {
  String get id;
  String get praxisName;
  String get inhaberName;
  String? get profilePictureUrl;
  String? get calenderUrl;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<Profile> get copyWith =>
      _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Profile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.praxisName, praxisName) ||
                other.praxisName == praxisName) &&
            (identical(other.inhaberName, inhaberName) ||
                other.inhaberName == inhaberName) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.calenderUrl, calenderUrl) ||
                other.calenderUrl == calenderUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, praxisName, inhaberName, profilePictureUrl, calenderUrl);

  @override
  String toString() {
    return 'Profile(id: $id, praxisName: $praxisName, inhaberName: $inhaberName, profilePictureUrl: $profilePictureUrl, calenderUrl: $calenderUrl)';
  }
}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) =
      _$ProfileCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String praxisName,
      String inhaberName,
      String? profilePictureUrl,
      String? calenderUrl});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res> implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? praxisName = null,
    Object? inhaberName = null,
    Object? profilePictureUrl = freezed,
    Object? calenderUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      praxisName: null == praxisName
          ? _self.praxisName
          : praxisName // ignore: cast_nullable_to_non_nullable
              as String,
      inhaberName: null == inhaberName
          ? _self.inhaberName
          : inhaberName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePictureUrl: freezed == profilePictureUrl
          ? _self.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      calenderUrl: freezed == calenderUrl
          ? _self.calenderUrl
          : calenderUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Profile implements Profile {
  const _Profile(
      {required this.id,
      required this.praxisName,
      required this.inhaberName,
      this.profilePictureUrl,
      this.calenderUrl});
  factory _Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  @override
  final String id;
  @override
  final String praxisName;
  @override
  final String inhaberName;
  @override
  final String? profilePictureUrl;
  @override
  final String? calenderUrl;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileCopyWith<_Profile> get copyWith =>
      __$ProfileCopyWithImpl<_Profile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Profile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.praxisName, praxisName) ||
                other.praxisName == praxisName) &&
            (identical(other.inhaberName, inhaberName) ||
                other.inhaberName == inhaberName) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.calenderUrl, calenderUrl) ||
                other.calenderUrl == calenderUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, praxisName, inhaberName, profilePictureUrl, calenderUrl);

  @override
  String toString() {
    return 'Profile(id: $id, praxisName: $praxisName, inhaberName: $inhaberName, profilePictureUrl: $profilePictureUrl, calenderUrl: $calenderUrl)';
  }
}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) =
      __$ProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String praxisName,
      String inhaberName,
      String? profilePictureUrl,
      String? calenderUrl});
}

/// @nodoc
class __$ProfileCopyWithImpl<$Res> implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? praxisName = null,
    Object? inhaberName = null,
    Object? profilePictureUrl = freezed,
    Object? calenderUrl = freezed,
  }) {
    return _then(_Profile(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      praxisName: null == praxisName
          ? _self.praxisName
          : praxisName // ignore: cast_nullable_to_non_nullable
              as String,
      inhaberName: null == inhaberName
          ? _self.inhaberName
          : inhaberName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePictureUrl: freezed == profilePictureUrl
          ? _self.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      calenderUrl: freezed == calenderUrl
          ? _self.calenderUrl
          : calenderUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

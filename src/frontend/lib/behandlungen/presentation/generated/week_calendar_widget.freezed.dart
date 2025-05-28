// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../behandlungen_week_calendar_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarEvent {
  String get id;
  DateTime get startTime;
  DateTime get endTime;
  String get title;
  Color? get color;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarEventCopyWith<CalendarEvent> get copyWith =>
      _$CalendarEventCopyWithImpl<CalendarEvent>(this as CalendarEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) || other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime, title, color);

  @override
  String toString() {
    return 'CalendarEvent(id: $id, startTime: $startTime, endTime: $endTime, title: $title, color: $color)';
  }
}

/// @nodoc
abstract mixin class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(CalendarEvent value, $Res Function(CalendarEvent) _then) =
      _$CalendarEventCopyWithImpl;
  @useResult
  $Res call({String id, DateTime startTime, DateTime endTime, String title, Color? color});
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res> implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._self, this._then);

  final CalendarEvent _self;
  final $Res Function(CalendarEvent) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? title = null,
    Object? color = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color?,
    ));
  }
}

/// @nodoc

class _CalendarEvent extends CalendarEvent {
  const _CalendarEvent(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.title,
      this.color})
      : super._();

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String title;
  @override
  final Color? color;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CalendarEventCopyWith<_CalendarEvent> get copyWith =>
      __$CalendarEventCopyWithImpl<_CalendarEvent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CalendarEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) || other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime, title, color);

  @override
  String toString() {
    return 'CalendarEvent(id: $id, startTime: $startTime, endTime: $endTime, title: $title, color: $color)';
  }
}

/// @nodoc
abstract mixin class _$CalendarEventCopyWith<$Res> implements $CalendarEventCopyWith<$Res> {
  factory _$CalendarEventCopyWith(_CalendarEvent value, $Res Function(_CalendarEvent) _then) =
      __$CalendarEventCopyWithImpl;
  @override
  @useResult
  $Res call({String id, DateTime startTime, DateTime endTime, String title, Color? color});
}

/// @nodoc
class __$CalendarEventCopyWithImpl<$Res> implements _$CalendarEventCopyWith<$Res> {
  __$CalendarEventCopyWithImpl(this._self, this._then);

  final _CalendarEvent _self;
  final $Res Function(_CalendarEvent) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? title = null,
    Object? color = freezed,
  }) {
    return _then(_CalendarEvent(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color?,
    ));
  }
}

/// @nodoc
mixin _$EventDialogInfo {
  String get title;
  String get timeRange;
  String? get subtitle;
  String? get description;
  List<String>? get details;

  /// Create a copy of EventDialogInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EventDialogInfoCopyWith<EventDialogInfo> get copyWith =>
      _$EventDialogInfoCopyWithImpl<EventDialogInfo>(this as EventDialogInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EventDialogInfo &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.timeRange, timeRange) || other.timeRange == timeRange) &&
            (identical(other.subtitle, subtitle) || other.subtitle == subtitle) &&
            (identical(other.description, description) || other.description == description) &&
            const DeepCollectionEquality().equals(other.details, details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, timeRange, subtitle, description,
      const DeepCollectionEquality().hash(details));

  @override
  String toString() {
    return 'EventDialogInfo(title: $title, timeRange: $timeRange, subtitle: $subtitle, description: $description, details: $details)';
  }
}

/// @nodoc
abstract mixin class $EventDialogInfoCopyWith<$Res> {
  factory $EventDialogInfoCopyWith(EventDialogInfo value, $Res Function(EventDialogInfo) _then) =
      _$EventDialogInfoCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String timeRange,
      String? subtitle,
      String? description,
      List<String>? details});
}

/// @nodoc
class _$EventDialogInfoCopyWithImpl<$Res> implements $EventDialogInfoCopyWith<$Res> {
  _$EventDialogInfoCopyWithImpl(this._self, this._then);

  final EventDialogInfo _self;
  final $Res Function(EventDialogInfo) _then;

  /// Create a copy of EventDialogInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? timeRange = null,
    Object? subtitle = freezed,
    Object? description = freezed,
    Object? details = freezed,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      timeRange: null == timeRange
          ? _self.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _self.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      details: freezed == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _EventDialogInfo implements EventDialogInfo {
  const _EventDialogInfo(
      {required this.title,
      required this.timeRange,
      this.subtitle,
      this.description,
      final List<String>? details})
      : _details = details;

  @override
  final String title;
  @override
  final String timeRange;
  @override
  final String? subtitle;
  @override
  final String? description;
  final List<String>? _details;
  @override
  List<String>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of EventDialogInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EventDialogInfoCopyWith<_EventDialogInfo> get copyWith =>
      __$EventDialogInfoCopyWithImpl<_EventDialogInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EventDialogInfo &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.timeRange, timeRange) || other.timeRange == timeRange) &&
            (identical(other.subtitle, subtitle) || other.subtitle == subtitle) &&
            (identical(other.description, description) || other.description == description) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, timeRange, subtitle, description,
      const DeepCollectionEquality().hash(_details));

  @override
  String toString() {
    return 'EventDialogInfo(title: $title, timeRange: $timeRange, subtitle: $subtitle, description: $description, details: $details)';
  }
}

/// @nodoc
abstract mixin class _$EventDialogInfoCopyWith<$Res> implements $EventDialogInfoCopyWith<$Res> {
  factory _$EventDialogInfoCopyWith(_EventDialogInfo value, $Res Function(_EventDialogInfo) _then) =
      __$EventDialogInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      String timeRange,
      String? subtitle,
      String? description,
      List<String>? details});
}

/// @nodoc
class __$EventDialogInfoCopyWithImpl<$Res> implements _$EventDialogInfoCopyWith<$Res> {
  __$EventDialogInfoCopyWithImpl(this._self, this._then);

  final _EventDialogInfo _self;
  final $Res Function(_EventDialogInfo) _then;

  /// Create a copy of EventDialogInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? timeRange = null,
    Object? subtitle = freezed,
    Object? description = freezed,
    Object? details = freezed,
  }) {
    return _then(_EventDialogInfo(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      timeRange: null == timeRange
          ? _self.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _self.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      details: freezed == details
          ? _self._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on

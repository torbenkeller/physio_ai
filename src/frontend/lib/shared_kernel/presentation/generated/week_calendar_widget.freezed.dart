// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../week_calendar_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarEvent {
  DateTime get startTime;
  DateTime get endTime;
  String get title;
  Color? get color;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarEventCopyWith<CalendarEvent> get copyWith =>
      _$CalendarEventCopyWithImpl<CalendarEvent>(
          this as CalendarEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarEvent &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, endTime, title, color);

  @override
  String toString() {
    return 'CalendarEvent(startTime: $startTime, endTime: $endTime, title: $title, color: $color)';
  }
}

/// @nodoc
abstract mixin class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(
          CalendarEvent value, $Res Function(CalendarEvent) _then) =
      _$CalendarEventCopyWithImpl;
  @useResult
  $Res call({DateTime startTime, DateTime endTime, String title, Color? color});
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._self, this._then);

  final CalendarEvent _self;
  final $Res Function(CalendarEvent) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? title = null,
    Object? color = freezed,
  }) {
    return _then(_self.copyWith(
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
      {required this.startTime,
      required this.endTime,
      required this.title,
      this.color})
      : super._();

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
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, endTime, title, color);

  @override
  String toString() {
    return 'CalendarEvent(startTime: $startTime, endTime: $endTime, title: $title, color: $color)';
  }
}

/// @nodoc
abstract mixin class _$CalendarEventCopyWith<$Res>
    implements $CalendarEventCopyWith<$Res> {
  factory _$CalendarEventCopyWith(
          _CalendarEvent value, $Res Function(_CalendarEvent) _then) =
      __$CalendarEventCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime startTime, DateTime endTime, String title, Color? color});
}

/// @nodoc
class __$CalendarEventCopyWithImpl<$Res>
    implements _$CalendarEventCopyWith<$Res> {
  __$CalendarEventCopyWithImpl(this._self, this._then);

  final _CalendarEvent _self;
  final $Res Function(_CalendarEvent) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? title = null,
    Object? color = freezed,
  }) {
    return _then(_CalendarEvent(
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

// dart format on

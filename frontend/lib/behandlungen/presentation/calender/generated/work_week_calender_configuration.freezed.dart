// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../work_week_calender_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkWeekCalenderConfiguration {

 double get hourHeight; int get timeSlotWidth; int get workingHoursStartHour; int get workingHoursEndHour; int get hoursToShow;
/// Create a copy of WorkWeekCalenderConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkWeekCalenderConfigurationCopyWith<WorkWeekCalenderConfiguration> get copyWith => _$WorkWeekCalenderConfigurationCopyWithImpl<WorkWeekCalenderConfiguration>(this as WorkWeekCalenderConfiguration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkWeekCalenderConfiguration&&(identical(other.hourHeight, hourHeight) || other.hourHeight == hourHeight)&&(identical(other.timeSlotWidth, timeSlotWidth) || other.timeSlotWidth == timeSlotWidth)&&(identical(other.workingHoursStartHour, workingHoursStartHour) || other.workingHoursStartHour == workingHoursStartHour)&&(identical(other.workingHoursEndHour, workingHoursEndHour) || other.workingHoursEndHour == workingHoursEndHour)&&(identical(other.hoursToShow, hoursToShow) || other.hoursToShow == hoursToShow));
}


@override
int get hashCode => Object.hash(runtimeType,hourHeight,timeSlotWidth,workingHoursStartHour,workingHoursEndHour,hoursToShow);

@override
String toString() {
  return 'WorkWeekCalenderConfiguration(hourHeight: $hourHeight, timeSlotWidth: $timeSlotWidth, workingHoursStartHour: $workingHoursStartHour, workingHoursEndHour: $workingHoursEndHour, hoursToShow: $hoursToShow)';
}


}

/// @nodoc
abstract mixin class $WorkWeekCalenderConfigurationCopyWith<$Res>  {
  factory $WorkWeekCalenderConfigurationCopyWith(WorkWeekCalenderConfiguration value, $Res Function(WorkWeekCalenderConfiguration) _then) = _$WorkWeekCalenderConfigurationCopyWithImpl;
@useResult
$Res call({
 double hourHeight, int timeSlotWidth, int workingHoursStartHour, int workingHoursEndHour, int hoursToShow
});




}
/// @nodoc
class _$WorkWeekCalenderConfigurationCopyWithImpl<$Res>
    implements $WorkWeekCalenderConfigurationCopyWith<$Res> {
  _$WorkWeekCalenderConfigurationCopyWithImpl(this._self, this._then);

  final WorkWeekCalenderConfiguration _self;
  final $Res Function(WorkWeekCalenderConfiguration) _then;

/// Create a copy of WorkWeekCalenderConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hourHeight = null,Object? timeSlotWidth = null,Object? workingHoursStartHour = null,Object? workingHoursEndHour = null,Object? hoursToShow = null,}) {
  return _then(_self.copyWith(
hourHeight: null == hourHeight ? _self.hourHeight : hourHeight // ignore: cast_nullable_to_non_nullable
as double,timeSlotWidth: null == timeSlotWidth ? _self.timeSlotWidth : timeSlotWidth // ignore: cast_nullable_to_non_nullable
as int,workingHoursStartHour: null == workingHoursStartHour ? _self.workingHoursStartHour : workingHoursStartHour // ignore: cast_nullable_to_non_nullable
as int,workingHoursEndHour: null == workingHoursEndHour ? _self.workingHoursEndHour : workingHoursEndHour // ignore: cast_nullable_to_non_nullable
as int,hoursToShow: null == hoursToShow ? _self.hoursToShow : hoursToShow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _WorkWeekCalenderConfiguration extends WorkWeekCalenderConfiguration {
  const _WorkWeekCalenderConfiguration({this.hourHeight = 60, this.timeSlotWidth = 60, this.workingHoursStartHour = 8, this.workingHoursEndHour = 19, this.hoursToShow = 24}): super._();
  

@override@JsonKey() final  double hourHeight;
@override@JsonKey() final  int timeSlotWidth;
@override@JsonKey() final  int workingHoursStartHour;
@override@JsonKey() final  int workingHoursEndHour;
@override@JsonKey() final  int hoursToShow;

/// Create a copy of WorkWeekCalenderConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkWeekCalenderConfigurationCopyWith<_WorkWeekCalenderConfiguration> get copyWith => __$WorkWeekCalenderConfigurationCopyWithImpl<_WorkWeekCalenderConfiguration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkWeekCalenderConfiguration&&(identical(other.hourHeight, hourHeight) || other.hourHeight == hourHeight)&&(identical(other.timeSlotWidth, timeSlotWidth) || other.timeSlotWidth == timeSlotWidth)&&(identical(other.workingHoursStartHour, workingHoursStartHour) || other.workingHoursStartHour == workingHoursStartHour)&&(identical(other.workingHoursEndHour, workingHoursEndHour) || other.workingHoursEndHour == workingHoursEndHour)&&(identical(other.hoursToShow, hoursToShow) || other.hoursToShow == hoursToShow));
}


@override
int get hashCode => Object.hash(runtimeType,hourHeight,timeSlotWidth,workingHoursStartHour,workingHoursEndHour,hoursToShow);

@override
String toString() {
  return 'WorkWeekCalenderConfiguration(hourHeight: $hourHeight, timeSlotWidth: $timeSlotWidth, workingHoursStartHour: $workingHoursStartHour, workingHoursEndHour: $workingHoursEndHour, hoursToShow: $hoursToShow)';
}


}

/// @nodoc
abstract mixin class _$WorkWeekCalenderConfigurationCopyWith<$Res> implements $WorkWeekCalenderConfigurationCopyWith<$Res> {
  factory _$WorkWeekCalenderConfigurationCopyWith(_WorkWeekCalenderConfiguration value, $Res Function(_WorkWeekCalenderConfiguration) _then) = __$WorkWeekCalenderConfigurationCopyWithImpl;
@override @useResult
$Res call({
 double hourHeight, int timeSlotWidth, int workingHoursStartHour, int workingHoursEndHour, int hoursToShow
});




}
/// @nodoc
class __$WorkWeekCalenderConfigurationCopyWithImpl<$Res>
    implements _$WorkWeekCalenderConfigurationCopyWith<$Res> {
  __$WorkWeekCalenderConfigurationCopyWithImpl(this._self, this._then);

  final _WorkWeekCalenderConfiguration _self;
  final $Res Function(_WorkWeekCalenderConfiguration) _then;

/// Create a copy of WorkWeekCalenderConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hourHeight = null,Object? timeSlotWidth = null,Object? workingHoursStartHour = null,Object? workingHoursEndHour = null,Object? hoursToShow = null,}) {
  return _then(_WorkWeekCalenderConfiguration(
hourHeight: null == hourHeight ? _self.hourHeight : hourHeight // ignore: cast_nullable_to_non_nullable
as double,timeSlotWidth: null == timeSlotWidth ? _self.timeSlotWidth : timeSlotWidth // ignore: cast_nullable_to_non_nullable
as int,workingHoursStartHour: null == workingHoursStartHour ? _self.workingHoursStartHour : workingHoursStartHour // ignore: cast_nullable_to_non_nullable
as int,workingHoursEndHour: null == workingHoursEndHour ? _self.workingHoursEndHour : workingHoursEndHour // ignore: cast_nullable_to_non_nullable
as int,hoursToShow: null == hoursToShow ? _self.hoursToShow : hoursToShow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

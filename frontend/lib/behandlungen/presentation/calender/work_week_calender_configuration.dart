import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/work_week_calender_configuration.freezed.dart';

@freezed
abstract class WorkWeekCalenderConfiguration with _$WorkWeekCalenderConfiguration {
  const factory WorkWeekCalenderConfiguration({
    @Default(60) double hourHeight,
    @Default(60) int timeSlotWidth,
    @Default(8) int workingHoursStartHour,
    @Default(19) int workingHoursEndHour,
    @Default(24) int hoursToShow,
  }) = _WorkWeekCalenderConfiguration;

  const WorkWeekCalenderConfiguration._();
}

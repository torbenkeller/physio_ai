import 'package:flutter/material.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';

typedef OnCreateBehandlungStarted = void Function(DateTime behandlungStartDate);

class WorkWeekCalenderCreateGestureDetector extends StatelessWidget {
  const WorkWeekCalenderCreateGestureDetector({
    required this.configuration,
    required this.isCreatingBehandlung,
    required this.onCreateBehandlungStarted,
    required this.selectedWeek,
    super.key,
  });

  final WorkWeekCalenderConfiguration configuration;
  final bool isCreatingBehandlung;
  final OnCreateBehandlungStarted onCreateBehandlungStarted;
  final DateTime selectedWeek;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const daysInKalender = 5; // Monday to Friday
        final gridWidth = constraints.maxWidth / daysInKalender;
        final gridHeight =
            constraints.maxHeight / configuration.hoursToShow / 2; // 24 hours in a day

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            if (isCreatingBehandlung) {
              return;
            }

            final weekday = (details.localPosition.dx / gridWidth).floor();
            final day = selectedWeek.add(Duration(days: weekday));

            final startHour = Duration(
              minutes: (details.localPosition.dy / gridHeight).floor() * 30,
            );
            final startZeit = day.add(startHour);

            onCreateBehandlungStarted.call(startZeit);
          },
        );
      },
    );
  }
}

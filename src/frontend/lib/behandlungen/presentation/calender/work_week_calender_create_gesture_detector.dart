import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_notifier.dart';

typedef OnCreateBehandlungStarted = void Function(DateTime behandlungStartDate);

class WorkWeekCalenderCreateGestureDetector extends ConsumerWidget {
  const WorkWeekCalenderCreateGestureDetector({
    required this.configuration,
    super.key,
  });

  final WorkWeekCalenderConfiguration configuration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(workWeekCalenderSelectedWeekProvider);
    final isCreatingBehandlung =
        ref.watch(workWeekCalenderCreateBehandlungStartZeitProvider) != null;

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

            _onStartCreating(ref, startZeit);
          },
        );
      },
    );
  }

  void _onStartCreating(WidgetRef ref, DateTime startZeit) {
    ref.read(workWeekCalenderCreateBehandlungStartZeitProvider.notifier).startCreating(startZeit);
  }
}

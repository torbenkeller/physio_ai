import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_notifier.dart';

class BehandlungenPage extends ConsumerWidget {
  const BehandlungenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(workWeekCalenderSelectedWeekProvider);
    final events = ref.watch(workWeekCalenderBehandlungenProvider(selectedWeek));

    final calenderEvents = events.value ?? IList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Calendar View (Left Side)
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: WorkWeekCalender(events: calenderEvents),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

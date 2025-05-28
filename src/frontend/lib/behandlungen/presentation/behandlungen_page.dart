import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/presentation/behandlungen_calendar_provider.dart';
import 'package:physio_ai/behandlungen/presentation/behandlungen_week_calendar_widget.dart';

class BehandlungenPage extends ConsumerStatefulWidget {
  const BehandlungenPage({super.key});

  @override
  ConsumerState<BehandlungenPage> createState() => _BehandlungenPageState();
}

class _BehandlungenPageState extends ConsumerState<BehandlungenPage> {
  DateTime _selectedWeek = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(weeklyCalendarProvider(_selectedWeek));
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
                  child: BehandlungenWeekCalendarWidget(
                    events: calenderEvents,
                    selectedWeek: _selectedWeek,
                    onWeekSelected: (date) {
                      setState(() {
                        _selectedWeek = date;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension<S> on S {
  T let<T>(T Function(S) func) {
    return func(this);
  }
}

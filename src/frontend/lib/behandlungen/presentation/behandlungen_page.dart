import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/presentation/behandlungen_calendar_provider.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender.dart';

class BehandlungenPage extends ConsumerStatefulWidget {
  const BehandlungenPage({super.key});

  @override
  ConsumerState<BehandlungenPage> createState() => _BehandlungenPageState();
}

class _BehandlungenPageState extends ConsumerState<BehandlungenPage> {
  late final DateTime _initialWeek;
  late DateTime _selectedWeek;

  DateTime _normalizeWeek(DateTime date) {
    return DateUtils.dateOnly(date).subtract(Duration(days: date.weekday - 1));
  }

  @override
  void initState() {
    super.initState();
    _initialWeek = _normalizeWeek(DateTime.now());
    _selectedWeek = _initialWeek;
  }

  void _onWeekSelected(DateTime date) {
    setState(() {
      _selectedWeek = _normalizeWeek(date);
    });
  }

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
                  child: WorkWeekCalender(
                    events: calenderEvents,
                    onWeekSelected: _onWeekSelected,
                    initialWeek: _initialWeek,
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

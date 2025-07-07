import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';

class WorkWeekCalenderHeader extends StatelessWidget {
  const WorkWeekCalenderHeader({
    required this.selectedWeek,
    required this.onWeekSelected,
    this.daysToShow = 5,
    super.key,
  });

  final DateTime selectedWeek;
  final ValueChanged<DateTime> onWeekSelected;
  final int daysToShow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final today = DateUtils.dateOnly(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy', 'de').format(selectedWeek),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'KW ${_getWeekNumber(selectedWeek)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(178),
                      ),
                    ),
                  ],
                ),
              ),
              DragTarget<BehandlungKalender>(
                builder: (context, _, __) => IconButton(
                  onPressed: _previousWeek,
                  icon: const Icon(Icons.chevron_left),
                ),
                onWillAcceptWithDetails: (details) {
                  _previousWeek();
                  return false;
                },
              ),
              TextButton(
                onPressed: _goToToday,
                child: const Text('Heute'),
              ),
              DragTarget<BehandlungKalender>(
                builder: (context, _, __) => IconButton(
                  onPressed: _nextWeek,
                  icon: const Icon(Icons.chevron_right),
                ),
                onWillAcceptWithDetails: (details) {
                  _nextWeek();
                  return false;
                },
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 48), // Space for the timeline left
              for (int i = 0; i < daysToShow; i++)
                Expanded(
                  child: _DayHeader(
                    day: selectedWeek.add(Duration(days: i)),
                    isToday: selectedWeek.add(Duration(days: i)) == today,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _previousWeek() {
    final previousWeek = selectedWeek.subtract(const Duration(days: 7));
    onWeekSelected(previousWeek);
  }

  void _nextWeek() {
    final nextWeek = selectedWeek.add(const Duration(days: 7));
    onWeekSelected(nextWeek);
  }

  void _goToToday() {
    onWeekSelected(DateTime.now());
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.day,
    required this.isToday,
    super.key,
  });

  final DateTime day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Column(
      children: [
        Text(
          DateFormat('E', locale.toString()).format(day),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isToday ? Theme.of(context).colorScheme.primary : null,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            day.day.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isToday ? Theme.of(context).colorScheme.onPrimary : null,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

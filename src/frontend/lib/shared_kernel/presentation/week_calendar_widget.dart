import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';

part 'generated/week_calendar_widget.freezed.dart';

/// Immutable calendar event data class
@freezed
abstract class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required DateTime startTime,
    required DateTime endTime,
    required String title,
    Color? color,
  }) = _CalendarEvent;

  const CalendarEvent._();

  factory CalendarEvent.fromBehandlung(Behandlung behandlung) {
    return CalendarEvent(
      startTime: behandlung.startZeit,
      endTime: behandlung.endZeit,
      title: 'Behandlung',
      color: Colors.blue.shade600,
    );
  }
}

/// Week calendar widget that displays events for a single week
class WeekCalendarWidget extends StatefulWidget {
  const WeekCalendarWidget({
    required this.events,
    this.selectedDate,
    this.onDateSelected,
    this.onEventTap,
    this.eventHeight = 32.0,
    this.hourHeight = 60.0,
    this.startHour = 8,
    this.endHour = 20,
    super.key,
  });

  final List<CalendarEvent> events;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<CalendarEvent>? onEventTap;
  final double eventHeight;
  final double hourHeight;
  final int startHour;
  final int endHour;

  @override
  State<WeekCalendarWidget> createState() => _WeekCalendarWidgetState();
}

class _WeekCalendarWidgetState extends State<WeekCalendarWidget> {
  late DateTime _currentWeek;

  @override
  void initState() {
    super.initState();
    _currentWeek = widget.selectedDate ?? DateTime.now();
  }

  DateTime get _weekStart {
    final weekday = _currentWeek.weekday;
    return _currentWeek.subtract(Duration(days: weekday - 1));
  }

  List<DateTime> get _weekDays {
    final start = _weekStart;
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return widget.events.where((event) {
      final eventDate = event.startTime;
      return eventDate.year == day.year &&
          eventDate.month == day.month &&
          eventDate.day == day.day;
    }).toList();
  }

  void _previousWeek() {
    setState(() {
      _currentWeek = _currentWeek.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentWeek = _currentWeek.add(const Duration(days: 7));
    });
  }

  void _goToToday() {
    setState(() {
      _currentWeek = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Header with navigation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _previousWeek,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy', 'de').format(_currentWeek),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'KW ${_getWeekNumber(_currentWeek)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: _goToToday,
                child: const Text('Heute'),
              ),
              IconButton(
                onPressed: _nextWeek,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),

        // Calendar grid
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Column(
              children: [
                // Day headers
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Time column header
                      Container(
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      // Day headers
                      for (final day in _weekDays)
                        Expanded(
                          child: _buildDayHeader(day, theme),
                        ),
                    ],
                  ),
                ),

                // Calendar body
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: (widget.endHour - widget.startHour) *
                          widget.hourHeight,
                      child: Row(
                        children: [
                          // Time column
                          Container(
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.2),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                for (int hour = widget.startHour;
                                    hour < widget.endHour;
                                    hour++)
                                  _buildHourLabel(hour, theme),
                              ],
                            ),
                          ),

                          // Day columns
                          for (final day in _weekDays)
                            Expanded(
                              child: _buildDayColumn(day, theme),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader(DateTime day, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isToday = _isToday(day);
    final isSelected =
        widget.selectedDate != null && _isSameDay(day, widget.selectedDate!);

    return GestureDetector(
      onTap: () => widget.onDateSelected?.call(day),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E', 'de').format(day),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isToday ? colorScheme.primary : null,
                fontWeight: isToday ? FontWeight.bold : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${day.day}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isToday ? colorScheme.primary : null,
                fontWeight: isToday ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourLabel(int hour, ThemeData theme) {
    return Container(
      height: widget.hourHeight,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '${hour.toString().padLeft(2, '0')}:00',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildDayColumn(DateTime day, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final events = _getEventsForDay(day);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Stack(
        children: [
          // Hour dividers
          for (int hour = widget.startHour; hour < widget.endHour; hour++)
            Positioned(
              top: (hour - widget.startHour) * widget.hourHeight,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),

          // Events
          for (final event in events) _buildEventWidget(event, day, theme),
        ],
      ),
    );
  }

  Widget _buildEventWidget(CalendarEvent event, DateTime day, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    // Calculate position and size
    final startMinutes = event.startTime.hour * 60 + event.startTime.minute;
    final endMinutes = event.endTime.hour * 60 + event.endTime.minute;
    final durationMinutes = endMinutes - startMinutes;

    final startOffset =
        (startMinutes - widget.startHour * 60) / 60 * widget.hourHeight;
    final height = durationMinutes / 60 * widget.hourHeight;

    return Positioned(
      top: startOffset,
      left: 4,
      right: 4,
      height: height.clamp(widget.eventHeight, double.infinity),
      child: GestureDetector(
        onTap: () => widget.onEventTap?.call(event),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: event.color ?? colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (height > widget.eventHeight + 16)
                Text(
                  '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }
}

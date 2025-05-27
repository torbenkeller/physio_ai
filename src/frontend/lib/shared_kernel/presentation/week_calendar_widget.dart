import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

typedef WorkingHours = ({int startHour, int endHour});

/// Week calendar widget that displays events for a single week
class WeekCalendarWidget extends StatefulWidget {
  const WeekCalendarWidget({
    required this.events,
    required this.selectedWeek,
    this.onWeekSelected,
    this.onEventTap,
    this.eventHeight = 32.0,
    this.hourHeight = 60.0,
    this.workingHours = (startHour: 9, endHour: 18),
    super.key,
  });

  final IList<CalendarEvent> events;
  final ValueChanged<DateTime>? onWeekSelected;
  final ValueChanged<CalendarEvent>? onEventTap;
  final double eventHeight;
  final double hourHeight;
  final WorkingHours workingHours;
  final DateTime selectedWeek;

  @override
  State<WeekCalendarWidget> createState() => _WeekCalendarWidgetState();
}

class _WeekCalendarWidgetState extends State<WeekCalendarWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
        initialScrollOffset: (widget.workingHours.startHour - 1) * widget.hourHeight);
  }

  DateTime get _weekStart {
    final weekday = widget.selectedWeek.weekday;
    return widget.selectedWeek.subtract(Duration(days: weekday - 1));
  }

  List<DateTime> get _weekDays {
    final start = _weekStart;
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return widget.events.where((event) {
      final eventDate = event.startTime;
      return eventDate.year == day.year && eventDate.month == day.month && eventDate.day == day.day;
    }).toList();
  }

  void _previousWeek() {
    widget.onWeekSelected?.call(widget.selectedWeek.subtract(const Duration(days: 7)));
  }

  void _nextWeek() {
    widget.onWeekSelected?.call(widget.selectedWeek.add(const Duration(days: 7)));
  }

  void _goToToday() {
    widget.onWeekSelected?.call(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Header with navigation
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
                        DateFormat('MMMM yyyy', 'de').format(widget.selectedWeek),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'KW ${_getWeekNumber(widget.selectedWeek)}',
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
          child: Column(
            children: [
              // Day headers
              Container(
                height: 48,
                decoration: BoxDecoration(
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
                  controller: _scrollController,
                  child: SizedBox(
                    height: 24 * widget.hourHeight,
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
                              for (int hour = 0; hour < 24; hour++) _buildHourLabel(hour, theme),
                            ],
                          ),
                        ),

                        // Day columns
                        for (final (index, day) in _weekDays.indexed)
                          Expanded(
                            child: _buildDayColumn(day, theme, _weekDays.length - 1 == index),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader(DateTime day, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isToday = _isToday(day);

    return GestureDetector(
      onTap: () => widget.onWeekSelected?.call(day),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
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

  Widget _buildDayColumn(DateTime day, ThemeData theme, bool isLastColumn) {
    final colorScheme = theme.colorScheme;
    final events = _getEventsForDay(day);

    final boxDecoration = isLastColumn
        ? null
        : BoxDecoration(
            border: Border(
              right: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
          );

    return Container(
      decoration: boxDecoration,
      child: Stack(
        children: [
          // Hour dividers
          Column(
            children: [
              for (int hour = 0; hour < 24; hour++)
                Container(
                  height: widget.hourHeight,
                  decoration: BoxDecoration(
                    color:
                        hour < widget.workingHours.startHour || hour > widget.workingHours.endHour
                            ? colorScheme.surfaceContainer
                            : null,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ),
                )
            ],
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

    final startOffset = startMinutes / 60 * widget.hourHeight;
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
    return _isSameDay(today, date);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return DateUtils.dateOnly(date1) == DateUtils.dateOnly(date2);
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }
}

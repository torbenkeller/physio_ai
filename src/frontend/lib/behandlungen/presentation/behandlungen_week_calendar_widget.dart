import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezept_detail_page.dart';

typedef WorkingHours = ({int startHour, int endHour});

/// Week calendar widget that displays events for a single week
class BehandlungenWeekCalendarWidget extends ConsumerStatefulWidget {
  const BehandlungenWeekCalendarWidget({
    required this.events,
    required this.selectedWeek,
    this.onWeekSelected,
    this.hourHeight = 60.0,
    this.workingHours = (startHour: 9, endHour: 18),
    super.key,
  });

  final IList<BehandlungKalender> events;
  final ValueChanged<DateTime>? onWeekSelected;
  final double hourHeight;
  final WorkingHours workingHours;
  final DateTime selectedWeek;

  @override
  ConsumerState<BehandlungenWeekCalendarWidget> createState() => _WeekCalendarWidgetState();
}

class _WeekCalendarWidgetState extends ConsumerState<BehandlungenWeekCalendarWidget> {
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

  List<BehandlungKalender> _getEventsForDay(DateTime day) {
    return widget.events.where((event) {
      final eventDate = event.startZeit;
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

    return Portal(
      child: Column(
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
                      for (final (index, day) in _weekDays.indexed)
                        Expanded(
                          child: _buildDayHeader(index, day, theme),
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
      ),
    );
  }

  Widget _buildDayHeader(int index, DateTime day, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isToday = _isToday(day);

    return Container(
      decoration: index != 6
          ? BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
            )
          : null,
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
        fit: StackFit.expand,
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
                    border: hour != 23
                        ? Border(
                            bottom: BorderSide(
                              color: colorScheme.outline.withOpacity(0.2),
                            ),
                          )
                        : null,
                  ),
                )
            ],
          ),
          for (int halfHour = 0; halfHour < 24 * 2; halfHour++)
            Positioned(
              top: halfHour * widget.hourHeight / 2,
              right: 0,
              left: 0,
              child: SizedBox(
                height: widget.hourHeight,
                child: DragTarget(
                  builder: (context, i, __) {
                    final event = i.isNotEmpty ? i.first! as BehandlungKalender : null;
                    if (event == null) {
                      return Container();
                    }

                    final startZeit = day.add(Duration(minutes: halfHour * 30));
                    final endZeit = day.add(
                      Duration(
                        minutes:
                            (halfHour * 30) + event.endZeit.difference(event.startZeit).inMinutes,
                      ),
                    );

                    return Container(
                      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: _KalenderEntry(
                        title: event.patient.name,
                        startZeit: startZeit,
                        endZeit: endZeit,
                        hourHeight: widget.hourHeight,
                      ),
                    );
                  },
                ),
              ),
            ),
          // Events
          for (final event in events)
            _EventEntry(
              event: event,
              hourHeight: widget.hourHeight,
            ),
        ],
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

class _EventEntry extends ConsumerStatefulWidget {
  const _EventEntry({
    required this.hourHeight,
    required this.event,
    super.key,
  });

  final double hourHeight;
  final BehandlungKalender event;

  @override
  ConsumerState<_EventEntry> createState() => _EventEntryState();
}

class _EventEntryState extends ConsumerState<_EventEntry> {
  bool _isDetailsOpen = false;

  @override
  Widget build(BuildContext context) {
    // Calculate position and size
    final startMinutes = widget.event.startZeit.hour * 60 + widget.event.startZeit.minute;
    final startOffset = startMinutes / 60 * widget.hourHeight;

    return Positioned(
      top: startOffset,
      left: 4,
      right: 4,
      child: PortalTarget(
        visible: _isDetailsOpen,
        portalFollower: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _isDetailsOpen = false;
            });
          },
        ),
        child: PortalTarget(
          visible: _isDetailsOpen,
          anchor: const Aligned(
            follower: Alignment.topLeft,
            target: Alignment.topRight,
            offset: Offset(8, 0),
          ),
          portalFollower: SizedBox(
            width: 280,
            child: _EventPopup(
              event: widget.event,
              onClose: () {
                setState(() {
                  _isDetailsOpen = false;
                });
              },
            ),
          ),
          child: Draggable(
            data: widget.event,
            feedback: Container(),
            childWhenDragging: _KalenderEntry(
              title: widget.event.patient.name,
              startZeit: widget.event.startZeit,
              endZeit: widget.event.endZeit,
              withOpacity: true,
              hourHeight: widget.hourHeight,
            ),
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  _isDetailsOpen = true;
                }),
              },
              child: _KalenderEntry(
                title: widget.event.patient.name,
                startZeit: widget.event.startZeit,
                endZeit: widget.event.endZeit,
                hourHeight: widget.hourHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EventPopup extends StatelessWidget {
  const _EventPopup({
    required this.event,
    required this.onClose,
  });

  final BehandlungKalender event;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.patient.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('HH:mm').format(event.startZeit)} - ${DateFormat('HH:mm').format(event.endZeit)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            if (event.rezeptId != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Rezept:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _BehandlungDetailPopupRezept(rezeptId: event.rezeptId!),
            ],
          ],
        ),
      ),
    );
  }
}

class _KalenderEntry extends StatelessWidget {
  const _KalenderEntry({
    required this.title,
    required this.startZeit,
    required this.endZeit,
    required this.hourHeight,
    this.withOpacity = false,
    super.key,
  });

  final String title;
  final DateTime startZeit;
  final DateTime endZeit;
  final bool withOpacity;
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final startMinutes = startZeit.hour * 60 + startZeit.minute;
    final endMinutes = endZeit.hour * 60 + endZeit.minute;
    final durationMinutes = endMinutes - startMinutes;

    final height = durationMinutes / 60 * hourHeight - 4;

    final color = withOpacity ? colorScheme.primary.withAlpha(137) : colorScheme.primary;

    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${DateFormat('HH:mm').format(startZeit)} - ${DateFormat('HH:mm').format(endZeit)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.8),
              fontSize: 10,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _BehandlungDetailPopupRezept extends ConsumerWidget {
  const _BehandlungDetailPopupRezept({
    required this.rezeptId,
    super.key,
  });

  final String rezeptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRezept = ref.watch(rezeptProvider(rezeptId));
    return switch (asyncRezept) {
      final AsyncData<Rezept> data => Text(data.value.preisGesamt.toString()),
      AsyncLoading<Rezept?>() => const CircularProgressIndicator(),
      AsyncError<Rezept?>() => Container(),
    };
  }
}

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlung_verschiebe_dto.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlungen_repository.dart';
import 'package:physio_ai/behandlungen/presentation/behandlungen_calendar_provider.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_event_entry.dart';
import 'package:physio_ai/shared_kernel/infrastructure/logging.dart';

class WorkWeekCalenderDragTargets extends ConsumerWidget {
  const WorkWeekCalenderDragTargets({
    required this.events,
    required this.selectedWeek,
    required this.configuration,
    required this.scrollController,
    super.key,
  });

  final IList<BehandlungKalender> events;

  final DateTime selectedWeek;

  final WorkWeekCalenderConfiguration configuration;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const daysInKalender = 5; // Monday to Friday
        final gridWidth = constraints.maxWidth / daysInKalender;
        final gridHeight = constraints.maxHeight / configuration.hoursToShow / 2;

        final dropZones = <Widget>[];

        for (var day = 0; day < daysInKalender; day++) {
          for (var minutes = 0; minutes < 24 * 60; minutes += 30) {
            final startZeit = selectedWeek.add(Duration(days: day, minutes: minutes));

            dropZones.add(
              Positioned(
                top: gridHeight * minutes / 30,
                left: gridWidth * (startZeit.weekday - 1),
                child: DragTarget<BehandlungKalender>(
                  builder: (context, acceptList, _) {
                    if (acceptList.isEmpty) {
                      return SizedBox(
                        width: gridWidth,
                        height: gridHeight,
                      );
                    }

                    final event = acceptList.first!;

                    final eventDuration = event.endZeit.difference(event.startZeit);
                    final endZeit = startZeit.add(eventDuration);

                    return SizedBox(
                      width: gridWidth,
                      height: eventDuration.inMinutes / 30 * gridHeight,
                      child: RawWorkWeekCalenderEventEntry(
                        title: event.patient.name,
                        startZeit: startZeit,
                        endZeit: endZeit,
                      ),
                    );
                  },
                  onMove: (details) {
                    if (!context.mounted) {
                      return;
                    }

                    final event = details.data;

                    final eventDuration = event.endZeit.difference(event.startZeit);
                    final eventHeight = eventDuration.inMinutes / 30 * gridHeight;

                    final box = context.findRenderObject()! as RenderBox;

                    final localDragOffset = box.globalToLocal(details.offset);

                    final scrollUp =
                        localDragOffset.dy - scrollController.offset < eventHeight &&
                        scrollController.offset > 0;

                    if (scrollUp) {
                      scrollController.jumpTo(scrollController.offset - 8);
                    }

                    final scrollDown =
                        localDragOffset.dy - scrollController.offset >
                            scrollController.position.viewportDimension - eventHeight * 1.5 &&
                        scrollController.offset < scrollController.position.maxScrollExtent;

                    if (scrollDown) {
                      scrollController.jumpTo(scrollController.offset + 8);
                    }
                  },
                  onAcceptWithDetails: (details) async {
                    final event = details.data;

                    log('Dragging event: ${event.id} to $startZeit', level: LogLevel.info);

                    try {
                      await ref
                          .read(behandlungenRepositoryProvider)
                          .verschiebe(
                            event.id,
                            BehandlungVerschiebeDto(nach: startZeit),
                          );

                      final oldEventWeek = DateUtils.dateOnly(
                        event.startZeit,
                      ).subtract(Duration(days: event.startZeit.weekday - 1));

                      final selectedWeek = DateUtils.dateOnly(
                        this.selectedWeek,
                      ).subtract(Duration(days: this.selectedWeek.weekday - 1));

                      if (oldEventWeek != selectedWeek) {
                        ref.invalidate(weeklyCalendarProvider(oldEventWeek));
                      }

                      ref.invalidate(weeklyCalendarProvider(this.selectedWeek));
                    } catch (e, stackTrace) {
                      log(
                        'Error while moving event',
                        level: LogLevel.warning,
                        error: e,
                        stackTrace: stackTrace,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fehler beim Verschieben des Termins'),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }
        }
        return Stack(children: dropZones);
      },
    );
  }
}

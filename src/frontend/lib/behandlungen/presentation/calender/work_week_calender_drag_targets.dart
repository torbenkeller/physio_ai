import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_event_entry.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_notifier.dart';
import 'package:physio_ai/shared_kernel/infrastructure/logging.dart';

class WorkWeekCalenderDragTargets extends ConsumerWidget {
  const WorkWeekCalenderDragTargets({
    required this.events,
    required this.configuration,
    required this.scrollController,
    super.key,
  });

  final IList<BehandlungKalender> events;

  final WorkWeekCalenderConfiguration configuration;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(workWeekCalenderSelectedWeekProvider);

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
                  onMove: (details) => _scrollUpDown(context, details, gridHeight),
                  onAcceptWithDetails: (details) => _moveBehandlung(
                    context,
                    ref,
                    details,
                    startZeit,
                    selectedWeek,
                  ),
                ),
              ),
            );
          }
        }
        return Stack(children: dropZones);
      },
    );
  }

  Future<void> _moveBehandlung(
    BuildContext context,
    WidgetRef ref,
    DragTargetDetails<BehandlungKalender> details,
    DateTime startZeit,
    DateTime selectedWeek,
  ) async {
    final event = details.data;
    log('Dragging event: ${event.id} to $startZeit', level: LogLevel.info);

    try {
      await ref
          .read(workWeekCalenderBehandlungenProvider(selectedWeek).notifier)
          .verschiebeBehandlung(event: event, nach: startZeit);
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
  }

  void _scrollUpDown(
    BuildContext context,
    DragTargetDetails<BehandlungKalender> details,
    double gridHeight,
  ) {
    if (!context.mounted) {
      return;
    }

    final event = details.data;

    final eventDuration = event.endZeit.difference(event.startZeit);
    final eventHeight = eventDuration.inMinutes / 30 * gridHeight;

    final box = context.findRenderObject()! as RenderBox;

    final localDragOffset = box.globalToLocal(details.offset);

    final scrollUp =
        localDragOffset.dy - scrollController.offset < eventHeight && scrollController.offset > 0;

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
  }
}

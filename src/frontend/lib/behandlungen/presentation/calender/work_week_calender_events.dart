import 'package:fast_immutable_collections/src/ilist/ilist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_event_entry.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezept_detail_page.dart';

const _closePortalTargetDetectorLabel = PortalLabel('closeTargetDetector');

class WorkWeekCalenderEvents extends StatelessWidget {
  const WorkWeekCalenderEvents({
    required this.events,
    required this.configuration,
    super.key,
  });

  final IList<BehandlungKalender> events;

  final WorkWeekCalenderConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const daysInKalender = 5; // Monday to Friday
        final gridWidth = constraints.maxWidth / daysInKalender;
        final gridHeight = constraints.maxHeight / configuration.hoursToShow; // 24 hours in a day

        return Portal(
          labels: const [_closePortalTargetDetectorLabel],
          child: Stack(
            children: [
              for (final event in events)
                Positioned(
                  top: gridHeight * (event.startZeit.hour + event.startZeit.minute / 60),
                  left: gridWidth * (event.startZeit.weekday - 1),
                  child: _EventEntry(
                    key: Key(event.id),
                    width: gridWidth,
                    height: gridHeight * event.endZeit.difference(event.startZeit).inMinutes / 60,
                    event: event,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EventEntry extends ConsumerStatefulWidget {
  const _EventEntry({
    required this.event,
    required this.width,
    required this.height,
    super.key,
  });

  final BehandlungKalender event;

  final double width;
  final double height;

  @override
  ConsumerState<_EventEntry> createState() => _EventEntryState();
}

class _EventEntryState extends ConsumerState<_EventEntry> {
  bool _isDetailsOpen = false;
  bool _isDragged = false;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _isDetailsOpen,
      portalCandidateLabels: const [_closePortalTargetDetectorLabel],
      portalFollower: GestureDetector(
        onTap: () {
          setState(() {
            _isDetailsOpen = false;
          });
        },
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Draggable(
          onDragStarted: () {
            setState(() {
              _isDragged = true;
            });
          },
          onDragEnd: (_) {
            setState(() {
              _isDragged = false;
            });
          },
          feedback: Container(),
          data: widget.event,
          child: InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => {
              setState(() {
                _isDetailsOpen = true;
              }),
            },
            child: WorkWeekCalenderEventEntry(
              title: widget.event.patient.name,
              startZeit: widget.event.startZeit,
              endZeit: widget.event.endZeit,
              isDragged: _isDragged,
              showPopupMenu: _isDetailsOpen,
              popUpLocation: widget.event.startZeit.weekday <= 3
                  ? PopUpLocation.topRight
                  : PopUpLocation.topLeft,
              onClosePopupMenu: () {
                setState(() {
                  _isDetailsOpen = false;
                });
              },
              popupMenu: SizedBox(
                width: widget.width * 2,
                child: _EventPopup(
                  event: widget.event,
                  onClose: () {
                    setState(() {
                      _isDetailsOpen = false;
                    });
                  },
                ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {},
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
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
        ),
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

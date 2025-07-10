import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/presentation/calender/create_behandlung_form/create_behandlung_form.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_event_entry.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_notifier.dart';
import 'package:physio_ai/patienten/domain/patient.dart';

class WorkWeekCalenderCreator extends ConsumerStatefulWidget {
  const WorkWeekCalenderCreator({
    required this.configuration,
    super.key,
  });

  final WorkWeekCalenderConfiguration configuration;

  @override
  ConsumerState<WorkWeekCalenderCreator> createState() => _WorkWeekCalenderCreatorState();
}

class _WorkWeekCalenderCreatorState extends ConsumerState<WorkWeekCalenderCreator> {
  Patient? _selectedPatient;

  @override
  Widget build(BuildContext context) {
    final createBehandlungStartZeit = ref.watch(workWeekCalenderCreateBehandlungStartZeitProvider);

    if (createBehandlungStartZeit == null) {
      return Container();
    }

    return Overlay.wrap(
      child: Portal(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const daysInKalender = 5; // Monday to Friday
            final gridWidth = constraints.maxWidth / daysInKalender;
            final gridHeight =
                constraints.maxHeight / widget.configuration.hoursToShow / 2; // 24 hours in a day

            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                  ),
                ),
                Positioned(
                  top:
                      gridHeight *
                      2 *
                      (createBehandlungStartZeit.hour + createBehandlungStartZeit.minute / 60),
                  left: gridWidth * (createBehandlungStartZeit.weekday - 1),
                  height: gridHeight * 2,
                  width: gridWidth,
                  child: WorkWeekCalenderEventEntry(
                    title: _selectedPatient?.fullName ?? '(Kein Patient ausgewählt)',
                    startZeit: createBehandlungStartZeit,
                    endZeit: createBehandlungStartZeit.add(const Duration(hours: 1)),
                    onClosePopupMenu: _onCreateFinished,
                    popUpLocation: createBehandlungStartZeit.weekday <= 3
                        ? PopUpLocation.topRight
                        : PopUpLocation.topLeft,
                    popupMenu: SizedBox(
                      width: gridWidth * 2,
                      child: _EventPopup(
                        patient: _selectedPatient,
                        onPatientSelected: (patient) {
                          setState(() {
                            _selectedPatient = patient;
                          });
                        },
                        onClose: () {
                          _onCreateFinished();
                          setState(() {
                            _selectedPatient = null;
                          });
                        },
                        startZeit: createBehandlungStartZeit,
                        endZeit: createBehandlungStartZeit.add(const Duration(hours: 1)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onCreateFinished() {
    ref.read(workWeekCalenderCreateBehandlungStartZeitProvider.notifier).stopCreating();
  }
}

class _EventPopup extends StatelessWidget {
  const _EventPopup({
    required this.onClose,
    required this.startZeit,
    required this.endZeit,
    required this.patient,
    required this.onPatientSelected,
  });

  final DateTime startZeit;
  final DateTime endZeit;
  final VoidCallback onClose;
  final ValueChanged<Patient?>? onPatientSelected;
  final Patient? patient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
            spacing: 16,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Behandlung erstellen',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),
              CreateBehandlungForm(startZeit: startZeit),
            ],
          ),
        ),
      ),
    );
  }
}

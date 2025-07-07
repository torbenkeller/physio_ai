import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_event_entry.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';

class WorkWeekCalenderCreator extends StatefulWidget {
  const WorkWeekCalenderCreator({
    required this.configuration,
    required this.selectedWeek,
    required this.onCreateFinished,
    required this.createBehandlungStartZeit,
    super.key,
  });

  final WorkWeekCalenderConfiguration configuration;

  final DateTime selectedWeek;

  final DateTime? createBehandlungStartZeit;

  final VoidCallback onCreateFinished;

  @override
  State<WorkWeekCalenderCreator> createState() => _WorkWeekCalenderCreatorState();
}

class _WorkWeekCalenderCreatorState extends State<WorkWeekCalenderCreator> {
  Patient? _selectedPatient;

  @override
  Widget build(BuildContext context) {
    if (widget.createBehandlungStartZeit == null) {
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
                      (widget.createBehandlungStartZeit!.hour +
                          widget.createBehandlungStartZeit!.minute / 60),
                  left: gridWidth * (widget.createBehandlungStartZeit!.weekday - 1),
                  height: gridHeight * 2,
                  width: gridWidth,
                  child: WorkWeekCalenderEventEntry(
                    title: _selectedPatient?.fullName ?? '(Kein Patient ausgewählt)',
                    startZeit: widget.createBehandlungStartZeit!,
                    endZeit: widget.createBehandlungStartZeit!.add(const Duration(hours: 1)),
                    onClosePopupMenu: widget.onCreateFinished,
                    popUpLocation: widget.createBehandlungStartZeit!.weekday <= 3
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
                          widget.onCreateFinished.call();
                          setState(() {
                            _selectedPatient = null;
                          });
                        },
                        startZeit: widget.createBehandlungStartZeit!,
                        endZeit: widget.createBehandlungStartZeit!.add(const Duration(hours: 1)),
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
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient?.fullName ?? '(Kein Patient ausgewählt)',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 8),
                        Text(
                          '${DateFormat('HH:mm').format(startZeit)} - ${DateFormat('HH:mm').format(endZeit)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PatientSection(
                patient: patient,
                onPatientSelected: (patient) {
                  onPatientSelected?.call(patient);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientSection extends StatefulWidget {
  const _PatientSection({
    required this.patient,
    required this.onPatientSelected,
    super.key,
  });

  final ValueChanged<Patient?> onPatientSelected;
  final Patient? patient;

  @override
  State<_PatientSection> createState() => _PatientSectionState();
}

class _PatientSectionState extends State<_PatientSection> {
  late final TextEditingController _controller;
  late final OverlayPortalController _overlayPortalController;
  final _buttonKey = GlobalKey();

  String? _selectedText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.patient?.fullName ?? '';
    _overlayPortalController = OverlayPortalController();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_overlayPortalController.isShowing) {
      _overlayPortalController.hide();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    final selectContent = switch (widget.patient) {
      null => ElevatedButton(
        key: _buttonKey,
        onPressed: () {
          _overlayPortalController.show();
        },
        child: const Text('Patient auswählen'),
      ),
      _ => Text(widget.patient!.telMobil ?? ''),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return OverlayPortal.overlayChildLayoutBuilder(
          controller: _overlayPortalController,
          child: selectContent,
          overlayChildBuilder: (_, info) {
            final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;

            final overlaySize = overlay.size;
            final applicationSize = MediaQuery.sizeOf(context);

            final button = _buttonKey.currentContext!.findRenderObject()! as RenderBox;
            final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

            final buttonPositionOnOverlay = Offset(
              buttonPosition.dx,
              buttonPosition.dy,
            );

            // Height of content to be calculated dynamically based on the elements
            final overlayHeight = (64 * 6).toDouble();

            const double overlayPadding = 16;

            return Positioned(
              width: constraints.maxWidth,
              height: overlayHeight,
              left: buttonPositionOnOverlay.dx,
              top: buttonPositionOnOverlay.dy - overlayPadding,
              child: Focus(
                autofocus: true,
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    return;
                  }
                  if (!_overlayPortalController.isShowing) {
                    return;
                  }
                  if (_controller.text.isEmpty) {
                    _overlayPortalController.hide();
                    widget.onPatientSelected(null);
                  }
                },
                child: Material(
                  elevation: 8,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(overlayPadding),
                    child: Column(
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                controller: _controller,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Patient auswählen',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _overlayPortalController.hide();
                                      setState(() {
                                        widget.onPatientSelected(null);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.go('/patienten/create');
                              },
                              child: const Text('Neu'),
                            ),
                          ],
                        ),
                        _PatientenSearchResults(
                          searchText: _selectedText,
                          onPatientSelected: (patient) {
                            widget.onPatientSelected(patient);
                            _overlayPortalController.hide();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PatientenSearchResults extends ConsumerWidget {
  const _PatientenSearchResults({
    required this.searchText,
    required this.onPatientSelected,
    super.key,
  });

  final String? searchText;

  final ValueChanged<Patient> onPatientSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPatienten = ref.watch(patientenProvider);
    final patienten = asyncPatienten.value ?? const IListConst<Patient>([]);

    return SizedBox(
      height: 64 * 4,
      child: ListView(
        children: [
          ...patienten
              .where(
                (patient) =>
                    patient.fullName.toLowerCase().contains(searchText?.toLowerCase() ?? ''),
              )
              .map((patient) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(patient.fullName),
                  subtitle: Text(patient.geburtstag.toString()),
                  onTap: () {
                    onPatientSelected(patient);
                  },
                );
              }),
        ],
      ),
    );
  }
}

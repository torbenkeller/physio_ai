import 'package:fast_immutable_collections/src/ilist/ilist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_event_entry.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patient_detail_page.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezept_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
              popUpLocation: PopUpLocation.fromStartZeit(widget.event.startZeit),
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

class _EventPopup extends ConsumerWidget {
  const _EventPopup({
    required this.event,
    required this.onClose,
  });

  final BehandlungKalender event;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final asyncPatient = ref.watch(patientProvider(event.patient.id));

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
                // Enhanced title section with same styling as behandlung creator
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.patient.name,
                            style: textTheme.titleLarge,
                          ),
                          Text(
                            '${DateFormat('HH:mm').format(event.startZeit)} - ${DateFormat('HH:mm').format(event.endZeit)}',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w400,
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
                // Patient data section with ListTiles and expressive icons
                asyncPatient.when(
                  data: (patient) => patient != null
                      ? _buildPatientData(context, patient)
                      : const SizedBox.shrink(),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                // Rezept section - always show, either with data or placeholder
                const SizedBox(height: 16),
                event.rezeptId != null
                    ? _BehandlungDetailPopupRezept(rezeptId: event.rezeptId!)
                    : _buildNoRezeptSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientData(BuildContext context, Patient patient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.cake),
          title: Text(DateFormat('dd.MM.yyyy').format(patient.geburtstag)),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        // Address information

        // Contact information - clickable
        if (patient.telMobil?.isNotEmpty ?? false)
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(patient.telMobil!),
            contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () => _launchPhone(patient.telMobil!),
          ),
        if (patient.telFestnetz?.isNotEmpty ?? false)
          ListTile(
            leading: const Icon(Icons.phone_in_talk),
            title: Text(patient.telFestnetz!),
            contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () => _launchPhone(patient.telFestnetz!),
          ),
        if (patient.email?.isNotEmpty ?? false)
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(patient.email!),
            contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () => _launchEmail(patient.email!),
          ),
      ],
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildNoRezeptSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          'Rezept',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.receipt_long),
          title: const Text('Kein Rezept verbunden'),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
      ],
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
      final AsyncData<Rezept> data => _buildRezeptDetails(context, data.value),
      AsyncLoading<Rezept?>() => const CircularProgressIndicator(),
      AsyncError<Rezept?>() => Container(),
    };
  }

  Widget _buildRezeptDetails(BuildContext context, Rezept rezept) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          'Rezept',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: Text('Ausgestellt am ${DateFormat('dd.MM.yyyy').format(rezept.ausgestelltAm)}'),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        if (rezept.positionen.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: Text(
              rezept.positionen
                  .map((position) => '${position.anzahl}x ${position.behandlungsart.name}')
                  .join('\n'),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
      ],
    );
  }
}

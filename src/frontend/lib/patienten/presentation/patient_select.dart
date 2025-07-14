import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/shared_kernel/presentation/anchored_overlay.dart';
import 'package:physio_ai/shared_kernel/presentation/full_screen_overlay.dart';
import 'package:physio_ai/shared_kernel/utils.dart';

class PatientSelect extends StatefulWidget {
  const PatientSelect({
    required this.patient,
    required this.onPatientSelected,
    this.errorText,
    super.key,
  });

  final ValueChanged<Patient?> onPatientSelected;
  final Patient? patient;
  final String? errorText;

  @override
  State<PatientSelect> createState() => _PatientSelectState();
}

class _PatientSelectState extends State<PatientSelect> {
  bool _isOverlayShowing = false;

  bool _isHovering = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext _) {
    final selectContent = InkWell(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      onHover: (isHovering) {
        setState(() {
          _isHovering = isHovering;
        });
      },
      onTap: () {
        setState(() {
          _isOverlayShowing = true;
        });
      },
      child: InputDecorator(
        isFocused: _isFocused,
        isHovering: _isHovering,
        isEmpty: widget.patient == null,
        decoration: InputDecoration(
          labelText: 'Patient',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: 'Patient auswählen',
          suffixIcon: widget.patient == null
              ? const Icon(Icons.arrow_drop_down)
              : IconButton(
                  onPressed: () {
                    widget.onPatientSelected(null);
                  },
                  icon: const Icon(Icons.close),
                ),
          errorText: widget.errorText,
        ),
        child: widget.patient?.let(
          (patient) => ListTile(
            mouseCursor: MouseCursor.uncontrolled,
            contentPadding: EdgeInsets.zero,
            title: Text(patient.fullName),
            subtitle: Text(DateFormat.yMd().format(patient.geburtstag)),
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (_, constraints) {
        return FullScreenOverlay(
          isShowing: _isOverlayShowing,
          overlayContent: GestureDetector(
            onTap: () {
              setState(() {
                _isOverlayShowing = false;
              });
            },
          ),
          child: AnchoredOverlay(
            isShowing: _isOverlayShowing,
            overlayConstraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
            ),
            anchor: selectContent,
            overlayOffset: const Offset(0, -16),
            overlayContent: _PatientOverlay(
              patient: widget.patient,
              onPatientSelected: (patient) {
                setState(() {
                  _isOverlayShowing = false;
                });
                widget.onPatientSelected(patient);
              },
            ),
          ),
        );
      },
    );
  }
}

class _PatientOverlay extends StatefulWidget {
  const _PatientOverlay({
    required this.patient,
    required this.onPatientSelected,
    super.key,
  });

  final ValueChanged<Patient?> onPatientSelected;
  final Patient? patient;

  @override
  State<_PatientOverlay> createState() => _PatientOverlayState();
}

class _PatientOverlayState extends State<_PatientOverlay> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.patient?.fullName ?? '';
    _controller.addListener(_onTextUpdated);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextUpdated)
      ..dispose();

    super.dispose();
  }

  void _onTextUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          return;
        }
        if (_controller.text.isEmpty) {
          widget.onPatientSelected(null);
        }
      },
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Patient suchen...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controller.clear();
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
            ),
            SizedBox(
              height: 64 * 4,
              child: _PatientenSearchResults(
                searchText: _controller.text,
                onPatientSelected: (patient) {
                  widget.onPatientSelected(patient);
                },
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _PatientenSearchResults extends ConsumerWidget {
  const _PatientenSearchResults({
    required this.searchText,
    required this.onPatientSelected,
    super.key,
  });

  final String searchText;

  final ValueChanged<Patient> onPatientSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPatienten = ref.watch(patientenProvider);
    final patienten = asyncPatienten.value ?? const IListConst<Patient>([]);

    return ListView(
      children: [
        ...patienten
            .where(
              (patient) => patient.fullName.toLowerCase().contains(searchText.toLowerCase()),
            )
            .map(
              (patient) {
                return ListTile(
                  title: Text(patient.fullName),
                  subtitle: Text('Geboren: ${DateFormat('dd.MM.y').format(patient.geburtstag)}'),
                  onTap: () {
                    onPatientSelected(patient);
                  },
                );
              },
            ),
      ],
    );
  }
}

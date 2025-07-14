import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/shared_kernel/presentation/anchored_overlay.dart';

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
          hintText: 'Patient auswählen',
          suffixIcon: Icon(Icons.arrow_drop_down),
          errorText: widget.errorText,
        ),
        child: widget.patient?.let(
          (patient) => ListTile(
            mouseCursor: MouseCursor.uncontrolled,
            contentPadding: EdgeInsets.zero,
            title: Text(patient.fullName),
            subtitle: Text(DateFormat.yMd().format(widget.patient!.geburtstag)),
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (_, constraints) {
        return AnchoredOverlay(
          isShowing: _isOverlayShowing,
          overlaySize: Size(constraints.maxWidth, 64 * 5),
          anchor: selectContent,
          overlayOffset: const Offset(0, -8),
          overlayContent: _PatientOverlay(
            patient: widget.patient,
            onPatientSelected: (patient) {
              setState(() {
                _isOverlayShowing = false;
              });
              widget.onPatientSelected(patient);
            },
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
  String? _selectedText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.patient?.fullName ?? '';
    _selectedText = widget.patient?.fullName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                            widget.onPatientSelected(null);
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
              Expanded(
                child: _PatientenSearchResults(
                  searchText: _selectedText,
                  onPatientSelected: (patient) {
                    widget.onPatientSelected(patient);
                  },
                ),
              ),
            ],
          ),
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

  final String? searchText;

  final ValueChanged<Patient> onPatientSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPatienten = ref.watch(patientenProvider);
    final patienten = asyncPatienten.value ?? const IListConst<Patient>([]);

    return ListView(
      children: [
        ...patienten
            .where(
              (patient) => patient.fullName.toLowerCase().contains(searchText?.toLowerCase() ?? ''),
            )
            .map(
              (patient) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(patient.fullName),
                  subtitle: Text(patient.geburtstag.toString()),
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

extension ObjectExt<T> on T? {
  S? let<S>(S Function(T) fn) {
    if (this == null) return null;
    return fn(this as T);
  }
}

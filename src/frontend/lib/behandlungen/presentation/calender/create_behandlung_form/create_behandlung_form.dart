import 'dart:developer';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/behandlungen/presentation/calender/create_behandlung_form/create_behandlung_form_container.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_proxy.dart';
import 'package:physio_ai/shared_kernel/presentation/form_proxy.dart';

class CreateBehandlungForm extends StatefulWidget {
  const CreateBehandlungForm({
    required this.startZeit,
    super.key,
  });

  final DateTime startZeit;

  @override
  State<CreateBehandlungForm> createState() => _CreateBehandlungFormState();
}

class _CreateBehandlungFormState extends State<CreateBehandlungForm> {
  late final CreateBehandlungFormContainer _formContainer;

  @override
  void initState() {
    super.initState();
    _formContainer = CreateBehandlungFormContainer.fromStartZeit(
      startZeit: widget.startZeit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormProxy(
      formContainer: _formContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            children: [
              FormFieldProxy(
                formFieldContainer: _formContainer.startZeit,
                builder: (state) {
                  return DropdownMenu(
                    menuHeight: 400,
                    initialSelection: _formContainer.startZeit.initialValue,
                    dropdownMenuEntries: [
                      for (var i = 0; i < 24 * 2; i++)
                        DropdownMenuEntry(
                          value: DateUtils.dateOnly(
                            widget.startZeit,
                          ).add(Duration(minutes: i * 30)),
                          label: DateFormat.Hm().format(
                            DateUtils.dateOnly(widget.startZeit).add(Duration(minutes: i * 30)),
                          ),
                        ),
                    ],
                  );
                },
              ),
              FormFieldProxy(
                formFieldContainer: _formContainer.endZeit,
                builder: (state) {
                  return DropdownMenu(
                    menuHeight: 400,
                    initialSelection: _formContainer.endZeit.initialValue,
                    onSelected: state.didChange,
                    dropdownMenuEntries: [
                      for (var i = 0; i < 24 * 2; i++)
                        DropdownMenuEntry(
                          value: DateUtils.dateOnly(
                            widget.startZeit,
                          ).add(Duration(minutes: i * 30)),
                          label: DateFormat.Hm().format(
                            DateUtils.dateOnly(widget.startZeit).add(Duration(minutes: i * 30)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          FormFieldProxy(
            formFieldContainer: _formContainer.patient,
            builder: (state) {
              return _PatientSection(patient: state.value, onPatientSelected: state.didChange);
            },
          ),
          ElevatedButton(
            onPressed: () {
              log(_formContainer.formKey.currentState!.validate().toString());
            },
            child: Text('validate'),
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/shared_kernel/presentation/form_container.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_container.dart';
import 'package:physio_ai/shared_kernel/validation/validators.dart';

class CreateBehandlungFormContainer extends FormContainer {
  CreateBehandlungFormContainer._({
    required this.startZeit,
    required this.endZeit,
    required this.patient,
  }) : super(formKey: GlobalKey<FormState>());

  factory CreateBehandlungFormContainer.fromStartZeit({
    required DateTime startZeit,
  }) {
    final startZeitContainer = FormFieldContainer<DateTime>(
      initialValue: startZeit,
      validators: [validateRequired],
    );

    final endZeitContainer = FormFieldContainer<DateTime>(
      initialValue: startZeit.add(const Duration(hours: 1)),
      validators: [validateRequired],
    );

    final patientContainer = FormFieldContainer<Patient?>(
      initialValue: null,
      validators: [validateRequired],
    );

    return CreateBehandlungFormContainer._(
      startZeit: startZeitContainer,
      endZeit: endZeitContainer,
      patient: patientContainer,
    );
  }

  final FormFieldContainer<DateTime> startZeit;
  final FormFieldContainer<DateTime> endZeit;
  final FormFieldContainer<Patient?> patient;

  // CreateBehandlungDto toFormDto() {
  //
  // }

  @override
  List<FormFieldContainer<dynamic>> get requiredFields => [startZeit, endZeit, patient];
}

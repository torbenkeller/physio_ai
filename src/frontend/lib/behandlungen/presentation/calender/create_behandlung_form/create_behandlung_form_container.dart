import 'package:flutter/material.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlung_form_dto.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/shared_kernel/presentation/form_container.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_container.dart';
import 'package:physio_ai/shared_kernel/validation/validators.dart';

class CreateBehandlungFormContainer extends FormContainer {
  CreateBehandlungFormContainer._({
    required this.startZeit,
    required this.endZeit,
    required this.patient,
    required this.rezept,
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

    final rezeptContainer = FormFieldContainer<Rezept?>(
      initialValue: null,
      validators: [],
    );

    return CreateBehandlungFormContainer._(
      startZeit: startZeitContainer,
      endZeit: endZeitContainer,
      patient: patientContainer,
      rezept: rezeptContainer,
    );
  }

  final FormFieldContainer<DateTime> startZeit;
  final FormFieldContainer<DateTime> endZeit;
  final FormFieldContainer<Patient?> patient;
  final FormFieldContainer<Rezept?> rezept;

  BehandlungFormDto toFormDto() {
    return BehandlungFormDto(
      startZeit: startZeit.value,
      endZeit: endZeit.value,
      patientId: patient.value!.id,
      rezeptId: rezept.value?.id,
    );
  }

  @override
  List<FormFieldContainer<dynamic>> get requiredFields => [startZeit, endZeit, patient];
}

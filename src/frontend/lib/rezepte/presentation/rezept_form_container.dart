import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_form_dto.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/shared_kernel/presentation/form_container.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_container.dart';
import 'package:physio_ai/shared_kernel/validation/validators.dart';

class RezeptFormContainer extends FormContainer {
  RezeptFormContainer._({
    required this.ausgestelltAm,
    required this.patientId,
    required Behandlungsart initialBehandlungsart,
    required this.positionen,
  })  : _initialBehandlungsart = initialBehandlungsart,
        super(formKey: GlobalKey<FormState>());

  /// Factory constructor to create a form container from a Rezept
  factory RezeptFormContainer.fromRezept({
    required Rezept? rezept,
    required Behandlungsart initialBehandlungsart,
  }) {
    final ausgestelltAm = FormFieldContainer<DateTime>(
      initialValue: rezept?.ausgestelltAm ?? DateTime.now(),
      validators: [validateRequired],
    );

    final patientId = FormFieldContainer<String?>(
      initialValue: rezept?.patient.id,
      validators: [validateRequired],
    );

    final positionen = rezept?.positionen
            .map((pos) => RezeptPositionFormGroup.fromPosition(rezeptPos: pos))
            .toIList() ??
        IListConst([RezeptPositionFormGroup.empty(initialBehandlungsart: initialBehandlungsart)]);

    return RezeptFormContainer._(
      ausgestelltAm: ausgestelltAm,
      patientId: patientId,
      initialBehandlungsart: initialBehandlungsart,
      positionen: positionen,
    );
  }

  final FormFieldContainer<DateTime> ausgestelltAm;
  final FormFieldContainer<String?> patientId;
  IList<RezeptPositionFormGroup> positionen;

  final Behandlungsart _initialBehandlungsart;

  void addPosition() {
    final newPosition =
        RezeptPositionFormGroup.empty(initialBehandlungsart: _initialBehandlungsart);
    positionen = positionen.add(newPosition);
  }

  void removePosition(int index) {
    if (index >= 0 && index < positionen.length) {
      positionen = positionen.removeAt(index);
    }
  }

  RezeptFormDto toFormDto() {
    final selectedPatientId = patientId.value;
    if (selectedPatientId == null || selectedPatientId.isEmpty) {
      throw Exception('Bitte wählen Sie einen Patienten aus');
    }

    final positionenDto = positionen.map((pos) {
      final behandlungsart = pos.behandlungsart.value;
      return RezeptPositionDto(
        behandlungsartId: behandlungsart.id,
        anzahl: int.parse(pos.anzahl.value),
      );
    }).toList();

    return RezeptFormDto(
      patientId: selectedPatientId,
      ausgestelltAm: ausgestelltAm.value,
      positionen: positionenDto,
    );
  }

  Rezept toRezept({String? existingId}) {
    return Rezept(
      id: existingId ?? '',
      patient: RezeptPatient(id: patientId.value!, nachname: '', vorname: ''),
      ausgestelltAm: ausgestelltAm.value,
      preisGesamt: price,
      positionen: positionen.map((p) => p.toRezeptPos()).toIList(),
    );
  }

  double get price => positionen.sumBy((p) => p.price);

  @override
  List<FormFieldContainer<dynamic>> get requiredFields => [
        ausgestelltAm,
        patientId,
        ...positionen.expand((p) => [p.anzahl, p.behandlungsart]),
      ];
}

class RezeptPositionFormGroup {
  RezeptPositionFormGroup._({
    required int initialAnzahl,
    required Behandlungsart initialBehandlungsart,
  })  : anzahl = FormFieldContainer<String>(
          initialValue: initialAnzahl.toString(),
          validators: [validateRequired],
        ),
        behandlungsart = FormFieldContainer<Behandlungsart>(
          initialValue: initialBehandlungsart,
          validators: [validateRequired],
        );

  factory RezeptPositionFormGroup.empty({required Behandlungsart initialBehandlungsart}) {
    return RezeptPositionFormGroup._(
      initialAnzahl: 1,
      initialBehandlungsart: initialBehandlungsart,
    );
  }

  factory RezeptPositionFormGroup.fromPosition({required RezeptPos rezeptPos}) {
    return RezeptPositionFormGroup._(
      initialAnzahl: rezeptPos.anzahl,
      initialBehandlungsart: rezeptPos.behandlungsart,
    );
  }

  final FormFieldContainer<String> anzahl;
  final FormFieldContainer<Behandlungsart> behandlungsart;

  RezeptPos toRezeptPos() {
    return RezeptPos(
      anzahl: int.parse(anzahl.value),
      behandlungsart: behandlungsart.value,
    );
  }

  double get price {
    return int.parse(anzahl.value) * behandlungsart.value.preis;
  }
}

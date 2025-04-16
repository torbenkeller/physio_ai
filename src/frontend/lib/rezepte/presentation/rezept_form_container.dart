import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:physio_ai/patienten/presentation/form_container.dart';
import 'package:physio_ai/rezepte/rezept.dart';

part 'generated/rezept_form_container.freezed.dart';

class RezeptFormContainer extends FormContainer {
  RezeptFormContainer()
      : ausgestelltAm = GlobalKey<FormFieldState<DateTime>>(),
        positionen = const IListConst<RezeptPositionFormField>(<RezeptPositionFormField>[]),
        super(formKey: GlobalKey<FormState>());

  /// Factory constructor to create a form container from a Rezept
  factory RezeptFormContainer.fromRezept(Rezept? rezept) {
    final container = RezeptFormContainer();

    if (rezept != null) {
      for (final _ in rezept.positionen) {
        container.addPosition();
      }
    } else {
      container.addPosition();
    }

    return container;
  }

  final GlobalKey<FormFieldState<DateTime>> ausgestelltAm;
  IList<RezeptPositionFormField> positionen;

  void addPosition() {
    final newPosition = RezeptPositionFormField();
    positionen = positionen.add(newPosition);
  }

  void removePosition(int index) {
    if (index >= 0 && index < positionen.length) {
      positionen = positionen.removeAt(index);
    }
  }

  RezeptFormState toFormState() {
    final positionStates = positionen.map((pos) {
      return RezeptPositionState(
        anzahl: int.tryParse(pos.anzahl.currentState?.value ?? '1') ?? 1,
        behandlungsart: pos.behandlungsart.currentState?.value ??
            const Behandlungsart(id: '', name: '', preis: 0.0),
      );
    }).toIList();

    return RezeptFormState(
      ausgestelltAm: ausgestelltAm.currentState?.value ?? DateTime.now(),
      preisGesamt: 0.0,
      positionen: positionStates,
    );
  }

  Map<String, dynamic> toRezeptCreateDto({String? patientId}) {
    final defaultPatientId = patientId ?? "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d";

    final positionenDto = positionen.map((pos) {
      final behandlungsart = pos.behandlungsart.currentState!.value!;
      return {
        'behandlungsartId': behandlungsart.id,
        'anzahl': int.parse(pos.anzahl.currentState!.value ?? '0'),
      };
    }).toList();

    final formState = toFormState();
    final totalPrice = formState.calculateTotalPrice();

    return {
      'patientId': defaultPatientId,
      'ausgestelltAm': ausgestelltAm.currentState!.value!.toIso8601String().split('T')[0],
      'preisGesamt': totalPrice,
      'positionen': positionenDto,
    };
  }

  Rezept toRezept({String? existingId, String? patientId}) {
    final positionenList = positionen
        .map((p) => RezeptPos(
              anzahl: int.parse(p.anzahl.currentState!.value ?? '0'),
              behandlungsart: p.behandlungsart.currentState!.value ??
                  const Behandlungsart(
                    id: '',
                    name: '',
                    preis: 0.0,
                  ),
            ))
        .toList();

    final formState = toFormState();
    final totalPrice = formState.calculateTotalPrice();

    return Rezept(
      id: existingId ?? '',
      patientId: patientId,
      ausgestelltAm: ausgestelltAm.currentState!.value!,
      preisGesamt: totalPrice,
      positionen: positionenList.toIList(),
    );
  }

  @override
  List<GlobalKey<FormFieldState<dynamic>>> get requiredFields => [
        ausgestelltAm,
        ...positionen.expand((p) => [p.anzahl, p.behandlungsart]),
      ];
}

class RezeptPositionFormField {
  final anzahl = GlobalKey<FormFieldState<String>>();
  final behandlungsart = GlobalKey<FormFieldState<Behandlungsart>>();

  RezeptPositionFormField();
}

@freezed
abstract class RezeptFormState with _$RezeptFormState {
  const factory RezeptFormState({
    required DateTime ausgestelltAm,
    required double preisGesamt,
    required IList<RezeptPositionState> positionen,
  }) = _RezeptFormState;

  const RezeptFormState._();

  /// Calculate price for a specific position
  double calculatePositionPrice(int index) {
    if (index >= positionen.length) return 0;
    final position = positionen[index];
    return position.anzahl * position.behandlungsart.preis;
  }

  /// Calculate total price across all positions
  double calculateTotalPrice() {
    return positionen.fold(0, (sum, pos) => sum + (pos.anzahl * pos.behandlungsart.preis));
  }
}

@freezed
abstract class RezeptPositionState with _$RezeptPositionState {
  const factory RezeptPositionState({
    required int anzahl,
    required Behandlungsart behandlungsart,
  }) = _RezeptPositionState;
}

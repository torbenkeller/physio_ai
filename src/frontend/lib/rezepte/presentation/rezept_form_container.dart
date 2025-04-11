import 'package:flutter/material.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:physio_ai/rezepte/rezept.dart';

class RezeptFormContainer {
  final formKey = GlobalKey<FormState>();
  final ausgestelltAm = GlobalKey<FormFieldState<DateTime>>();
  final preisGesamt = GlobalKey<FormFieldState<String>>();
  final positionen = <RezeptPositionFormField>[];

  void addPosition() {
    positionen.add(RezeptPositionFormField());
  }

  void removePosition(int index) {
    if (index >= 0 && index < positionen.length) {
      positionen.removeAt(index);
    }
  }

  Rezept toRezept() {
    final positionenList = positionen
        .map((p) => RezeptPos(
              anzahl: int.parse(p.anzahl.currentState!.value ?? '0'),
              behandlungsart: Behandlungsart(
                id: '', // ID will be assigned by server
                name: p.behandlungsartName.currentState!.value ?? '',
                preis: double.parse(p.preis.currentState!.value ?? '0'),
              ),
            ))
        .toList();

    return Rezept(
      id: '', // ID will be assigned by server
      ausgestelltAm: ausgestelltAm.currentState!.value!,
      preisGesamt: double.parse(preisGesamt.currentState!.value ?? '0'),
      positionen: positionenList.toIList(),
    );
  }
}

class RezeptPositionFormField {
  final anzahl = GlobalKey<FormFieldState<String>>();
  final behandlungsartName = GlobalKey<FormFieldState<String>>();
  final preis = GlobalKey<FormFieldState<String>>();
}

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/patient_selection_view.dart';

class PatientSelectionPage extends ConsumerWidget {
  const PatientSelectionPage({
    required this.response,
    Key? key,
  }) : super(key: key);

  final RezeptEinlesenResponse response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Selection'),
      ),
      body: PatientSelectionView(
        response: response,
        onUseExistingPatient: (patientId) => _handleUseExistingPatient(patientId, context),
        onCreateNewPatient: () => _handleCreateNewPatient(context),
      ),
    );
  }

  void _handleUseExistingPatient(String patientId, BuildContext context) {
    // Create a rezept from the response with the existing patient
    final rezept = Rezept(
      id: '',
      patient: RezeptPatient(
        id: patientId,
        vorname: response.existingPatient!.vorname,
        nachname: response.existingPatient!.nachname,
      ),
      ausgestelltAm: response.rezept.ausgestelltAm,
      preisGesamt: 0,
      positionen: response.rezept.rezeptpositionen
          .map((pos) => RezeptPos(
                anzahl: pos.anzahl,
                behandlungsart: pos.behandlungsart,
              ))
          .toIList(),
    );

    // Navigate to create rezept page with the pre-filled data
    context.go('/rezepte/create', extra: rezept);
  }

  void _handleCreateNewPatient(BuildContext context) {
    // Create a new patient from the analyzed data
    final newPatient = Patient(
      id: '',
      vorname: response.patient.vorname,
      nachname: response.patient.nachname,
      geburtstag: response.patient.geburtstag,
      titel: response.patient.titel,
      strasse: response.patient.strasse,
      hausnummer: response.patient.hausnummer,
      plz: response.patient.postleitzahl,
      stadt: response.patient.stadt,
    );

    // Pass the original response as well for later rezept creation
    final patientWithRezeptData = PatientSelectionData(
      patient: newPatient,
      response: response,
    );

    // Navigate to create patient page with the pre-filled data
    context.go('/patienten/create', extra: patientWithRezeptData);
  }
}

// Class to hold both patient and rezept data when creating a new patient
class PatientSelectionData {
  PatientSelectionData({
    required this.patient,
    required this.response,
  });

  final Patient patient;
  final RezeptEinlesenResponse response;
}

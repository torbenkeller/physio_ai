import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/patient_selection_page.dart';

void main() {
  setUp(() {
    initializeDateFormatting();
  });
  
  group('PatientSelectionPage', () {
    final testPatient = EingelesenerPatient(
      vorname: 'Max',
      nachname: 'Mustermann',
      strasse: 'Teststraße',
      hausnummer: '123',
      postleitzahl: '12345',
      stadt: 'Teststadt',
      geburtstag: DateTime(1990, 1, 1),
    );

    final testExistingPatient = Patient(
      id: 'p1',
      vorname: 'Max',
      nachname: 'Mustermann',
      geburtstag: DateTime(1990, 1, 1),
      strasse: 'Teststraße',
      hausnummer: '123',
      plz: '12345',
      stadt: 'Teststadt',
    );

    final testRezept = EingelesenesRezept(
      ausgestelltAm: DateTime(2023, 6, 1),
      rezeptpositionen: [],
    );

    final testResponse = RezeptEinlesenResponse(
      patient: testPatient,
      rezept: testRezept,
      path: 'test/path.jpg',
      existingPatient: testExistingPatient,
    );

    testWidgets('renders PatientSelectionView with correct data', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientSelectionPage(
              response: testResponse,
            ),
          ),
        ),
      );

      expect(find.text('Patient Selection'), findsOneWidget);
      expect(find.text('Analyzed Patient Data'), findsOneWidget);
      expect(find.text('Matching Patient'), findsOneWidget);
      expect(find.textContaining('Max Mustermann'), findsWidgets);
    });
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/patient_selection_view.dart';

void main() {
  setUp(() {
    initializeDateFormatting();
  });
  
  group('PatientSelectionView', () {
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

    final responseWithNoMatch = RezeptEinlesenResponse(
      patient: testPatient,
      rezept: testRezept,
      path: 'test/path.jpg',
      existingPatient: null,
    );

    testWidgets('displays analyzed patient data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PatientSelectionView(
              response: testResponse,
              onUseExistingPatient: (_) {},
              onCreateNewPatient: () {},
            ),
          ),
        ),
      );

      expect(find.text('Analyzed Patient Data'), findsOneWidget);
      expect(find.text('Max Mustermann'), findsOneWidget);
      // Using finder that doesn't check for exact match since there are multiple instances
      expect(find.textContaining('12345 Teststadt'), findsWidgets);
      expect(find.text('01.01.1990'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays existing patient match when available', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PatientSelectionView(
              response: testResponse,
              onUseExistingPatient: (_) {},
              onCreateNewPatient: () {},
            ),
          ),
        ),
      );

      expect(find.text('Matching Patient'), findsOneWidget);
      expect(find.textContaining('Max Mustermann (p1)'), findsOneWidget);
    });

    testWidgets('calls onUseExistingPatient when use existing button is pressed',
        (WidgetTester tester) async {
      bool useExistingCalled = false;
      String? patientId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PatientSelectionView(
              response: testResponse,
              onUseExistingPatient: (id) {
                useExistingCalled = true;
                patientId = id;
              },
              onCreateNewPatient: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Use Existing Patient'));
      await tester.pump();

      expect(useExistingCalled, true);
      expect(patientId, 'p1');
    });

    testWidgets('calls onCreateNewPatient when create new button is pressed',
        (WidgetTester tester) async {
      bool createNewCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PatientSelectionView(
              response: testResponse,
              onUseExistingPatient: (_) {},
              onCreateNewPatient: () {
                createNewCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Create New Patient'));
      await tester.pump();

      expect(createNewCalled, true);
    });

    testWidgets('shows no match section when no existing patient', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PatientSelectionView(
              response: responseWithNoMatch,
              onUseExistingPatient: (_) {},
              onCreateNewPatient: () {},
            ),
          ),
        ),
      );

      expect(find.text('No matching patient found'), findsOneWidget);
      expect(find.text('Create New Patient'), findsOneWidget);
      expect(find.text('Use Existing Patient'), findsNothing);
    });
  });
}
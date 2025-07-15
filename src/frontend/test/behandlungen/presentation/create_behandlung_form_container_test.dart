import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlung_form_dto.dart';
import 'package:physio_ai/behandlungen/presentation/calender/create_behandlung_form/create_behandlung_form_container.dart';
import 'package:physio_ai/generated/l10n.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_proxy.dart';
import 'package:physio_ai/shared_kernel/presentation/form_proxy.dart';

void main() {
  group('CreateBehandlungFormContainer', () {
    final testStartZeit = DateTime(2024, 1, 15, 10, 0);
    final expectedEndZeit = DateTime(2024, 1, 15, 11, 0);

    Patient createTestPatient() {
      return Patient(
        id: '1',
        vorname: 'Test',
        nachname: 'Patient',
        geburtstag: DateTime(1990, 1, 1),
        titel: 'Dr.',
        strasse: 'Teststrasse',
        hausnummer: '123',
        plz: '12345',
        stadt: 'Teststadt',
        telMobil: '0123456789',
        telFestnetz: '0987654321',
        email: 'test@example.com',
      );
    }

    Rezept createTestRezept() {
      return Rezept(
        id: '1',
        patient: const RezeptPatient(
          id: '1',
          vorname: 'Test',
          nachname: 'Patient',
        ),
        ausgestelltAm: DateTime(2024, 1, 1),
        preisGesamt: 100,
      );
    }

    test('initializes with correct startZeit and endZeit', () {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );

      expect(container.startZeit.initialValue, equals(testStartZeit));
      expect(container.endZeit.initialValue, equals(expectedEndZeit));
    });

    test('initializes with null patient and rezept', () {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );

      expect(container.patient.initialValue, isNull);
      expect(container.rezept.initialValue, isNull);
    });

    test('requiredFields returns the correct subset of fields', () {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );
      final requiredFields = container.requiredFields;

      expect(requiredFields, hasLength(3));
      expect(requiredFields, contains(container.startZeit));
      expect(requiredFields, contains(container.endZeit));
      expect(requiredFields, contains(container.patient));
    });

    testWidgets('toFormDto converts container fields to DTO correctly with patient only', (
      WidgetTester tester,
    ) async {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );
      final patient = createTestPatient();

      // Build a test widget using FormProxy and FormFieldProxy
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FormProxy(
              formContainer: container,
              child: Column(
                children: [
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.startZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.endZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<Patient?>(
                    formFieldContainer: container.patient,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<Rezept?>(
                    formFieldContainer: container.rezept,
                    builder: (state) => Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait for widget to build
      await tester.pump();

      // Update form field values
      container.patient.key.currentState!.didChange(patient);

      // Trigger the form validation
      await tester.pump();

      // Convert to DTO and verify values
      final dto = container.toFormDto();

      expect(dto, isA<BehandlungFormDto>());
      expect(dto.startZeit, equals(testStartZeit));
      expect(dto.endZeit, equals(expectedEndZeit));
      expect(dto.patientId, equals('1'));
      expect(dto.rezeptId, isNull);
    });

    testWidgets('toFormDto converts container fields to DTO correctly with patient and rezept', (
      WidgetTester tester,
    ) async {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );
      final patient = createTestPatient();
      final rezept = createTestRezept();

      // Build a test widget using FormProxy and FormFieldProxy
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FormProxy(
              formContainer: container,
              child: Column(
                children: [
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.startZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.endZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<Patient?>(
                    formFieldContainer: container.patient,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<Rezept?>(
                    formFieldContainer: container.rezept,
                    builder: (state) => Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait for widget to build
      await tester.pump();

      // Update form field values
      container.patient.key.currentState!.didChange(patient);
      container.rezept.key.currentState!.didChange(rezept);

      // Trigger the form validation
      await tester.pump();

      // Convert to DTO and verify values
      final dto = container.toFormDto();

      expect(dto, isA<BehandlungFormDto>());
      expect(dto.startZeit, equals(testStartZeit));
      expect(dto.endZeit, equals(expectedEndZeit));
      expect(dto.patientId, equals('1'));
      expect(dto.rezeptId, equals('1'));
    });

    testWidgets('toFormDto returns updated field values when form fields are changed', (
      WidgetTester tester,
    ) async {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );
      final patient = createTestPatient();
      final rezept = createTestRezept();
      final updatedStartZeit = DateTime(2024, 1, 15, 14, 0);
      final updatedEndZeit = DateTime(2024, 1, 15, 15, 30);

      // Build a test widget to hold the form fields
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              key: container.formKey,
              child: Column(
                children: [
                  FormField<DateTime>(
                    key: container.startZeit.key,
                    initialValue: container.startZeit.initialValue,
                    builder: (state) => Container(),
                  ),
                  FormField<DateTime>(
                    key: container.endZeit.key,
                    initialValue: container.endZeit.initialValue,
                    builder: (state) => Container(),
                  ),
                  FormField<Patient?>(
                    key: container.patient.key,
                    initialValue: container.patient.initialValue,
                    builder: (state) => Container(),
                  ),
                  FormField<Rezept?>(
                    key: container.rezept.key,
                    initialValue: container.rezept.initialValue,
                    builder: (state) => Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait for widget to build
      await tester.pump();

      // Update form field values
      container.startZeit.key.currentState!.didChange(updatedStartZeit);
      container.endZeit.key.currentState!.didChange(updatedEndZeit);
      container.patient.key.currentState!.didChange(patient);
      container.rezept.key.currentState!.didChange(rezept);

      // Trigger the form validation
      await tester.pump();

      // Convert to DTO and verify updated values
      final dto = container.toFormDto();

      expect(dto, isA<BehandlungFormDto>());
      expect(dto.startZeit, equals(updatedStartZeit));
      expect(dto.endZeit, equals(updatedEndZeit));
      expect(dto.patientId, equals('1'));
      expect(dto.rezeptId, equals('1'));
    });

    testWidgets('form validation works correctly with FormContainer base class', (
      WidgetTester tester,
    ) async {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );

      // Build a test widget using FormProxy and FormFieldProxy
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            PhysioAiLocalizations.delegate,
          ],
          supportedLocales: const [Locale('de')],
          home: Material(
            child: FormProxy(
              formContainer: container,
              child: Column(
                children: [
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.startZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.endZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<Patient?>(
                    formFieldContainer: container.patient,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<Rezept?>(
                    formFieldContainer: container.rezept,
                    builder: (state) => Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait for widget to build
      await tester.pump();

      expect(container.formKey.currentState!.validate(), isFalse);

      container.patient.key.currentState!.didChange(createTestPatient());

      expect(container.formKey.currentState!.validate(), isTrue);
    });

    test('areRequiredFieldsFilled returns false when patient is null', () {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );

      // Patient is null by default
      expect(container.areRequiredFieldsFilled, isFalse);
    });

    testWidgets('areRequiredFieldsFilled returns true when all required fields are filled', (
      WidgetTester tester,
    ) async {
      final container = CreateBehandlungFormContainer.fromStartZeit(
        startZeit: testStartZeit,
      );
      final patient = createTestPatient();

      // Build a test widget using FormProxy and FormFieldProxy
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FormProxy(
              formContainer: container,
              child: Column(
                children: [
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.startZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<DateTime>(
                    formFieldContainer: container.endZeit,
                    builder: (state) => Container(),
                  ),
                  FormFieldProxy<Patient?>(
                    formFieldContainer: container.patient,
                    builder: (state) => Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait for widget to build
      await tester.pump();

      // Update form field values
      container.patient.key.currentState!.didChange(patient);

      // Trigger the form validation
      await tester.pump();

      expect(container.areRequiredFieldsFilled, isTrue);
    });
  });
}

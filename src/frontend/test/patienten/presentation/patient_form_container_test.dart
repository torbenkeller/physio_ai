import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/infrastructure/patient_form_dto.dart';
import 'package:physio_ai/patienten/presentation/patient_form_container.dart';

void main() {
  group('PatientFormContainer', () {
    final testDateTime = DateTime(1990);

    Patient createTestPatient() {
      return Patient(
        id: '1',
        vorname: 'Test',
        nachname: 'Patient',
        geburtstag: testDateTime,
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

    test('initializes with existing patient data', () {
      final patient = createTestPatient();
      final container = PatientFormContainer(patient: patient);

      expect(container.vorname.initialValue, equals('Test'));
      expect(container.nachname.initialValue, equals('Patient'));
      expect(container.geburtstag.initialValue, equals(testDateTime));
      expect(container.titel.initialValue, equals('Dr.'));
      expect(container.strasse.initialValue, equals('Teststrasse'));
      expect(container.hausnummer.initialValue, equals('123'));
      expect(container.plz.initialValue, equals('12345'));
      expect(container.stadt.initialValue, equals('Teststadt'));
      expect(container.telMobil.initialValue, equals('0123456789'));
      expect(container.telFestnetz.initialValue, equals('0987654321'));
      expect(container.email.initialValue, equals('test@example.com'));
    });

    test('initializes with empty values for new patient', () {
      final container = PatientFormContainer(patient: null);

      expect(container.vorname.initialValue, equals(''));
      expect(container.nachname.initialValue, equals(''));
      expect(container.geburtstag.initialValue, isNull);
      expect(container.titel.initialValue, isNull);
      expect(container.strasse.initialValue, isNull);
      expect(container.hausnummer.initialValue, isNull);
      expect(container.plz.initialValue, isNull);
      expect(container.stadt.initialValue, isNull);
      expect(container.telMobil.initialValue, isNull);
      expect(container.telFestnetz.initialValue, isNull);
      expect(container.email.initialValue, isNull);
    });

    test('requiredFields returns the correct subset of fields', () {
      final container = PatientFormContainer(patient: null);
      final requiredFields = container.requiredFields;

      expect(requiredFields, hasLength(3));
      expect(requiredFields, contains(container.vorname));
      expect(requiredFields, contains(container.nachname));
      expect(requiredFields, contains(container.geburtstag));
    });

    test('toFormDto converts container fields to DTO correctly', () {
      final patient = createTestPatient();
      final container = PatientFormContainer(patient: patient);
      final dto = container.toFormDto();

      expect(dto, isA<PatientFormDto>());
      expect(dto.vorname, equals('Test'));
      expect(dto.nachname, equals('Patient'));
      expect(dto.geburtstag, equals(testDateTime));
      expect(dto.titel, equals('Dr.'));
      expect(dto.strasse, equals('Teststrasse'));
      expect(dto.hausnummer, equals('123'));
      expect(dto.plz, equals('12345'));
      expect(dto.stadt, equals('Teststadt'));
      expect(dto.telMobil, equals('0123456789'));
      expect(dto.telFestnetz, equals('0987654321'));
      expect(dto.email, equals('test@example.com'));
    });

    testWidgets('toFormDto returns updated field values when form fields are changed', (
      WidgetTester tester,
    ) async {
      final patient = createTestPatient();
      final container = PatientFormContainer(patient: patient);
      final updatedBirthday = DateTime(1985, 5, 15);

      // Build a test widget to hold the form fields
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              key: container.formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: container.vorname.key,
                    initialValue: container.vorname.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.nachname.key,
                    initialValue: container.nachname.initialValue,
                    onChanged: (value) {},
                  ),
                  DateTimeFormField(
                    key: container.geburtstag.key,
                    initialValue: container.geburtstag.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.titel.key,
                    initialValue: container.titel.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.strasse.key,
                    initialValue: container.strasse.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.hausnummer.key,
                    initialValue: container.hausnummer.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.plz.key,
                    initialValue: container.plz.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.stadt.key,
                    initialValue: container.stadt.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.telMobil.key,
                    initialValue: container.telMobil.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.telFestnetz.key,
                    initialValue: container.telFestnetz.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.email.key,
                    initialValue: container.email.initialValue,
                    onChanged: (value) {},
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
      container.vorname.key.currentState!.didChange('Max');
      container.nachname.key.currentState!.didChange('Mustermann');
      container.geburtstag.key.currentState!.didChange(updatedBirthday);
      container.titel.key.currentState!.didChange('Prof.');
      container.strasse.key.currentState!.didChange('Musterstraße');
      container.hausnummer.key.currentState!.didChange('456');
      container.plz.key.currentState!.didChange('54321');
      container.stadt.key.currentState!.didChange('Musterstadt');
      container.telMobil.key.currentState!.didChange('9876543210');
      container.telFestnetz.key.currentState!.didChange('1234567890');
      container.email.key.currentState!.didChange('max@example.com');

      // Trigger the form validation
      await tester.pump();

      // Convert to DTO and verify updated values
      final dto = container.toFormDto();

      expect(dto, isA<PatientFormDto>());
      expect(dto.vorname, equals('Max'));
      expect(dto.nachname, equals('Mustermann'));
      expect(dto.geburtstag, equals(updatedBirthday));
      expect(dto.titel, equals('Prof.'));
      expect(dto.strasse, equals('Musterstraße'));
      expect(dto.hausnummer, equals('456'));
      expect(dto.plz, equals('54321'));
      expect(dto.stadt, equals('Musterstadt'));
      expect(dto.telMobil, equals('9876543210'));
      expect(dto.telFestnetz, equals('1234567890'));
      expect(dto.email, equals('max@example.com'));
    });
  });
}

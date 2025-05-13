import 'package:date_field/date_field.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_form_dto.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form_container.dart';
import 'package:physio_ai/rezepte/rezept.dart';

void main() {
  group('RezeptFormContainer', () {
    final testDateTime = DateTime(2023);
    const testBehandlungsart = Behandlungsart(
      id: 'b1',
      name: 'Massage',
      preis: 25,
    );
    const testBehandlungsart2 = Behandlungsart(
      id: 'b2',
      name: 'Krankengymnastik',
      preis: 30,
    );

    Rezept createTestRezept() {
      return Rezept(
        id: 'r1',
        patient: const RezeptPatient(
          id: 'p1',
          vorname: 'Max',
          nachname: 'Mustermann',
        ),
        ausgestelltAm: testDateTime,
        preisGesamt: 50,
        positionen: const IListConst([
          RezeptPos(
            anzahl: 2,
            behandlungsart: testBehandlungsart,
          ),
        ]),
      );
    }

    test('initializes with existing rezept data', () {
      final rezept = createTestRezept();
      final container = RezeptFormContainer.fromRezept(
        rezept: rezept,
        initialBehandlungsart: testBehandlungsart,
      );

      expect(container.ausgestelltAm.initialValue, equals(testDateTime));
      expect(container.patientId.initialValue, equals('p1'));
      expect(container.positionen.length, equals(1));
      expect(container.positionen[0].anzahl.initialValue, equals('2'));
      expect(container.positionen[0].behandlungsart.initialValue, equals(testBehandlungsart));
    });

    test('initializes with new rezept values when rezept is null', () {
      final container = RezeptFormContainer.fromRezept(
        rezept: null,
        initialBehandlungsart: testBehandlungsart,
      );

      expect(container.ausgestelltAm.initialValue, isNotNull);
      expect(container.patientId.initialValue, isNull);
      expect(container.positionen.length, equals(1));
      expect(container.positionen[0].anzahl.initialValue, equals('1'));
      expect(container.positionen[0].behandlungsart.initialValue, equals(testBehandlungsart));
    });

    test('requiredFields returns the correct subset of fields', () {
      final container = RezeptFormContainer.fromRezept(
        rezept: null,
        initialBehandlungsart: testBehandlungsart,
      );
      final requiredFields = container.requiredFields;

      expect(requiredFields, hasLength(4));
      expect(requiredFields, contains(container.ausgestelltAm));
      expect(requiredFields, contains(container.patientId));
      expect(requiredFields, contains(container.positionen[0].anzahl));
      expect(requiredFields, contains(container.positionen[0].behandlungsart));
    });

    test('addPosition adds a new position with the initialBehandlungsart', () {
      final container = RezeptFormContainer.fromRezept(
        rezept: null,
        initialBehandlungsart: testBehandlungsart,
      );
      expect(container.positionen.length, equals(1));

      container.addPosition();
      
      expect(container.positionen.length, equals(2));
      expect(container.positionen[1].anzahl.initialValue, equals('1'));
      expect(container.positionen[1].behandlungsart.initialValue, equals(testBehandlungsart));
    });

    test('removePosition removes the position at the given index', () {
      final container = RezeptFormContainer.fromRezept(
        rezept: null,
        initialBehandlungsart: testBehandlungsart,
      )
        ..addPosition()
        ..removePosition(0);
      
      expect(container.positionen.length, equals(1));
      expect(container.positionen[0].anzahl.initialValue, equals('1'));
    });

    test('removePosition does nothing when index is out of bounds', () {
      final container = RezeptFormContainer.fromRezept(
        rezept: null,
        initialBehandlungsart: testBehandlungsart,
      );
      
      expect(container.positionen.length, equals(1));

      container
        ..removePosition(-1)
        ..removePosition(1);
      
      expect(container.positionen.length, equals(1));
    });

    test('toRezept creates a Rezept with correct values', () {
      final rezept = createTestRezept();
      final container = RezeptFormContainer.fromRezept(
        rezept: rezept,
        initialBehandlungsart: testBehandlungsart,
      );

      final result = container.toRezept(existingId: 'r1');

      expect(result.id, equals('r1'));
      expect(result.patient.id, equals('p1'));
      expect(result.ausgestelltAm, equals(testDateTime));
      expect(result.positionen.length, equals(1));
      expect(result.positionen[0].anzahl, equals(2));
      expect(result.positionen[0].behandlungsart, equals(testBehandlungsart));
      expect(result.preisGesamt, equals(50.0));
    });

    test('toFormDto converts container fields to DTO correctly', () {
      final rezept = createTestRezept();
      final container = RezeptFormContainer.fromRezept(
        rezept: rezept,
        initialBehandlungsart: testBehandlungsart,
      );

      final dto = container.toFormDto();

      expect(dto, isA<RezeptFormDto>());
      expect(dto.patientId, equals('p1'));
      expect(dto.ausgestelltAm, equals(testDateTime));
      expect(dto.preisGesamt, equals(50.0));
      expect(dto.positionen, isA<List<RezeptPositionDto>>());
      expect(dto.positionen.length, equals(1));
      expect(dto.positionen[0].behandlungsartId, equals('b1'));
      expect(dto.positionen[0].anzahl, equals(2));
    });

    test('toFormDto throws exception when patientId is null', () {
      final container = RezeptFormContainer.fromRezept(
        rezept: null,
        initialBehandlungsart: testBehandlungsart,
      );

      expect(container.toFormDto, throwsException);
    });

    testWidgets('toFormDto returns updated field values when form fields are changed',
        (WidgetTester tester) async {
      final rezept = createTestRezept();
      final container = RezeptFormContainer.fromRezept(
        rezept: rezept,
        initialBehandlungsart: testBehandlungsart,
      );
      final updatedDate = DateTime(2023, 5, 15);

      // Build a test widget to hold the form fields
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              key: container.formKey,
              child: Column(
                children: [
                  DateTimeFormField(
                    key: container.ausgestelltAm.key,
                    initialValue: container.ausgestelltAm.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.patientId.key,
                    initialValue: container.patientId.initialValue,
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    key: container.positionen[0].anzahl.key,
                    initialValue: container.positionen[0].anzahl.initialValue,
                    onChanged: (value) {},
                  ),
                  FormField<Behandlungsart>(
                    key: container.positionen[0].behandlungsart.key,
                    initialValue: container.positionen[0].behandlungsart.initialValue,
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
      container.ausgestelltAm.key.currentState!.didChange(updatedDate);
      container.patientId.key.currentState!.didChange('p2');
      container.positionen[0].anzahl.key.currentState!.didChange('3');
      // Update behandlungsart using the key state
      container.positionen[0].behandlungsart.key.currentState!.didChange(testBehandlungsart2);

      // Trigger the form validation
      await tester.pump();

      // Convert to DTO and verify updated values
      final dto = container.toFormDto();

      expect(dto, isA<RezeptFormDto>());
      expect(dto.patientId, equals('p2'));
      expect(dto.ausgestelltAm, equals(updatedDate));
      expect(dto.positionen.length, equals(1));
      expect(dto.positionen[0].behandlungsartId, equals('b2'));
      expect(dto.positionen[0].anzahl, equals(3));
    });

    testWidgets('price calculation updates when position fields change',
        (WidgetTester tester) async {
      final container = RezeptFormContainer.fromRezept(
        rezept: null,
        initialBehandlungsart: testBehandlungsart,
      );
      
      // Build test widget
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              key: container.formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: container.positionen[0].anzahl.key,
                    initialValue: container.positionen[0].anzahl.initialValue,
                    onChanged: (value) {},
                  ),
                  FormField<Behandlungsart>(
                    key: container.positionen[0].behandlungsart.key,
                    initialValue: container.positionen[0].behandlungsart.initialValue,
                    builder: (state) => Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Initial price check (1 x 25.0 = 25.0)
      expect(container.price, equals(25.0));
      
      // Add second position
      container.addPosition();
      
      // Update widget to include new position field
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              key: container.formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: container.positionen[0].anzahl.key,
                    initialValue: container.positionen[0].anzahl.initialValue,
                    onChanged: (value) {},
                  ),
                  FormField<Behandlungsart>(
                    key: container.positionen[0].behandlungsart.key,
                    initialValue: container.positionen[0].behandlungsart.initialValue,
                    builder: (state) => Container(),
                  ),
                  TextFormField(
                    key: container.positionen[1].anzahl.key,
                    initialValue: container.positionen[1].anzahl.initialValue,
                    onChanged: (value) {},
                  ),
                  FormField<Behandlungsart>(
                    key: container.positionen[1].behandlungsart.key,
                    initialValue: container.positionen[1].behandlungsart.initialValue,
                    builder: (state) => Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Update the anzahl for the second position
      container.positionen[1].anzahl.key.currentState!.didChange('2');
      // Update the behandlungsart using the key state
      container.positionen[1].behandlungsart.key.currentState!.didChange(testBehandlungsart2);
      
      await tester.pump();
      
      // Price should be: 1 x 25.0 + 2 x 30.0 = 25.0 + 60.0 = 85.0
      expect(container.price, equals(85.0));
    });
  });
}

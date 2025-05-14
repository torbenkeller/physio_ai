import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_repository.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept_page.dart';

class MockRezeptRepository extends Mock implements RezeptRepository {}
class MockFile extends Mock implements File {}
class MockMultipartFile extends Mock implements MultipartFile {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('UploadRezeptPage', () {
    late MockRezeptRepository mockRepository;
    late MockFile mockFile;
    
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

    setUp(() {
      mockRepository = MockRezeptRepository();
      mockFile = MockFile();
      
      when(() => mockFile.path).thenReturn('/test/image.jpg');
    });

    testWidgets('shows upload UI with camera and gallery options', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            rezeptRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: UploadRezeptPage(),
          ),
        ),
      );

      expect(find.text('Rezept von Bild'), findsOneWidget);
      expect(find.text('Laden Sie ein Foto eines Rezepts hoch, um es automatisch zu analysieren'), findsOneWidget);
      expect(find.text('Aus Galerie'), findsOneWidget);
      expect(find.text('Kamera'), findsOneWidget);
    });
  });
}
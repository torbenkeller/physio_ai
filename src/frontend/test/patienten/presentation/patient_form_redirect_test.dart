import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Patient form redirect string replacement', () {
    test('should replace {patientId} placeholder with actual patient ID', () {
      const redirectTemplate = '/behandlungen?selectedPatient={patientId}';
      const patientId = 'patient-123';

      final result = redirectTemplate.replaceAll('{patientId}', patientId);

      expect(result, equals('/behandlungen?selectedPatient=patient-123'));
    });

    test('should handle multiple {patientId} placeholders', () {
      const redirectTemplate = '/dashboard/{patientId}/details?id={patientId}';
      const patientId = 'patient-456';

      final result = redirectTemplate.replaceAll('{patientId}', patientId);

      expect(result, equals('/dashboard/patient-456/details?id=patient-456'));
    });

    test('should handle template without {patientId} placeholder', () {
      const redirectTemplate = '/dashboard/overview';
      const patientId = 'patient-789';

      final result = redirectTemplate.replaceAll('{patientId}', patientId);

      expect(result, equals('/dashboard/overview'));
    });

    test('should handle empty patient ID', () {
      const redirectTemplate = '/behandlungen?selectedPatient={patientId}';
      const patientId = '';

      final result = redirectTemplate.replaceAll('{patientId}', patientId);

      expect(result, equals('/behandlungen?selectedPatient='));
    });
  });
}
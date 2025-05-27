import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/behandlung.freezed.dart';
part 'generated/behandlung.g.dart';

@freezed
abstract class Behandlung with _$Behandlung {
  const factory Behandlung({
    required String id,
    required String patientId,
    required DateTime startZeit,
    required DateTime endZeit,
    String? rezeptId,
  }) = _Behandlung;

  factory Behandlung.fromJson(Map<String, dynamic> json) => _$BehandlungFromJson(json);
}

@freezed
abstract class BehandlungKalender with _$BehandlungKalender {
  const factory BehandlungKalender({
    required String id,
    required DateTime startZeit,
    required DateTime endZeit,
    required PatientSummary patient,
    String? rezeptId,
  }) = _BehandlungKalender;

  factory BehandlungKalender.fromJson(Map<String, dynamic> json) =>
      _$BehandlungKalenderFromJson(json);
}

@freezed
abstract class PatientSummary with _$PatientSummary {
  const factory PatientSummary({
    required String id,
    required String name,
    DateTime? birthday,
  }) = _PatientSummary;

  factory PatientSummary.fromJson(Map<String, dynamic> json) => _$PatientSummaryFromJson(json);
}

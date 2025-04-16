import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/rezept.dart';

part 'generated/rezept_einlesen_response.freezed.dart';
part 'generated/rezept_einlesen_response.g.dart';

@freezed
abstract class RezeptEinlesenResponse with _$RezeptEinlesenResponse {
  const factory RezeptEinlesenResponse({
    Patient? existingPatient,
    required EingelesenerPatient patient,
    required EingelesenesRezept rezept,
    required String path,
  }) = _RezeptEinlesenResponse;

  const RezeptEinlesenResponse._();

  factory RezeptEinlesenResponse.fromJson(Map<String, dynamic> json) => 
      _$RezeptEinlesenResponseFromJson(json);
}

@freezed
abstract class EingelesenerPatient with _$EingelesenerPatient {
  const factory EingelesenerPatient({
    String? titel,
    required String vorname,
    required String nachname,
    required String strasse,
    required String hausnummer,
    required String postleitzahl,
    required String stadt,
    required DateTime geburtstag,
  }) = _EingelesenerPatient;

  const EingelesenerPatient._();

  factory EingelesenerPatient.fromJson(Map<String, dynamic> json) => 
      _$EingelesenerPatientFromJson(json);
}

@freezed
abstract class EingelesenesRezept with _$EingelesenesRezept {
  const factory EingelesenesRezept({
    required DateTime ausgestelltAm,
    required List<EingelesenesRezeptPos> rezeptpositionen,
  }) = _EingelesenesRezept;

  const EingelesenesRezept._();

  factory EingelesenesRezept.fromJson(Map<String, dynamic> json) => 
      _$EingelesenesRezeptFromJson(json);
}

@freezed
abstract class EingelesenesRezeptPos with _$EingelesenesRezeptPos {
  const factory EingelesenesRezeptPos({
    required int anzahl,
    required Behandlungsart behandlungsart,
  }) = _EingelesenesRezeptPos;

  const EingelesenesRezeptPos._();

  factory EingelesenesRezeptPos.fromJson(Map<String, dynamic> json) => 
      _$EingelesenesRezeptPosFromJson(json);
}
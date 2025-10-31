import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/patient.freezed.dart';
part 'generated/patient.g.dart';

@freezed
abstract class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String vorname,
    required String nachname,
    required DateTime geburtstag,
    String? titel,
    String? strasse,
    String? hausnummer,
    String? plz,
    String? stadt,
    String? telMobil,
    String? telFestnetz,
    String? email,
  }) = _Patient;

  const Patient._();

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);

  String get fullName => [
    if (titel?.isNotEmpty ?? false) titel,
    vorname,
    nachname,
  ].join(' ');

  String get address => [
    [
      if (strasse?.isNotEmpty ?? false) strasse,
      if (hausnummer?.isNotEmpty ?? false) hausnummer,
    ].join(' '),
    [
      if (plz?.isNotEmpty ?? false) plz,
      if (stadt?.isNotEmpty ?? false) stadt,
    ].join(' '),
  ].join('\n');
}

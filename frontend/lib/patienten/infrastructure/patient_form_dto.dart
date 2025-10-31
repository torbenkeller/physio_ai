import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/patient_form_dto.freezed.dart';
part 'generated/patient_form_dto.g.dart';

@freezed
abstract class PatientFormDto with _$PatientFormDto {
  const factory PatientFormDto({
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
  }) = _PatientFormDto;

  const PatientFormDto._();

  factory PatientFormDto.fromJson(Map<String, dynamic> json) => _$PatientFormDtoFromJson(json);
}

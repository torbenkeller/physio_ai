// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../rezept_einlesen_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RezeptEinlesenResponse _$RezeptEinlesenResponseFromJson(
  Map<String, dynamic> json,
) => _RezeptEinlesenResponse(
  patient: EingelesenerPatient.fromJson(
    json['patient'] as Map<String, dynamic>,
  ),
  rezept: EingelesenesRezept.fromJson(json['rezept'] as Map<String, dynamic>),
  existingPatient: json['existingPatient'] == null
      ? null
      : Patient.fromJson(json['existingPatient'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RezeptEinlesenResponseToJson(
  _RezeptEinlesenResponse instance,
) => <String, dynamic>{
  'patient': instance.patient,
  'rezept': instance.rezept,
  'existingPatient': instance.existingPatient,
};

_EingelesenerPatient _$EingelesenerPatientFromJson(Map<String, dynamic> json) =>
    _EingelesenerPatient(
      vorname: json['vorname'] as String,
      nachname: json['nachname'] as String,
      strasse: json['strasse'] as String,
      hausnummer: json['hausnummer'] as String,
      postleitzahl: json['postleitzahl'] as String,
      stadt: json['stadt'] as String,
      geburtstag: DateTime.parse(json['geburtstag'] as String),
      titel: json['titel'] as String?,
    );

Map<String, dynamic> _$EingelesenerPatientToJson(
  _EingelesenerPatient instance,
) => <String, dynamic>{
  'vorname': instance.vorname,
  'nachname': instance.nachname,
  'strasse': instance.strasse,
  'hausnummer': instance.hausnummer,
  'postleitzahl': instance.postleitzahl,
  'stadt': instance.stadt,
  'geburtstag': instance.geburtstag.toIso8601String(),
  'titel': instance.titel,
};

_EingelesenesRezept _$EingelesenesRezeptFromJson(Map<String, dynamic> json) => _EingelesenesRezept(
  ausgestelltAm: DateTime.parse(json['ausgestelltAm'] as String),
  rezeptpositionen: (json['rezeptpositionen'] as List<dynamic>)
      .map((e) => EingelesenesRezeptPos.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EingelesenesRezeptToJson(_EingelesenesRezept instance) => <String, dynamic>{
  'ausgestelltAm': instance.ausgestelltAm.toIso8601String(),
  'rezeptpositionen': instance.rezeptpositionen,
};

_EingelesenesRezeptPos _$EingelesenesRezeptPosFromJson(
  Map<String, dynamic> json,
) => _EingelesenesRezeptPos(
  anzahl: (json['anzahl'] as num).toInt(),
  behandlungsart: Behandlungsart.fromJson(
    json['behandlungsart'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$EingelesenesRezeptPosToJson(
  _EingelesenesRezeptPos instance,
) => <String, dynamic>{
  'anzahl': instance.anzahl,
  'behandlungsart': instance.behandlungsart,
};

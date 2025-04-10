// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../patient_form_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientFormDtoImpl _$$PatientFormDtoImplFromJson(Map<String, dynamic> json) =>
    _$PatientFormDtoImpl(
      vorname: json['vorname'] as String,
      nachname: json['nachname'] as String,
      geburtstag: DateTime.parse(json['geburtstag'] as String),
      titel: json['titel'] as String?,
      strasse: json['strasse'] as String?,
      hausnummer: json['hausnummer'] as String?,
      plz: json['plz'] as String?,
      stadt: json['stadt'] as String?,
      telMobil: json['telMobil'] as String?,
      telFestnetz: json['telFestnetz'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$PatientFormDtoImplToJson(
        _$PatientFormDtoImpl instance) =>
    <String, dynamic>{
      'vorname': instance.vorname,
      'nachname': instance.nachname,
      'geburtstag': instance.geburtstag.toIso8601String(),
      'titel': instance.titel,
      'strasse': instance.strasse,
      'hausnummer': instance.hausnummer,
      'plz': instance.plz,
      'stadt': instance.stadt,
      'telMobil': instance.telMobil,
      'telFestnetz': instance.telFestnetz,
      'email': instance.email,
    };

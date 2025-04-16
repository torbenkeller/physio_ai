// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Patient _$PatientFromJson(Map<String, dynamic> json) => _Patient(
      id: json['id'] as String,
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

Map<String, dynamic> _$PatientToJson(_Patient instance) => <String, dynamic>{
      'id': instance.id,
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

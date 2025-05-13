// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../rezept.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Rezept _$RezeptFromJson(Map<String, dynamic> json) => _Rezept(
      id: json['id'] as String,
      patient: RezeptPatient.fromJson(json['patient'] as Map<String, dynamic>),
      ausgestelltAm: DateTime.parse(json['ausgestelltAm'] as String),
      preisGesamt: (json['preisGesamt'] as num).toDouble(),
      positionen: json['positionen'] == null
          ? const IListConst([])
          : IList<RezeptPos>.fromJson(json['positionen'],
              (value) => RezeptPos.fromJson(value as Map<String, dynamic>)),
    );

Map<String, dynamic> _$RezeptToJson(_Rezept instance) => <String, dynamic>{
      'id': instance.id,
      'patient': instance.patient,
      'ausgestelltAm': instance.ausgestelltAm.toIso8601String(),
      'preisGesamt': instance.preisGesamt,
      'positionen': instance.positionen.toJson(
        (value) => value,
      ),
    };

_RezeptPos _$RezeptPosFromJson(Map<String, dynamic> json) => _RezeptPos(
      anzahl: (json['anzahl'] as num).toInt(),
      behandlungsart: Behandlungsart.fromJson(
          json['behandlungsart'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RezeptPosToJson(_RezeptPos instance) =>
    <String, dynamic>{
      'anzahl': instance.anzahl,
      'behandlungsart': instance.behandlungsart,
    };

_Behandlungsart _$BehandlungsartFromJson(Map<String, dynamic> json) =>
    _Behandlungsart(
      id: json['id'] as String,
      name: json['name'] as String,
      preis: (json['preis'] as num).toDouble(),
    );

Map<String, dynamic> _$BehandlungsartToJson(_Behandlungsart instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'preis': instance.preis,
    };

_RezeptPatient _$RezeptPatientFromJson(Map<String, dynamic> json) =>
    _RezeptPatient(
      id: json['id'] as String,
      vorname: json['vorname'] as String,
      nachname: json['nachname'] as String,
    );

Map<String, dynamic> _$RezeptPatientToJson(_RezeptPatient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vorname': instance.vorname,
      'nachname': instance.nachname,
    };

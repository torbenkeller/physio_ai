// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../behandlung.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Behandlung _$BehandlungFromJson(Map<String, dynamic> json) => _Behandlung(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      startZeit: DateTime.parse(json['startZeit'] as String),
      endZeit: DateTime.parse(json['endZeit'] as String),
      rezeptId: json['rezeptId'] as String?,
    );

Map<String, dynamic> _$BehandlungToJson(_Behandlung instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'startZeit': instance.startZeit.toIso8601String(),
      'endZeit': instance.endZeit.toIso8601String(),
      'rezeptId': instance.rezeptId,
    };

_BehandlungKalender _$BehandlungKalenderFromJson(Map<String, dynamic> json) =>
    _BehandlungKalender(
      id: json['id'] as String,
      startZeit: DateTime.parse(json['startZeit'] as String),
      endZeit: DateTime.parse(json['endZeit'] as String),
      patient: PatientSummary.fromJson(json['patient'] as Map<String, dynamic>),
      rezeptId: json['rezeptId'] as String?,
    );

Map<String, dynamic> _$BehandlungKalenderToJson(_BehandlungKalender instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startZeit': instance.startZeit.toIso8601String(),
      'endZeit': instance.endZeit.toIso8601String(),
      'patient': instance.patient,
      'rezeptId': instance.rezeptId,
    };

_PatientSummary _$PatientSummaryFromJson(Map<String, dynamic> json) =>
    _PatientSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
    );

Map<String, dynamic> _$PatientSummaryToJson(_PatientSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthday': instance.birthday?.toIso8601String(),
    };

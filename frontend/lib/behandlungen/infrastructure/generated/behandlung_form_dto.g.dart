// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../behandlung_form_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BehandlungFormDto _$BehandlungFormDtoFromJson(Map<String, dynamic> json) => _BehandlungFormDto(
  patientId: json['patientId'] as String,
  startZeit: DateTime.parse(json['startZeit'] as String),
  endZeit: DateTime.parse(json['endZeit'] as String),
  rezeptId: json['rezeptId'] as String?,
);

Map<String, dynamic> _$BehandlungFormDtoToJson(_BehandlungFormDto instance) => <String, dynamic>{
  'patientId': instance.patientId,
  'startZeit': instance.startZeit.toIso8601String(),
  'endZeit': instance.endZeit.toIso8601String(),
  'rezeptId': instance.rezeptId,
};

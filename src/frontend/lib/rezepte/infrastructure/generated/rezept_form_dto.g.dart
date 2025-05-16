// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../rezept_form_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RezeptFormDto _$RezeptFormDtoFromJson(Map<String, dynamic> json) =>
    _RezeptFormDto(
      patientId: json['patientId'] as String,
      ausgestelltAm: DateTime.parse(json['ausgestelltAm'] as String),
      positionen: (json['positionen'] as List<dynamic>)
          .map((e) => RezeptPositionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RezeptFormDtoToJson(_RezeptFormDto instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'ausgestelltAm': instance.ausgestelltAm.toIso8601String(),
      'positionen': instance.positionen,
    };

_RezeptPositionDto _$RezeptPositionDtoFromJson(Map<String, dynamic> json) =>
    _RezeptPositionDto(
      behandlungsartId: json['behandlungsartId'] as String,
      anzahl: (json['anzahl'] as num).toInt(),
    );

Map<String, dynamic> _$RezeptPositionDtoToJson(_RezeptPositionDto instance) =>
    <String, dynamic>{
      'behandlungsartId': instance.behandlungsartId,
      'anzahl': instance.anzahl,
    };

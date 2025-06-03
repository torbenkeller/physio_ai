// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../behandlung_verschiebe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BehandlungVerschiebeDto _$BehandlungVerschiebeDtoFromJson(
        Map<String, dynamic> json) =>
    _BehandlungVerschiebeDto(
      nach: DateTime.parse(json['nach'] as String),
    );

Map<String, dynamic> _$BehandlungVerschiebeDtoToJson(
        _BehandlungVerschiebeDto instance) =>
    <String, dynamic>{
      'nach': instance.nach.toIso8601String(),
    };

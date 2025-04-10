// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../rezept.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RezeptImpl _$$RezeptImplFromJson(Map<String, dynamic> json) => _$RezeptImpl(
      id: json['id'] as String,
      ausgestelltAm: DateTime.parse(json['ausgestelltAm'] as String),
      preisGesamt: (json['preisGesamt'] as num).toDouble(),
      positionen: json['positionen'] == null
          ? const IListConst([])
          : IList<RezeptPos>.fromJson(json['positionen'],
              (value) => RezeptPos.fromJson(value as Map<String, dynamic>)),
    );

Map<String, dynamic> _$$RezeptImplToJson(_$RezeptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ausgestelltAm': instance.ausgestelltAm.toIso8601String(),
      'preisGesamt': instance.preisGesamt,
      'positionen': instance.positionen.toJson(
        (value) => value,
      ),
    };

_$RezeptPosImpl _$$RezeptPosImplFromJson(Map<String, dynamic> json) =>
    _$RezeptPosImpl(
      anzahl: (json['anzahl'] as num).toInt(),
      behandlungsart: Behandlungsart.fromJson(
          json['behandlungsart'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RezeptPosImplToJson(_$RezeptPosImpl instance) =>
    <String, dynamic>{
      'anzahl': instance.anzahl,
      'behandlungsart': instance.behandlungsart,
    };

_$BehandlungsartImpl _$$BehandlungsartImplFromJson(Map<String, dynamic> json) =>
    _$BehandlungsartImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      preis: (json['preis'] as num).toDouble(),
    );

Map<String, dynamic> _$$BehandlungsartImplToJson(
        _$BehandlungsartImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'preis': instance.preis,
    };

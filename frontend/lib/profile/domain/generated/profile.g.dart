// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  praxisName: json['praxisName'] as String,
  inhaberName: json['inhaberName'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  calenderUrl: json['calenderUrl'] as String?,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'praxisName': instance.praxisName,
  'inhaberName': instance.inhaberName,
  'profilePictureUrl': instance.profilePictureUrl,
  'calenderUrl': instance.calenderUrl,
};

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/rezept_form_dto.freezed.dart';
part 'generated/rezept_form_dto.g.dart';

@freezed
abstract class RezeptFormDto with _$RezeptFormDto {
  const factory RezeptFormDto({
    required String patientId,
    required DateTime ausgestelltAm,
    required List<RezeptPositionDto> positionen,
  }) = _RezeptFormDto;

  const RezeptFormDto._();

  factory RezeptFormDto.fromJson(Map<String, dynamic> json) => _$RezeptFormDtoFromJson(json);
}

@freezed
abstract class RezeptPositionDto with _$RezeptPositionDto {
  const factory RezeptPositionDto({
    required String behandlungsartId,
    required int anzahl,
  }) = _RezeptPositionDto;

  const RezeptPositionDto._();

  factory RezeptPositionDto.fromJson(Map<String, dynamic> json) =>
      _$RezeptPositionDtoFromJson(json);
}

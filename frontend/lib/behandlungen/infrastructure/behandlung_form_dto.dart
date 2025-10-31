import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/behandlung_form_dto.freezed.dart';
part 'generated/behandlung_form_dto.g.dart';

@freezed
abstract class BehandlungFormDto with _$BehandlungFormDto {
  const factory BehandlungFormDto({
    required String patientId,
    required DateTime startZeit,
    required DateTime endZeit,
    String? rezeptId,
  }) = _BehandlungFormDto;

  factory BehandlungFormDto.fromJson(Map<String, dynamic> json) =>
      _$BehandlungFormDtoFromJson(json);
}

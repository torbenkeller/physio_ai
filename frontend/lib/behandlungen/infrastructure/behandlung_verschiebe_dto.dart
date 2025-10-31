import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/behandlung_verschiebe_dto.freezed.dart';
part 'generated/behandlung_verschiebe_dto.g.dart';

@freezed
abstract class BehandlungVerschiebeDto with _$BehandlungVerschiebeDto {
  const factory BehandlungVerschiebeDto({
    required DateTime nach,
  }) = _BehandlungVerschiebeDto;

  const BehandlungVerschiebeDto._();

  factory BehandlungVerschiebeDto.fromJson(Map<String, dynamic> json) =>
      _$BehandlungVerschiebeDtoFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'generated/rezept.freezed.dart';

part 'generated/rezept.g.dart';

@freezed
abstract class Rezept with _$Rezept {
  const factory Rezept({
    required String id,
    @JsonKey(includeIfNull: false) String? patientId,
    required DateTime ausgestelltAm,
    required double preisGesamt,
    @Default(IListConst([])) IList<RezeptPos> positionen,
  }) = _Rezept;

  const Rezept._();

  factory Rezept.fromJson(Map<String, dynamic> json) => _$RezeptFromJson(json);
}

@freezed
abstract class RezeptPos with _$RezeptPos {
  const factory RezeptPos({
    required int anzahl,
    required Behandlungsart behandlungsart,
  }) = _RezeptPos;

  const RezeptPos._();

  factory RezeptPos.fromJson(Map<String, dynamic> json) => _$RezeptPosFromJson(json);
}

@freezed
abstract class Behandlungsart with _$Behandlungsart {
  const factory Behandlungsart({
    required String id,
    required String name,
    required double preis,
  }) = _Behandlungsart;

  const Behandlungsart._();

  factory Behandlungsart.fromJson(Map<String, dynamic> json) => _$BehandlungsartFromJson(json);
}

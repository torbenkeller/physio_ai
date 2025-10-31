import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/profile.freezed.dart';
part 'generated/profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String praxisName,
    required String inhaberName,
    String? profilePictureUrl,
    String? calenderUrl,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}

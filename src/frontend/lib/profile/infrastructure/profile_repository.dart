import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../domain/profile.dart';

part 'generated/profile_repository.g.dart';

@RestApi()
abstract class ProfileRepository {
  factory ProfileRepository(Dio dio) = _ProfileRepository;

  @GET('/profile')
  Future<Profile> getProfile();
}

final profileRepositoryProvider = Provider((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
  return ProfileRepository(dio);
});

final profileProvider = FutureProvider<Profile>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile();
});
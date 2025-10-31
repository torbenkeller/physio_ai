import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/main.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/infrastructure/patient_form_dto.dart';
import 'package:physio_ai/shared_kernel/infrastructure/error_logger.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'generated/patient_repository.g.dart';

final patientRepositoryProvider = Provider<PatientRepository>(
  (ref) => PatientRepository(
    ref.watch(dioProvider),
    errorLogger: ref.watch(retrofitErrorLoggerProvider),
  ),
);

@RestApi(baseUrl: '/patienten')
abstract class PatientRepository {
  factory PatientRepository(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger errorLogger,
  }) = _PatientRepository;

  @GET('')
  Future<List<Patient>> getPatienten();

  @DELETE('/{id}')
  Future<void> deletePatient(@Path('id') String id);

  @POST('')
  Future<Patient> createPatient(@Body() PatientFormDto patient);

  @PATCH('/{id}')
  Future<Patient> updatePatient(@Path('id') String id, @Body() PatientFormDto formDto);
}

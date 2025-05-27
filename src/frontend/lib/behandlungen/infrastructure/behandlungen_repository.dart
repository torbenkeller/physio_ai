import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlung_form_dto.dart';
import 'package:physio_ai/main.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/behandlungen_repository.g.dart';

final behandlungenRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return BehandlungenRepository(dio);
});

@RestApi()
abstract class BehandlungenRepository {
  factory BehandlungenRepository(Dio dio) = _BehandlungenRepository;

  @POST('/behandlungen')
  Future<Behandlung> createBehandlung(@Body() BehandlungFormDto formDto);

  @GET('/behandlungen/{id}')
  Future<Behandlung> getBehandlung(@Path('id') String id);

  @GET('/behandlungen')
  Future<List<Behandlung>> getAllBehandlungen();

  @GET('/behandlungen/patient/{patientId}')
  Future<List<Behandlung>> getBehandlungenByPatient(@Path('patientId') String patientId);

  @PUT('/behandlungen/{id}')
  Future<Behandlung> updateBehandlung(
    @Path('id') String id,
    @Body() BehandlungFormDto formDto,
  );

  @DELETE('/behandlungen/{id}')
  Future<void> deleteBehandlung(@Path('id') String id);

  @GET('/behandlungen/calender/week')
  Future<Map<String, List<BehandlungKalender>>> getWeeklyCalendar(@Query('date') String date);
}

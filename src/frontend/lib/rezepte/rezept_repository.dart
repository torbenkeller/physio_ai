import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:physio_ai/main.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_form_dto.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/rezept.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'generated/rezept_repository.g.dart';

final errorLoggerProvider = Provider<ParseErrorLogger>(
  (ref) => ErrorLogger(Logger()),
);

class ErrorLogger implements ParseErrorLogger {

  const ErrorLogger(this.logger);
  final Logger logger;

  @override
  void logError(Object error, StackTrace stackTrace, RequestOptions options) {
    logger.e('Parsing Error', error: error, stackTrace: stackTrace);
  }
}

final rezeptRepositoryProvider = Provider<RezeptRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return RezeptRepository(dio);
  },
);

final behandlungsartenProvider = FutureProvider<IList<Behandlungsart>>((ref) async {
  final repository = ref.watch(rezeptRepositoryProvider);
  final behandlungsarten = await repository.getBehandlungsarten();
  return behandlungsarten.lock;
});

@RestApi(baseUrl: '/rezepte')
abstract class RezeptRepository {
  factory RezeptRepository(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger errorLogger,
  }) = _RezeptRepository;

  @GET('')
  Future<List<Rezept>> getRezepte();

  @POST('')
  Future<Rezept> createRezept(@Body() RezeptFormDto rezeptCreate);

  @PATCH('/{id}')
  Future<Rezept> updateRezept(@Path('id') String id, @Body() RezeptFormDto rezeptUpdate);

  @DELETE('/{id}')
  Future<void> deleteRezept(@Path('id') String id);

  @POST('/createFromImage')
  @MultiPart()
  Future<RezeptEinlesenResponse> uploadRezeptImage(@Part() List<MultipartFile> file);

  @GET('/behandlungsarten')
  Future<List<Behandlungsart>> getBehandlungsarten();
}

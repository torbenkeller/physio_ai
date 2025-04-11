import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:physio_ai/main.dart';
import 'package:physio_ai/rezepte/rezept.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'generated/rezept_repository.g.dart';

final errorLoggerProvider = Provider<ParseErrorLogger>(
  (ref) => ErrorLogger(Logger()),
);

class ErrorLogger implements ParseErrorLogger {
  final Logger logger;

  const ErrorLogger(this.logger);

  @override
  void logError(Object error, StackTrace stackTrace, RequestOptions options) {
    logger.e('Parsing Error', error: error, stackTrace: stackTrace);
  }
}

final rezeptRepositoryProvider = Provider<RezeptRepository>(
  (ref) => RezeptRepository(
    ref.watch(dioProvider),
    errorLogger: ref.watch(errorLoggerProvider),
  ),
);

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
  Future<Rezept> createRezept(@Body() Rezept rezept);

  @DELETE('{id}')
  Future<void> deleteRezept(@Path('id') String id);
}

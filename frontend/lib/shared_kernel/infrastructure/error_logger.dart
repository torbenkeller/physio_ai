import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/error_logger.dart';

final retrofitErrorLoggerProvider = Provider<ParseErrorLogger>(
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

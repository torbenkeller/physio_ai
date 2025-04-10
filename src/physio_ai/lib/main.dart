import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/physio_ai.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dioProvider = Provider<Dio>((ref) {
  const baseUrl = 'http://localhost:8080';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    PrettyDioLogger(
      compact: false,
      requestHeader: true,
      error: true,
      enabled: true,
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
    ),
    RetryInterceptor(dio: dio),
  ]);

  return dio;
});

void main() {
  runApp(const ProviderScope(child: PhysioAi()));
}

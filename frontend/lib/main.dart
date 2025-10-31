import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
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
      requestBody: true,
      responseHeader: true,
    ),
    RetryInterceptor(dio: dio),
  ]);

  return dio;
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Portal(child: PhysioAi())));
}

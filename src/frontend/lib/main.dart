import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcp_toolkit/mcp_toolkit.dart';
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
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      MCPToolkitBinding.instance
        ..initialize() // Initializes the Toolkit
        ..initializeFlutterToolkit(); // Adds Flutter related methods to the MCP server
      runApp(const ProviderScope(child: PhysioAi()));
    },
    MCPToolkitBinding.instance.handleZoneError,
  );
}

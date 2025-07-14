import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/generated/l10n.dart';
import 'package:physio_ai/home_scaffold.dart';
import 'package:physio_ai/router.dart';

class PhysioAi extends ConsumerStatefulWidget {
  const PhysioAi({super.key});

  @override
  ConsumerState<PhysioAi> createState() => _PhysioAiState();
}

class _PhysioAiState extends ConsumerState<PhysioAi> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final breakpoint = Breakpoint.fromWidth(MediaQuery.sizeOf(context).width);
      updateRouterConfig(breakpoint);
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final breakpoint = Breakpoint.fromWidth(MediaQuery.sizeOf(context).width);
    updateRouterConfig(breakpoint);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Physio AI',
      localizationsDelegates: const [
        PhysioAiLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

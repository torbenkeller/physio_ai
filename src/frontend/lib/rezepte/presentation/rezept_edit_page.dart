import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/home_scaffold.dart';
import 'package:physio_ai/rezepte/presentation/rezept_detail_page.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form.dart';

class RezeptEditPage extends ConsumerWidget {
  const RezeptEditPage({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final breakpoint = Breakpoint.fromWidth(width);

    final asyncRezept = ref.watch(rezeptProvider(id));

    return Scaffold(
      appBar: AppBar(
        leading: breakpoint.isDesktop() ? const CloseButton() : const BackButton(),
        title: const Text('Rezept bearbeiten'),
      ),
      body: asyncRezept.when(
        data: (rezept) {
          if (rezept == null) {
            return const Center(
              child: Text('Rezept nicht gefunden'),
            );
          }
          return RezeptForm(rezept: rezept);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, __) {
          // Error handling for loading rezept
          return const Center(
            child: Text('Error'),
          );
        },
      ),
    );
  }
}

class RezeptEditContent extends StatelessWidget {
  const RezeptEditContent({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return RezeptEditPage(id: id);
  }
}

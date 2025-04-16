import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/rezepte/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form.dart';
import 'package:physio_ai/rezepte/rezepte_page.dart';

final rezeptProvider = FutureProvider.family<Rezept?, String>((ref, id) async {
  final rezepte = await ref.watch(rezepteProvider.future);
  return rezepte.where((r) => r.id == id).firstOrNull;
});

class RezeptDetailPage extends ConsumerWidget {
  const RezeptDetailPage({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRezept = ref.watch(rezeptProvider(id));

    return asyncRezept.when(
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
        print(error);
        return const Center(
          child: Text('Error'),
        );
      },
    );
  }
}

class RezeptDetailContent extends StatelessWidget {
  const RezeptDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
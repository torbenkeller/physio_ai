import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/rezepte/rezept.dart';
import 'package:physio_ai/rezepte/rezept_repository.dart';

final rezepteProvider = FutureProvider((ref) async {
  final repo = ref.watch(rezeptRepositoryProvider);
  return (await repo.getRezepte()).lock;
});

class SplittedRezeptePage extends StatelessWidget {
  const SplittedRezeptePage({
    required this.isContextCreate,
    required this.rightPane,
    super.key,
  });

  final bool isContextCreate;

  final Widget rightPane;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RezeptePage(
            showAddButton: !isContextCreate,
          ),
        ),
        Expanded(child: rightPane),
      ],
    );
  }
}

class RezeptePage extends ConsumerWidget {
  const RezeptePage({
    super.key,
    this.showAddButton = true,
  });

  final bool showAddButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRezepte = ref.watch(rezepteProvider);
    final content = asyncRezepte.when(
      data: (patienten) => ListView.builder(
        itemCount: patienten.length,
        itemBuilder: (context, index) {
          final rezept = patienten[index];
          return RezeptListTile(rezept: rezept);
        },
      ),
      error: (error, __) {
        print(error);
        return const Center(
          child: Text('Error'),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final page = Scaffold(
      floatingActionButton: showAddButton
          ? FloatingActionButton.extended(
              heroTag: 'createPatient',
              key: const Key('createRezept'),
              icon: const Icon(Icons.add),
              label: const Text('Anlegen'),
              tooltip: 'Anlegen',
              onPressed: () {
                context.go('/rezepte/create');
              },
            )
          : null,
      body: content,
    );
    return page;
  }
}

class RezeptListTile extends StatelessWidget {
  const RezeptListTile({
    required this.rezept,
    super.key,
  });

  final Rezept rezept;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(rezept.id),
    );
  }
}

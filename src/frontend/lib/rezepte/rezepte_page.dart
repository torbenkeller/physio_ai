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
    // Using AnimatedSwitcher with zero duration prevents unwanted animations
    return Row(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration.zero,
            child: RezeptePage(
              key: const ValueKey('rezeptePage'),
              showAddButton: !isContextCreate,
            ),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration.zero,
            child: rightPane,
          ),
        ),
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
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: showAddButton
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  key: const Key('uploadRezept'),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Von Bild'),
                  tooltip: 'Rezept von Bild erstellen',
                  onPressed: () {
                    context.go('/rezepte/upload');
                  },
                ),
                const SizedBox(height: 16),
                FloatingActionButton.extended(
                  key: const Key('createRezept'),
                  icon: const Icon(Icons.add),
                  label: const Text('Manuell anlegen'),
                  tooltip: 'Manuell anlegen',
                  onPressed: () {
                    context.go('/rezepte/create');
                  },
                ),
              ],
            )
          : null,
      body: content,
    );
    return page;
  }
}

class RezeptListTile extends ConsumerWidget {
  const RezeptListTile({
    required this.rezept,
    super.key,
  });

  final Rezept rezept;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat =
        DateTime.now().difference(rezept.ausgestelltAm).inDays < 365 ? 'dd.MM.' : 'dd.MM.yyyy';
    final formattedDate =
        '${rezept.ausgestelltAm.day}.${rezept.ausgestelltAm.month}.${rezept.ausgestelltAm.year}';

    return ListTile(
      onTap: () {
        context.go('/rezepte/${rezept.id}');
      },
      title: Text('Rezept vom $formattedDate'),
      subtitle: Text(
          '${rezept.positionen.length} Positionen, ${rezept.preisGesamt.toStringAsFixed(2)} €'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await ref.read(rezeptRepositoryProvider).deleteRezept(rezept.id);
          ref.refresh(rezepteProvider);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
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
    final theme = Theme.of(context);

    return asyncRezept.when(
      data: (rezept) {
        if (rezept == null) {
          return const Center(
            child: Text('Rezept nicht gefunden'),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Rezept Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.go('/rezepte/$id/edit');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: 'Patient',
                  child: Text(
                    '${rezept.patient.vorname} ${rezept.patient.nachname}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Ausgestellt am',
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(rezept.ausgestelltAm),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),
                _buildBehandlungenSection(rezept, theme),
                const SizedBox(height: 24),
                _buildSessionsSection(rezept, theme),
                const SizedBox(height: 32),
                Align(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/rezepte/$id/edit');
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Bearbeiten'),
                  ),
                ),
              ],
            ),
          ),
        );
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
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildBehandlungenSection(Rezept rezept, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    return _buildSection(
      title: 'Behandlungen',
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withAlpha(51),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(4),
                2: FixedColumnWidth(100),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Anzahl',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Behandlungsart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Preis',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                for (final position in rezept.positionen)
                  _buildPositionRow(position, theme),
                _buildTableFooterRow(rezept, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildPositionRow(RezeptPos position, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withAlpha(25),
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            '${position.anzahl}',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(position.behandlungsart.name),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            NumberFormat.currency(
              decimalDigits: 2,
              symbol: '€',
            ).format(position.anzahl * position.behandlungsart.preis),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  TableRow _buildTableFooterRow(Rezept rezept, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    return TableRow(
      children: [
        const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            'Gesamtsumme:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            NumberFormat.currency(
              decimalDigits: 2,
              symbol: '€',
            ).format(rezept.preisGesamt),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsSection(Rezept rezept, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    if (rezept.behandlungen.isEmpty) {
      return _buildSection(
        title: 'Behandlungstermine',
        child: Text(
          'Noch keine Behandlungstermine eingetragen',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }
    
    return _buildSection(
      title: 'Behandlungstermine',
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer.withAlpha(51),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Beginn',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Ende',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Dauer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                for (final behandlung in rezept.behandlungen)
                  _buildBehandlungRow(behandlung, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildBehandlungRow(Behandlung behandlung, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final duration = behandlung.endZeit.difference(behandlung.startZeit);
    final durationMinutes = duration.inMinutes;
    
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withAlpha(25),
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(dateFormat.format(behandlung.startZeit)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(dateFormat.format(behandlung.endZeit)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            '$durationMinutes min',
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class RezeptDetailContent extends StatelessWidget {
  const RezeptDetailContent({
    required this.id, 
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return RezeptDetailPage(id: id);
  }
}

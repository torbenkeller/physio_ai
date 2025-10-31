import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezepte_page.dart';

final patientProvider = FutureProvider.family<Patient?, String>((ref, id) async {
  final patienten = await ref.watch(patientenProvider.future);
  return patienten.where((p) => p.id == id).firstOrNull;
});

class PatientDetailPage extends ConsumerWidget {
  const PatientDetailPage({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPatient = ref.watch(patientProvider(id));

    return asyncPatient.when(
      data: (patient) {
        if (patient == null) {
          return const Center(
            child: Text('Patient nicht gefunden'),
          );
        }
        return PatientDetailContent(patient: patient);
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

class PatientDetailContent extends ConsumerWidget {
  const PatientDetailContent({
    required this.patient,
    super.key,
  });

  final Patient patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRezepte = ref.watch(rezepteOfPatientProvider(patient.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.fullName),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/patienten/${patient.id}/edit');
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Patient bearbeiten',
          ),
        ],
      ),
      body: Column(
        children: [
          _PatientInfoCard(patient: patient),
          const SizedBox(height: 24),
          Expanded(
            child: _RezepteSection(
              patient: patient,
              asyncRezepte: asyncRezepte,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying patient information
class _PatientInfoCard extends StatelessWidget {
  const _PatientInfoCard({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patientendaten',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Name',
              patient.fullName,
              theme,
            ),
            _buildInfoRow(
              'Geburtsdatum',
              '${patient.geburtstag.day}.${patient.geburtstag.month}.${patient.geburtstag.year}',
              theme,
            ),
            if (patient.address.isNotEmpty) _buildInfoRow('Adresse', patient.address, theme),
            if (patient.telMobil?.isNotEmpty == true)
              _buildInfoRow('Mobil', patient.telMobil!, theme),
            if (patient.telFestnetz?.isNotEmpty == true)
              _buildInfoRow('Festnetz', patient.telFestnetz!, theme),
            if (patient.email?.isNotEmpty == true) _buildInfoRow('E-Mail', patient.email!, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section displaying patient's Rezepte
class _RezepteSection extends ConsumerWidget {
  const _RezepteSection({
    required this.patient,
    required this.asyncRezepte,
  });

  final Patient patient;
  final AsyncValue<IList<Rezept>> asyncRezepte;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rezepte',
              style: theme.textTheme.headlineSmall,
            ),
            FilledButton.icon(
              onPressed: () {
                context.go('/patienten/${patient.id}/rezepte/create');
              },
              icon: const Icon(Icons.add),
              label: const Text('Rezept anlegen'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        asyncRezepte.when(
          data: (rezepte) => _buildRezepteList(rezepte, theme),
          loading: () => const SizedBox(
            height: 200,
            child: Card(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (error, _) => SizedBox(
            height: 200,
            child: Card(
              child: Center(
                child: Text(
                  'Fehler beim Laden der Rezepte: $error',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRezepteList(IList<Rezept> rezepte, ThemeData theme) {
    if (rezepte.isEmpty) {
      return SizedBox(
        height: 200,
        child: Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  color: theme.colorScheme.outline,
                ),
                Text(
                  'Keine Rezepte vorhanden',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final listHeights = rezepte
              .map((r) {
                if (r.positionen.length == 1) {
                  return 64;
                }

                return 40 + r.positionen.length * 20;
              })
              .sumBy((i) => i);

          final dividerheights = rezepte.length - 1;
          const verticalPadding = 8.0;

          final listItemHeight = min(
            constraints.maxHeight - 8,
            listHeights + dividerheights + verticalPadding * 2,
          );

          return Column(
            children: [
              Card(
                child: SizedBox(
                  height: listItemHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: verticalPadding),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemCount: rezepte.length,
                      physics: listItemHeight != constraints.maxHeight - 8
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      itemBuilder: (context, index) {
                        final rezept = rezepte[index];
                        return _RezeptCard(rezept: rezept);
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RezeptCard extends StatelessWidget {
  const _RezeptCard({required this.rezept});

  final Rezept rezept;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text('Rezept vom ${DateFormat('dd.MM.yyyy').format(rezept.ausgestelltAm)}'),
    subtitle: Text(
      rezept.positionen.map((p) => '${p.anzahl}x ${p.behandlungsart.name}').join('\n'),
    ),
    onTap: () {
      context.go('/patienten/${rezept.patient.id}/rezepte/${rezept.id}');
    },
  );
}

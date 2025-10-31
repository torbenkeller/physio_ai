import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/infrastructure/patient_repository.dart';

final patientenProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(patientRepositoryProvider);
  return (await repo.getPatienten()).lock;
});

class SplittedPatientenPage extends StatelessWidget {
  const SplittedPatientenPage({
    required this.rightPane,
    required this.isContextCreate,
    this.selectedPatientId,
    super.key,
  });

  final Widget rightPane;
  final bool isContextCreate;

  final String? selectedPatientId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PatientenPage(
            selectedPatientId: selectedPatientId,
            showAddButton: !isContextCreate,
          ),
        ),
        Expanded(child: rightPane),
      ],
    );
  }
}

class PatientenPage extends ConsumerWidget {
  const PatientenPage({
    this.showAddButton = true,
    this.selectedPatientId,
    super.key,
  });

  final bool showAddButton;

  final String? selectedPatientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPatienten = ref.watch(patientenProvider);
    final content = asyncPatienten.when(
      data: (patienten) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: patienten.length,
        itemBuilder: (context, index) {
          final patient = patienten[index];
          return PatientListTile(
            patient: patient,
            selected: patient.id == selectedPatientId,
          );
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
              key: const Key('createPatient'),
              icon: const Icon(Icons.add),
              label: const Text('Anlegen'),
              tooltip: 'Anlegen',
              onPressed: () {
                context.go('/patienten/create');
              },
            )
          : null,
      body: content,
    );
    return page;
  }
}

class PatientListTile extends ConsumerWidget {
  const PatientListTile({
    required this.patient,
    required this.selected,
    super.key,
  });

  final Patient patient;

  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      onTap: () {
        context.go('/patienten/${patient.id}');
      },
      title: Text(patient.fullName),
      subtitle: patient.address.isNotEmpty ? Text(patient.address) : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await ref.read(patientRepositoryProvider).deletePatient(patient.id);
          ref.refresh(patientenProvider);
        },
      ),
    );
  }
}

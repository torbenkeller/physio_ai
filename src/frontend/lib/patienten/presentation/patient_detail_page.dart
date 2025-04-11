import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patient_form.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';

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
        return PatientForm(patient: patient);
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

class PatientDetailContent extends StatelessWidget {
  const PatientDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

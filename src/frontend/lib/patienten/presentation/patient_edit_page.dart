import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/patienten/presentation/patient_detail_page.dart';
import 'package:physio_ai/patienten/presentation/patient_form.dart';

class PatientEditPage extends ConsumerWidget {
  const PatientEditPage({
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
          return const Scaffold(
            body: Center(
              child: Text('Patient nicht gefunden'),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('${patient.fullName} bearbeiten'),
          ),
          body: PatientForm(patient: patient),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, __) => Scaffold(
        body: Center(
          child: Text('Fehler beim Laden: $error'),
        ),
      ),
    );
  }
}

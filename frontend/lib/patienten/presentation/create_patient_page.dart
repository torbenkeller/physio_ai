import 'package:flutter/material.dart';
import 'package:physio_ai/patienten/presentation/patient_form.dart';

class CreatePatientPage extends StatelessWidget {
  const CreatePatientPage({
    this.redirectTo,
    super.key,
  });

  final String? redirectTo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Erstellen'),
      ),
      body: CreatePatientContent(redirectTo: redirectTo),
    );
  }
}

class CreatePatientContent extends StatelessWidget {
  const CreatePatientContent({
    this.redirectTo,
    super.key,
  });

  final String? redirectTo;

  @override
  Widget build(BuildContext context) {
    return PatientForm(
      patient: null,
      redirectTo: redirectTo,
    );
  }
}

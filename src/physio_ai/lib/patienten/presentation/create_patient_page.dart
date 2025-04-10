import 'package:flutter/material.dart';
import 'package:physio_ai/patienten/presentation/patient_form.dart';

class CreatePatientPage extends StatelessWidget {
  const CreatePatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Erstellen'),
      ),
      body: const CreatePatientContent(),
    );
  }
}

class CreatePatientContent extends StatelessWidget {
  const CreatePatientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const PatientForm(patient: null);
  }
}

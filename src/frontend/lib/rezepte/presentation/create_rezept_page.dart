import 'package:flutter/material.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form.dart';
import 'package:physio_ai/rezepte/rezept.dart';

class CreateRezeptPage extends StatelessWidget {
  const CreateRezeptPage({
    this.prefillRezept,
    super.key,
  });

  final Rezept? prefillRezept;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezept Erstellen'),
      ),
      body: CreateRezeptContent(
        prefillRezept: prefillRezept,
      ),
    );
  }
}

class CreateRezeptContent extends StatelessWidget {
  const CreateRezeptContent({
    this.prefillRezept,
    super.key,
  });

  final Rezept? prefillRezept;

  @override
  Widget build(BuildContext context) {
    // Assign a unique key to ensure the form is recreated each time
    // This ensures the form is properly reset when navigating back to this page
    return RezeptForm(
      key: UniqueKey(),
      rezept: prefillRezept,
    );
  }
}

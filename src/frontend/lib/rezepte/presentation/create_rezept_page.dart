import 'package:flutter/material.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form.dart';

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
    return RezeptForm(
      rezept: prefillRezept,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form.dart';

class CreateRezeptPage extends StatelessWidget {
  const CreateRezeptPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezept Erstellen'),
      ),
      body: const RezeptForm(),
    );
  }
}

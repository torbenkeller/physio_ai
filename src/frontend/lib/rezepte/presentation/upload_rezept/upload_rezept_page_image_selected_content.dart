import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_notifier.dart';

class UploadRezeptPageImageSelectedContent extends ConsumerWidget {
  const UploadRezeptPageImageSelectedContent({
    required this.selectedImage,
    super.key,
  });

  final File selectedImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(
                selectedImage,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(uploadRezeptNotifierProvider.notifier).uploadImage(selectedImage),
                icon: const Icon(Icons.upload),
                label: const Text('Bild hochladen und analysieren'),
              ),
              TextButton(
                onPressed: () => ref.read(uploadRezeptNotifierProvider.notifier).reset(),
                child: const Text('Anderes Bild auswählen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

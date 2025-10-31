import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_notifier.dart';

class UploadRezeptPageInitialContent extends ConsumerWidget {
  const UploadRezeptPageInitialContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Laden Sie ein Foto eines Rezepts hoch, um es automatisch zu analysieren',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => ref.read(uploadRezeptNotifierProvider.notifier).pickImage(),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Aus Galerie'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(uploadRezeptNotifierProvider.notifier).takePhoto(),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

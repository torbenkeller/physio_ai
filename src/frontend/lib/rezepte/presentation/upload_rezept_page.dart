import 'dart:io' if (dart.library.html) 'package:web/web.dart' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/rezepte/presentation/patient_selection_view.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept_notifier.dart';

class UploadRezeptPage extends StatelessWidget {
  const UploadRezeptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezept von Bild'),
      ),
      body: const UploadRezeptContent(),
    );
  }
}

class UploadRezeptContent extends ConsumerWidget {
  const UploadRezeptContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadRezeptNotifierProvider);

    // Using type-based switch expression for pattern matching
    return switch (state) {
      UploadRezeptStateInitial() => const InitialStateWidget(),
      UploadRezeptStateLoading() => const LoadingStateWidget(),
      UploadRezeptStateImageSelected(selectedImage: final image) =>
        ImageSelectedStateWidget(selectedImage: image),
      UploadRezeptStateRezeptEingelesen(
        response: final response,
        selectedImage: final selectedImage
      ) =>
        PatientSelectionView(
          response: response,
          selectedImage: selectedImage,
        ),
      UploadRezeptStatePatientSelected(
        response: final response,
        selectedPatient: final selectedPatient,
        selectedImage: final selectedImage
      ) =>
        PatientSelectionView(
          response: response,
          selectedImage: selectedImage,
        ),
      UploadRezeptStateError(message: final message) => ErrorStateWidget(message: message),
    };
  }
}

class InitialStateWidget extends ConsumerWidget {
  const InitialStateWidget({super.key});

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

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Rezept wird analysiert... (Das kann bis zu 30 Sekunden dauern)'),
        ],
      ),
    );
  }
}

class ImageSelectedStateWidget extends ConsumerWidget {
  const ImageSelectedStateWidget({
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

class ErrorStateWidget extends ConsumerWidget {
  const ErrorStateWidget({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(uploadRezeptNotifierProvider.notifier).reset(),
            child: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }
}

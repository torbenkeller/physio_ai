import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_notifier.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_page_error_content.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_page_image_selected_content.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_page_initial_content.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_page_loading_content.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_page_select_patient_content.dart';

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
      UploadRezeptStateInitial() => const UploadRezeptPageInitialContent(),
      UploadRezeptStateLoading() => const UploadRezeptPageLoadingContent(),
      UploadRezeptStateImageSelected(selectedImage: final image) =>
        UploadRezeptPageImageSelectedContent(selectedImage: image),
      UploadRezeptStateRezeptEingelesen(
        response: final response,
        selectedImage: final selectedImage
      ) =>
        UploadRezeptPageSelectPatientContent(
          response: response,
          selectedImage: selectedImage,
        ),
      UploadRezeptStatePatientSelected(
        response: final response,
        selectedPatient: final selectedPatient,
        selectedImage: final selectedImage
      ) =>
        UploadRezeptPageSelectPatientContent(
          response: response,
          selectedImage: selectedImage,
        ),
      UploadRezeptStateError(message: final message) =>
        UploadRezeptPageErrorContent(message: message),
    };
  }
}

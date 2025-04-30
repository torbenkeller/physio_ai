import 'dart:io' if (dart.library.html) 'package:web/web.dart' show File;

import 'package:dio/dio.dart' show DioMediaType, MultipartFile;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/rezept_repository.dart';

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

class UploadRezeptContent extends ConsumerStatefulWidget {
  const UploadRezeptContent({super.key});

  @override
  ConsumerState<UploadRezeptContent> createState() => _UploadRezeptContentState();
}

class _UploadRezeptContentState extends ConsumerState<UploadRezeptContent> {
  bool _loading = false;
  File? _selectedFile;
  RezeptEinlesenResponse? _response;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
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

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedFile != null) ...[
                Image.file(
                  _selectedFile!,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _uploadImage,
                  icon: const Icon(Icons.upload),
                  label: const Text('Bild hochladen und analysieren'),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedFile = null),
                  child: const Text('Anderes Bild auswählen'),
                ),
              ] else ...[
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
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Aus Galerie'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Kamera'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Auswählen der Datei: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error picking image: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Aufnehmen des Fotos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error taking photo: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedFile == null) return;

    setState(() {
      _loading = true;
    });

    try {
      String fileName = _selectedFile!.path.split('/').last;
      String extension = fileName.split('.').last.toLowerCase();

      // Map file extension to mime type
      String mimeType;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'gif':
          mimeType = 'image/gif';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        case 'heic':
          mimeType = 'image/heic';
          break;
        default:
          mimeType = 'application/octet-stream';
      }

      // Create form data
      final file = await MultipartFile.fromFile(
        _selectedFile!.path,
        filename: fileName,
        contentType: DioMediaType.parse(mimeType),
      );

      final repo = ref.read(rezeptRepositoryProvider);
      final response = await repo.uploadRezeptImage([file]);

      if (mounted) {
        final rezept = response.toRezept();

        context.go('/rezepte/create', extra: rezept);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Upload: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

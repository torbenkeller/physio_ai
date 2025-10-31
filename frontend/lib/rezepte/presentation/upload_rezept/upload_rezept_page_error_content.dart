import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_notifier.dart';

class UploadRezeptPageErrorContent extends ConsumerWidget {
  const UploadRezeptPageErrorContent({
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infrastructure/profile_repository.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: profileAsync.when(
        data: (profile) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, profile.praxisName, profile.inhaberName),
              const SizedBox(height: 24),
              _buildInfoSection(context, 'Praxis Information'),
              ListTile(
                title: const Text('Praxisname'),
                subtitle: Text(profile.praxisName),
              ),
              ListTile(
                title: const Text('Inhaber'),
                subtitle: Text(profile.inhaberName),
              ),
              const SizedBox(height: 24),
              if (profile.calenderUrl != null) ...[
                _buildInfoSection(context, 'Kalender URL'),
                ListTile(
                  title: Text(
                    profile.calenderUrl!.length > 40
                        ? '${profile.calenderUrl!.substring(0, 40)}...'
                        : profile.calenderUrl!,
                  ),
                  subtitle: const Text('Klicken zum Kopieren'),
                  trailing: const Icon(Icons.copy),
                  onTap: () => _copyToClipboard(context, profile.calenderUrl!),
                ),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Fehler beim Laden des Profils: $error'),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String praxisName, String inhaberName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            praxisName.isNotEmpty ? praxisName[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                praxisName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                inhaberName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('In die Zwischenablage kopiert'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

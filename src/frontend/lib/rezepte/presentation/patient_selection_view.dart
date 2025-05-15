import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept_notifier.dart';

class PatientSelectionView extends ConsumerStatefulWidget {
  const PatientSelectionView({
    required this.response,
    required this.selectedImage,
    super.key,
  });

  final RezeptEinlesenResponse response;

  final File selectedImage;

  @override
  ConsumerState<PatientSelectionView> createState() => _PatientSelectionViewState();
}

class _PatientSelectionViewState extends ConsumerState<PatientSelectionView> {
  bool _isCreateNewPatientLoading = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analyzed patient data section
            Text(
              'Analyzed Patient Data',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _PatientDataCard(
              name: '${widget.response.patient.vorname} ${widget.response.patient.nachname}',
              address: '${widget.response.patient.strasse} ${widget.response.patient.hausnummer}\n'
                  '${widget.response.patient.postleitzahl} ${widget.response.patient.stadt}',
              birthDate: dateFormat.format(widget.response.patient.geburtstag),
            ),
            const SizedBox(height: 24),

            // Existing patient match section (or no match info)
            if (widget.response.existingPatient != null) ...[
              Text(
                'Matching Patient',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _PatientDataCard(
                name:
                    '${widget.response.existingPatient!.vorname} ${widget.response.existingPatient!.nachname} '
                    '(${widget.response.existingPatient!.id})',
                address: widget.response.existingPatient!.address,
                birthDate: dateFormat.format(widget.response.existingPatient!.geburtstag),
                extraInfo: widget.response.existingPatient!.email ?? '',
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleUseExistingPatient(ref),
                          child: const Text('Use Existing Patient'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handleCreateNewPatient(ref),
                          child: const Text('Create New Patient'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleCreateNewPatient(ref),
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Create Directly'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'No matching patient found',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'We could not find a matching patient in our records. '
                'You can create a new patient with the extracted data.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleCreateNewPatient(ref),
                      child: const Text('Create New Patient'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleCreateNewPatient(ref),
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Create Directly'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Rezept image preview
            const SizedBox(height: 32),
            Text(
              'Original Rezept Image',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                widget.selectedImage,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text('Unable to load image'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUseExistingPatient(WidgetRef ref) {
    ref.read(uploadRezeptNotifierProvider.notifier).selectSuggestedPatient(widget.response);
  }

  Future<void> _handleCreateNewPatient(WidgetRef ref) async {
    setState(() {
      _isCreateNewPatientLoading = true;
    });

    await ref.read(uploadRezeptNotifierProvider.notifier).createNewPatient(widget.response);

    if (!mounted) {
      return;
    }

    setState(() {
      _isCreateNewPatientLoading = false;
    });
  }
}

class _PatientDataCard extends StatelessWidget {
  const _PatientDataCard({
    required this.name,
    required this.address,
    required this.birthDate,
    this.extraInfo = '',
    super.key,
  });

  final String name;
  final String address;
  final String birthDate;
  final String extraInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  birthDate,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (extraInfo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    extraInfo,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

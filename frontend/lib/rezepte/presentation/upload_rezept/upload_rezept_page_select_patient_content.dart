import 'dart:io' if (dart.library.html) 'package:web/web.dart' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/comparison_patient_data_dard.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_notifier.dart';

class UploadRezeptPageSelectPatientContent extends ConsumerStatefulWidget {
  const UploadRezeptPageSelectPatientContent({
    required this.response,
    required this.selectedImage,
    super.key,
  });

  final RezeptEinlesenResponse response;

  final File selectedImage;

  @override
  ConsumerState<UploadRezeptPageSelectPatientContent> createState() => _PatientSelectionViewState();
}

class _PatientSelectionViewState extends ConsumerState<UploadRezeptPageSelectPatientContent> {
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
            // Rezept image preview
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
            const SizedBox(height: 32),

            // Patient information section
            Text(
              'Patient Information',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            if (widget.response.existingPatient != null) ...[
              // Side-by-side patient data cards when we have a match
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Analyzed patient data
                  Expanded(
                    child: ComparisonPatientDataCard(
                      title: 'Analyzed Patient Data',
                      analyzedPatient: widget.response.patient,
                      existingPatient: widget.response.existingPatient!,
                      dateFormat: dateFormat,
                      isAnalyzed: true,
                      onButtonPressed: () => _handleCreateNewPatient(ref),
                      isLoading: _isCreateNewPatientLoading,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Existing patient data
                  Expanded(
                    child: ComparisonPatientDataCard(
                      title: 'Existing Patient',
                      analyzedPatient: widget.response.patient,
                      existingPatient: widget.response.existingPatient!,
                      dateFormat: dateFormat,
                      isAnalyzed: false,
                      onButtonPressed: () => _handleUseExistingPatient(ref),
                      isLoading: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ] else ...[
              // When no existing patient match is found
              // Single patient data card with analyzed data only
              _PatientDataCard(
                name: '${widget.response.patient.vorname} ${widget.response.patient.nachname}',
                address:
                    '${widget.response.patient.strasse} ${widget.response.patient.hausnummer}\n'
                    '${widget.response.patient.postleitzahl} ${widget.response.patient.stadt}',
                birthDate: dateFormat.format(widget.response.patient.geburtstag),
                title: 'Analyzed Patient Data',
                onButtonPressed: () => _handleCreateNewPatient(ref),
                isLoading: _isCreateNewPatientLoading,
              ),
              const SizedBox(height: 12),
              Text(
                'No matching patient found in our records. '
                'You can create a new patient with the extracted data.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
            ],

            // Analyzed rezept data section
            const SizedBox(height: 24),
            Text(
              'Analyzed Rezept Data',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _RezeptDataCard(
              ausgestelltAm: dateFormat.format(widget.response.rezept.ausgestelltAm),
              rezeptpositionen: widget.response.rezept.rezeptpositionen,
            ),
            const SizedBox(height: 24),
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

    try {
      await ref.read(uploadRezeptNotifierProvider.notifier).createNewPatient(widget.response);
    } finally {
      if (mounted) {
        setState(() {
          _isCreateNewPatientLoading = false;
        });
      }
    }
  }
}

class _PatientDataCard extends StatelessWidget {
  const _PatientDataCard({
    required this.name,
    required this.address,
    required this.birthDate,
    required this.onButtonPressed,
    required this.isLoading,
    this.title,
  });

  final String name;
  final String address;
  final String birthDate;
  final String? title;
  final VoidCallback onButtonPressed;
  final bool isLoading;

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
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
            ],
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isLoading ? null : onButtonPressed,
                child: const Text('Create New Patient'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RezeptDataCard extends StatelessWidget {
  const _RezeptDataCard({
    required this.ausgestelltAm,
    required this.rezeptpositionen,
  });

  final String ausgestelltAm;
  final List<EingelesenesRezeptPos> rezeptpositionen;

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
            Row(
              children: [
                const Icon(Icons.receipt_long, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Prescription',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Issued on: $ausgestelltAm',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Treatments:',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rezeptpositionen.length,
              itemBuilder: (context, index) {
                final position = rezeptpositionen[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.medical_services_outlined, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${position.anzahl}x ${position.behandlungsart.name}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

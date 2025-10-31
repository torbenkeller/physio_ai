import 'dart:io' if (dart.library.html) 'package:web/web.dart' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_form_dto.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_notifier.dart';

class UploadRezeptPagePatientSelectedContent extends ConsumerStatefulWidget {
  const UploadRezeptPagePatientSelectedContent({
    required this.response,
    required this.selectedPatient,
    required this.selectedImage,
    super.key,
  });

  final RezeptEinlesenResponse response;
  final Patient selectedPatient;
  final File selectedImage;

  @override
  ConsumerState<UploadRezeptPagePatientSelectedContent> createState() =>
      _UploadRezeptPagePatientSelectedContentState();
}

class _UploadRezeptPagePatientSelectedContentState
    extends ConsumerState<UploadRezeptPagePatientSelectedContent> {
  bool _isCreatingRezept = false;

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

            // Selected patient information section with confirmation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Patient',
                  style: theme.textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: _handleGoBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Change Patient'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Selected patient card with highlighted border
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _PatientDataCard(
                name: '${widget.selectedPatient.vorname} ${widget.selectedPatient.nachname}',
                address:
                    '${widget.selectedPatient.strasse} '
                    '${widget.selectedPatient.hausnummer}\n'
                    '${widget.selectedPatient.plz} '
                    '${widget.selectedPatient.stadt}',
                birthDate: dateFormat.format(widget.selectedPatient.geburtstag),
                title: 'Patient Information',
                icon: Icons.check_circle,
                iconColor: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Analyzed rezept data section
            Text(
              'Analyzed Rezept Data',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _RezeptDataCard(
              ausgestelltAm: dateFormat.format(widget.response.rezept.ausgestelltAm),
              rezeptpositionen: widget.response.rezept.rezeptpositionen,
            ),
            const SizedBox(height: 32),

            // Create rezept button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isCreatingRezept ? null : _handleCreateRezept,
                child: _isCreatingRezept
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Creating Rezept...',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Create Rezept',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGoBack() {
    // Reset to RezeptEingelesen state to go back to patient selection
    final notifier = ref.read(uploadRezeptNotifierProvider.notifier);
    notifier.reset();
    // We could alternatively set the state back to RezeptEingelesen
    // but this approach is simpler for now
  }

  Future<void> _handleCreateRezept() async {
    setState(() {
      _isCreatingRezept = true;
    });

    try {
      // Create RezeptFormDto from the response data
      final rezeptFormDto = RezeptFormDto(
        patientId: widget.selectedPatient.id,
        ausgestelltAm: widget.response.rezept.ausgestelltAm,
        positionen: widget.response.rezept.rezeptpositionen
            .map(
              (pos) => RezeptPositionDto(
                behandlungsartId: pos.behandlungsart.id,
                anzahl: pos.anzahl,
              ),
            )
            .toList(),
      );

      // Create the rezept
      final rezept = await ref
          .read(uploadRezeptNotifierProvider.notifier)
          .createRezept(rezeptFormDto);

      // Navigate to the Rezept detail page on success
      if (mounted) {
        context.go('/rezepte/${rezept.id}');
      }
    } catch (e) {
      // Error will be handled by the notifier which will set the state to error
      // The error page will be shown automatically due to the state change
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingRezept = false;
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
    this.title,
    this.icon,
    this.iconColor,
  });

  final String name;
  final String address;
  final String birthDate;
  final String? title;
  final IconData? icon;
  final Color? iconColor;

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
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: iconColor ?? theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
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

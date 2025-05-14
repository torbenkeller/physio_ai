import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';

class PatientSelectionView extends StatelessWidget {
  const PatientSelectionView({
    required this.response,
    required this.onUseExistingPatient,
    required this.onCreateNewPatient,
    super.key,
  });

  final RezeptEinlesenResponse response;
  final Function(String patientId) onUseExistingPatient;
  final VoidCallback onCreateNewPatient;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final theme = Theme.of(context);

    return SingleChildScrollView(
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
            name: '${response.patient.vorname} ${response.patient.nachname}',
            address: '${response.patient.strasse} ${response.patient.hausnummer}\n'
                '${response.patient.postleitzahl} ${response.patient.stadt}',
            birthDate: dateFormat.format(response.patient.geburtstag),
          ),
          const SizedBox(height: 24),

          // Existing patient match section (or no match info)
          if (response.existingPatient != null) ...[
            Text(
              'Matching Patient',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _PatientDataCard(
              name: '${response.existingPatient!.vorname} ${response.existingPatient!.nachname} '
                  '(${response.existingPatient!.id})',
              address: response.existingPatient!.address,
              birthDate: dateFormat.format(response.existingPatient!.geburtstag),
              extraInfo: response.existingPatient!.email ?? '',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onUseExistingPatient(response.existingPatient!.id),
                    child: const Text('Use Existing Patient'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCreateNewPatient,
                    child: const Text('Create New Patient'),
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
              'We couldn\'t find a matching patient in our records. '
              'You can create a new patient with the extracted data.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onCreateNewPatient,
              child: const Text('Create New Patient'),
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
            child: Image.network(
              response.path,
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
    );
  }
}

class _PatientDataCard extends StatelessWidget {
  const _PatientDataCard({
    required this.name,
    required this.address,
    required this.birthDate,
    this.extraInfo = '',
    Key? key,
  }) : super(key: key);
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';

/// A patient data card that compares data with another patient and highlights differences
class ComparisonPatientDataCard extends StatelessWidget {
  const ComparisonPatientDataCard({
    required this.analyzedPatient,
    required this.existingPatient,
    required this.dateFormat,
    required this.isAnalyzed,
    required this.title,
    required this.onButtonPressed,
    required this.isLoading,
    super.key,
  });

  /// The analyzed patient data from OCR
  final EingelesenerPatient analyzedPatient;

  /// The existing patient found in the database
  final Patient existingPatient;

  /// Date formatter for displaying dates
  final DateFormat dateFormat;

  /// Whether this card shows the analyzed patient data (true) or existing patient data (false)
  final bool isAnalyzed;

  /// Title for the card
  final String title;

  /// Function to call when button is pressed
  final VoidCallback onButtonPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Extract patient info based on whether we're showing analyzed or existing data
    late final String name;
    late final String address;
    late final DateTime birthDate;

    if (isAnalyzed) {
      // Showing analyzed patient
      name = '${analyzedPatient.vorname} ${analyzedPatient.nachname}';
      address =
          '${analyzedPatient.strasse} ${analyzedPatient.hausnummer}\n${analyzedPatient.postleitzahl} ${analyzedPatient.stadt}';
      birthDate = analyzedPatient.geburtstag;
    } else {
      // Showing existing patient
      name = '${existingPatient.vorname} ${existingPatient.nachname}';
      address = existingPatient.address;
      birthDate = existingPatient.geburtstag;
    }

    // Extract comparison data
    late final String comparisonName;
    late final String comparisonAddress;
    late final DateTime comparisonBirthDate;

    if (isAnalyzed) {
      // Comparing against existing patient
      comparisonName = '${existingPatient.vorname} ${existingPatient.nachname}';
      comparisonAddress = existingPatient.address;
      comparisonBirthDate = existingPatient.geburtstag;
    } else {
      // Comparing against analyzed patient
      comparisonName = '${analyzedPatient.vorname} ${analyzedPatient.nachname}';
      comparisonAddress =
          '${analyzedPatient.strasse} ${analyzedPatient.hausnummer}\n${analyzedPatient.postleitzahl} ${analyzedPatient.stadt}';
      comparisonBirthDate = analyzedPatient.geburtstag;
    }

    // Check for differences
    final hasDifferentName = _normalizeText(name) != _normalizeText(comparisonName);
    final hasDifferentAddress = _normalizeAddress(address) != _normalizeAddress(comparisonAddress);
    final hasDifferentBirthDate = !_compareDates(birthDate, comparisonBirthDate);

    // Apply highlight colors as a text marker (yellow background) for differences
    const Color highlightColor = Colors.yellow;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row including ID if this is an existing patient
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isAnalyzed ? theme.colorScheme.secondary : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Patient name
            Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                backgroundColor: hasDifferentName ? highlightColor : null,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      backgroundColor: hasDifferentAddress ? highlightColor : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Birth date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  dateFormat.format(birthDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    backgroundColor: hasDifferentBirthDate ? highlightColor : null,
                  ),
                ),
              ],
            ),
            // Email (only for existing patient)
            if (!isAnalyzed && (existingPatient.email?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    existingPatient.email!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: isAnalyzed
                  ? OutlinedButton(
                      onPressed: isLoading ? null : onButtonPressed,
                      child: const Text('Create New Patient'),
                    )
                  : ElevatedButton(
                      onPressed: onButtonPressed,
                      child: const Text('Use Existing Patient'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Normalizes address text for comparison by removing extra whitespace and line breaks
  String _normalizeAddress(String address) {
    return address.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').toLowerCase().trim();
  }

  /// Normalizes text for comparison
  String _normalizeText(String text) {
    return text.toLowerCase().trim();
  }

  /// Compares two dates for equality (ignoring time)
  bool _compareDates(DateTime date1, DateTime date2) {
    return DateUtils.dateOnly(date1) == DateUtils.dateOnly(date2);
  }
}

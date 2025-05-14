import 'dart:io' if (dart.library.html) 'package:web/web.dart' show File;

import 'package:dio/dio.dart' show DioMediaType, MultipartFile;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/infrastructure/patient_form_dto.dart';
import 'package:physio_ai/patienten/infrastructure/patient_repository.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_repository.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';

part 'generated/upload_rezept_notifier.freezed.dart';

// Provider for the notifier
final uploadRezeptNotifierProvider =
    StateNotifierProvider<UploadRezeptNotifier, UploadRezeptState>(
  (ref) => UploadRezeptNotifier(
    rezeptRepository: ref.read(rezeptRepositoryProvider),
    patientRepository: ref.read(patientRepositoryProvider),
  ),
);

// State class for the upload process
@freezed
sealed class UploadRezeptState with _$UploadRezeptState {
  const factory UploadRezeptState.initial() = UploadRezeptStateInitial;
  const factory UploadRezeptState.loading() = UploadRezeptStateLoading;
  const factory UploadRezeptState.imageSelected({
    required File selectedFile,
  }) = UploadRezeptStateImageSelected;
  const factory UploadRezeptState.patientSelection({
    required RezeptEinlesenResponse response,
  }) = UploadRezeptStatePatientSelection;
  const factory UploadRezeptState.error({
    required String message,
  }) = UploadRezeptStateError;
}

// Data class to hold both patient and rezept data when creating a new patient
class PatientSelectionData {
  PatientSelectionData({
    required this.patient,
    required this.response,
  });

  final Patient patient;
  final RezeptEinlesenResponse response;
}

// Notifier class that manages the state and business logic
class UploadRezeptNotifier extends StateNotifier<UploadRezeptState> {
  UploadRezeptNotifier({
    required RezeptRepository rezeptRepository,
    required PatientRepository patientRepository,
  })  : _rezeptRepository = rezeptRepository,
        _patientRepository = patientRepository,
        super(const UploadRezeptState.initial());

  final RezeptRepository _rezeptRepository;
  final PatientRepository _patientRepository;

  // Reset state to initial
  void reset() {
    state = const UploadRezeptState.initial();
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        state = UploadRezeptState.imageSelected(
          selectedFile: File(pickedFile.path),
        );
      }
    } on Exception catch (e) {
      state = UploadRezeptState.error(
          message: 'Fehler beim Auswählen der Datei: $e');
    }
  }

  // Take photo with camera
  Future<void> takePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        state = UploadRezeptState.imageSelected(
          selectedFile: File(pickedFile.path),
        );
      }
    } on Exception catch (e) {
      state = UploadRezeptState.error(
          message: 'Fehler beim Aufnehmen des Fotos: $e');
    }
  }

  // Upload the selected image
  Future<void> uploadImage(File selectedFile) async {
    state = const UploadRezeptState.loading();

    try {
      final fileName = selectedFile.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      // Map file extension to mime type
      String mimeType;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
        case 'png':
          mimeType = 'image/png';
        case 'gif':
          mimeType = 'image/gif';
        case 'webp':
          mimeType = 'image/webp';
        case 'heic':
          mimeType = 'image/heic';
        default:
          mimeType = 'application/octet-stream';
      }

      // Create form data
      final file = await MultipartFile.fromFile(
        selectedFile.path,
        filename: fileName,
        contentType: DioMediaType.parse(mimeType),
      );

      final response = await _rezeptRepository.uploadRezeptImage([file]);

      state = UploadRezeptState.patientSelection(response: response);
    } on Exception catch (e) {
      state = UploadRezeptState.error(message: 'Fehler beim Upload: $e');
    }
  }

  // Create a rezept from the response with an existing patient
  Rezept createRezeptFromExistingPatient(
      String patientId, RezeptEinlesenResponse response) {
    return Rezept(
      id: '',
      patient: RezeptPatient(
        id: patientId,
        vorname: response.existingPatient!.vorname,
        nachname: response.existingPatient!.nachname,
      ),
      ausgestelltAm: response.rezept.ausgestelltAm,
      preisGesamt: 0,
      positionen: response.rezept.rezeptpositionen
          .map(
            (pos) => RezeptPos(
              anzahl: pos.anzahl,
              behandlungsart: pos.behandlungsart,
            ),
          )
          .toIList(),
    );
  }

  // Create a new patient from the analyzed data
  PatientSelectionData createNewPatientData(RezeptEinlesenResponse response) {
    final newPatient = Patient(
      id: '',
      vorname: response.patient.vorname,
      nachname: response.patient.nachname,
      geburtstag: response.patient.geburtstag,
      titel: response.patient.titel,
      strasse: response.patient.strasse,
      hausnummer: response.patient.hausnummer,
      plz: response.patient.postleitzahl,
      stadt: response.patient.stadt,
    );

    return PatientSelectionData(
      patient: newPatient,
      response: response,
    );
  }

  // Create a new patient and return a Rezept ready for creation
  Future<Rezept> createNewPatientAndReturnRezept(
      RezeptEinlesenResponse response) async {
    try {
      final patientFormDto = PatientFormDto(
        vorname: response.patient.vorname,
        nachname: response.patient.nachname,
        geburtstag: response.patient.geburtstag,
        titel: response.patient.titel,
        strasse: response.patient.strasse,
        hausnummer: response.patient.hausnummer,
        plz: response.patient.postleitzahl,
        stadt: response.patient.stadt,
      );

      // Create the patient
      await _patientRepository.createPatient(patientFormDto);

      // Get all patients to find the newly created one
      final allPatients = await _patientRepository.getPatienten();

      // Find the newly created patient by matching name and birth date
      final createdPatient = allPatients.firstWhere(
        (p) =>
            p.vorname == response.patient.vorname &&
            p.nachname == response.patient.nachname &&
            p.geburtstag.year == response.patient.geburtstag.year &&
            p.geburtstag.month == response.patient.geburtstag.month &&
            p.geburtstag.day == response.patient.geburtstag.day,
        orElse: () => throw Exception('Newly created patient not found'),
      );

      // Create the rezept with the new patient
      return Rezept(
        id: '',
        patient: RezeptPatient(
          id: createdPatient.id,
          vorname: createdPatient.vorname,
          nachname: createdPatient.nachname,
        ),
        ausgestelltAm: response.rezept.ausgestelltAm,
        preisGesamt: 0,
        positionen: response.rezept.rezeptpositionen
            .map(
              (pos) => RezeptPos(
                anzahl: pos.anzahl,
                behandlungsart: pos.behandlungsart,
              ),
            )
            .toIList(),
      );
    } on Exception catch (e) {
      throw Exception('Fehler beim Erstellen des Patienten: $e');
    }
  }
}

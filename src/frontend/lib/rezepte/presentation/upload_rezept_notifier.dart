import 'dart:io' if (dart.library.html) 'package:web/web.dart' show File;

import 'package:dio/dio.dart' show DioMediaType, MultipartFile;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/infrastructure/patient_form_dto.dart';
import 'package:physio_ai/patienten/infrastructure/patient_repository.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_form_dto.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_repository.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';

part 'generated/upload_rezept_notifier.freezed.dart';

// Provider for the notifier
final uploadRezeptNotifierProvider = StateNotifierProvider<UploadRezeptNotifier, UploadRezeptState>(
  (ref) => UploadRezeptNotifier(
    rezeptRepository: ref.read(rezeptRepositoryProvider),
    patientRepository: ref.read(patientRepositoryProvider),
    imagePicker: ImagePicker(),
  ),
);

// State class for the upload process
@freezed
sealed class UploadRezeptState with _$UploadRezeptState {
  const factory UploadRezeptState.initial() = UploadRezeptStateInitial;

  const factory UploadRezeptState.loading() = UploadRezeptStateLoading;

  const factory UploadRezeptState.imageSelected({
    required File selectedImage,
  }) = UploadRezeptStateImageSelected;

  const factory UploadRezeptState.rezeptEingelesen({
    required File selectedImage,
    required RezeptEinlesenResponse response,
  }) = UploadRezeptStateRezeptEingelesen;

  const factory UploadRezeptState.patientSelected({
    required File selectedImage,
    required RezeptEinlesenResponse response,
    required Patient selectedPatient,
  }) = UploadRezeptStatePatientSelected;

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
    required ImagePicker imagePicker,
  })  : _rezeptRepository = rezeptRepository,
        _patientRepository = patientRepository,
        _imagePicker = imagePicker,
        super(const UploadRezeptState.initial());

  final RezeptRepository _rezeptRepository;
  final PatientRepository _patientRepository;
  final ImagePicker _imagePicker;

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
          selectedImage: File(pickedFile.path),
        );
      }
    } on Exception catch (e) {
      state = UploadRezeptState.error(message: 'Fehler beim Auswählen der Datei: $e');
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
          selectedImage: File(pickedFile.path),
        );
      }
    } on Exception catch (e) {
      state = UploadRezeptState.error(message: 'Fehler beim Aufnehmen des Fotos: $e');
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

      state = UploadRezeptState.rezeptEingelesen(
        response: response,
        selectedImage: selectedFile,
      );
    } on Exception catch (e) {
      state = UploadRezeptState.error(message: 'Fehler beim Upload: $e');
    }
  }

  // Create a new patient and return a Rezept ready for creation
  Future<void> createNewPatient(RezeptEinlesenResponse response) async {
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
      final patient = await _patientRepository.createPatient(patientFormDto);
      state = UploadRezeptState.patientSelected(
        response: response,
        selectedImage: switch (state) {
          UploadRezeptStateImageSelected(selectedImage: final file) => file,
          UploadRezeptStateRezeptEingelesen(selectedImage: final file) => file,
          _ => throw Exception('Invalid state for image selection'),
        },
        selectedPatient: patient,
      );
    } on Exception catch (e) {
      state = UploadRezeptState.error(message: 'Fehler beim Erstellen des Patienten: $e');
      rethrow;
    }
  }

  void selectSuggestedPatient(RezeptEinlesenResponse response) {
    state = UploadRezeptState.patientSelected(
      response: response,
      selectedImage: switch (state) {
        UploadRezeptStateRezeptEingelesen(selectedImage: final file) => file,
        _ => throw Exception('Invalid state for image selection'),
      },
      selectedPatient: response.existingPatient!,
    );
  }

  Future<Rezept> createRezept(RezeptFormDto rezept) async {
    try {
      return await _rezeptRepository.createRezept(rezept);
    } on Exception catch (e) {
      state = UploadRezeptState.error(message: 'Fehler beim Erstellen des Rezepts: $e');
      rethrow;
    }
  }
}

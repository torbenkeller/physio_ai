import 'package:flutter/cupertino.dart';
import 'package:physio_ai/patienten/infrastructure/patient_form_dto.dart';
import 'package:physio_ai/patienten/presentation/form_container.dart';

class PatientFormContainer extends FormContainer {
  PatientFormContainer()
      : vorname = GlobalKey(),
        nachname = GlobalKey(),
        geburtstag = GlobalKey(),
        titel = GlobalKey(),
        strasse = GlobalKey(),
        hausnummer = GlobalKey(),
        plz = GlobalKey(),
        stadt = GlobalKey(),
        telMobil = GlobalKey(),
        telFestnetz = GlobalKey(),
        email = GlobalKey(),
        super(formKey: GlobalKey());

  final GlobalKey<FormFieldState<String>> vorname;
  final GlobalKey<FormFieldState<String>> nachname;
  final GlobalKey<FormFieldState<DateTime?>> geburtstag;
  final GlobalKey<FormFieldState<String?>> titel;
  final GlobalKey<FormFieldState<String?>> strasse;
  final GlobalKey<FormFieldState<String?>> hausnummer;
  final GlobalKey<FormFieldState<String?>> plz;
  final GlobalKey<FormFieldState<String?>> stadt;
  final GlobalKey<FormFieldState<String?>> telMobil;
  final GlobalKey<FormFieldState<String?>> telFestnetz;
  final GlobalKey<FormFieldState<String?>> email;

  PatientFormDto toFormDto() {
    return PatientFormDto(
      vorname: vorname.currentState!.value!,
      nachname: nachname.currentState!.value!,
      geburtstag: geburtstag.currentState!.value!,
      titel: titel.currentState!.value,
      strasse: strasse.currentState!.value,
      hausnummer: hausnummer.currentState!.value,
      plz: plz.currentState!.value,
      stadt: stadt.currentState!.value,
      telMobil: telMobil.currentState!.value,
      telFestnetz: telFestnetz.currentState!.value,
      email: email.currentState!.value,
    );
  }

  @override
  List<GlobalKey<FormFieldState<dynamic>>> get requiredFields => [
        vorname,
        nachname,
        geburtstag,
      ];
}

import 'package:flutter/cupertino.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/infrastructure/patient_form_dto.dart';
import 'package:physio_ai/shared_kernel/presentation/form_container.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_container.dart';
import 'package:physio_ai/shared_kernel/presentation/validation/validators.dart';

class PatientFormContainer extends FormContainer {
  PatientFormContainer({required Patient? patient})
      : vorname = FormFieldContainer(
          initialValue: patient?.vorname ?? '',
          validators: [validateRequired],
        ),
        nachname = FormFieldContainer(
          initialValue: patient?.nachname ?? '',
          validators: [validateRequired],
        ),
        geburtstag = FormFieldContainer(
          initialValue: patient?.geburtstag,
          validators: [validateRequired],
        ),
        titel = FormFieldContainer(initialValue: patient?.titel),
        strasse = FormFieldContainer(initialValue: patient?.strasse),
        hausnummer = FormFieldContainer(initialValue: patient?.hausnummer),
        plz = FormFieldContainer(initialValue: patient?.plz),
        stadt = FormFieldContainer(initialValue: patient?.stadt),
        telMobil = FormFieldContainer(initialValue: patient?.telMobil),
        telFestnetz = FormFieldContainer(initialValue: patient?.telFestnetz),
        email = FormFieldContainer(initialValue: patient?.email),
        super(formKey: GlobalKey());

  final FormFieldContainer<String> vorname;
  final FormFieldContainer<String> nachname;
  final FormFieldContainer<DateTime?> geburtstag;
  final FormFieldContainer<String?> titel;
  final FormFieldContainer<String?> strasse;
  final FormFieldContainer<String?> hausnummer;
  final FormFieldContainer<String?> plz;
  final FormFieldContainer<String?> stadt;
  final FormFieldContainer<String?> telMobil;
  final FormFieldContainer<String?> telFestnetz;
  final FormFieldContainer<String?> email;

  PatientFormDto toFormDto() {
    return PatientFormDto(
      vorname: vorname.value,
      nachname: nachname.value,
      geburtstag: geburtstag.value!,
      titel: titel.value,
      strasse: strasse.value,
      hausnummer: hausnummer.value,
      plz: plz.value,
      stadt: stadt.value,
      telMobil: telMobil.value,
      telFestnetz: telFestnetz.value,
      email: email.value,
    );
  }

  @override
  List<FormFieldContainer<dynamic>> get requiredFields => [
        vorname,
        nachname,
        geburtstag,
      ];
}

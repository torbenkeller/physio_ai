import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/infrastructure/patient_repository.dart';
import 'package:physio_ai/patienten/presentation/patient_form_container.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/patienten/presentation/validation/validators.dart';

class PatientForm extends ConsumerStatefulWidget {
  const PatientForm({
    required this.patient,
    super.key,
  });

  final Patient? patient;

  @override
  ConsumerState<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends ConsumerState<PatientForm> {
  late PatientFormContainer formContainer;

  var _loading = false;

  @override
  void initState() {
    super.initState();
    formContainer = PatientFormContainer();
  }

  @override
  void didUpdateWidget(covariant PatientForm oldWidget) {
    if (oldWidget.patient != widget.patient) {
      formContainer = PatientFormContainer();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final form = Form(
      key: formContainer.formKey,
      child: Column(
        spacing: 16,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: TextFormField(
                  key: formContainer.titel,
                  decoration: const InputDecoration(labelText: 'Titel'),
                  initialValue: widget.patient?.titel,
                ),
              ),
              Flexible(
                flex: 3,
                child: TextFormField(
                  key: formContainer.vorname,
                  decoration: const InputDecoration(labelText: 'Vorname*'),
                  initialValue: widget.patient?.vorname,
                  validator: (value) => validateRequired(value, context),
                ),
              ),
              Flexible(
                flex: 3,
                child: TextFormField(
                  key: formContainer.nachname,
                  decoration: const InputDecoration(labelText: 'Nachname*'),
                  initialValue: widget.patient?.nachname,
                  validator: (value) => validateRequired(value, context),
                ),
              ),
            ],
          ),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: DateTimeFormField(
                  key: formContainer.geburtstag,
                  decoration: const InputDecoration(labelText: 'Geburtstag*'),
                  initialValue: widget.patient?.geburtstag,
                  pickerPlatform: DateTimeFieldPickerPlatform.material,
                  initialPickerDateTime: DateTime(1970),
                  mode: DateTimeFieldPickerMode.date,
                  validator: (value) => validateRequired(value, context),
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  key: formContainer.strasse,
                  decoration: const InputDecoration(labelText: 'Straße'),
                  initialValue: widget.patient?.strasse,
                ),
              ),
              Flexible(
                child: TextFormField(
                  key: formContainer.hausnummer,
                  decoration: const InputDecoration(labelText: 'Hausnummer'),
                  initialValue: widget.patient?.hausnummer,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Flexible(
                child: TextFormField(
                  key: formContainer.plz,
                  decoration: const InputDecoration(labelText: 'PLZ'),
                  initialValue: widget.patient?.plz,
                ),
              ),
              Flexible(
                flex: 2,
                child: TextFormField(
                  key: formContainer.stadt,
                  decoration: const InputDecoration(labelText: 'Stadt'),
                  initialValue: widget.patient?.stadt,
                ),
              ),
            ],
          ),
          TextFormField(
            key: formContainer.email,
            decoration: const InputDecoration(labelText: 'E-Mail'),
            initialValue: widget.patient?.email,
          ),
          TextFormField(
            key: formContainer.telFestnetz,
            decoration: const InputDecoration(labelText: 'Tel. Festnetz'),
            initialValue: widget.patient?.telFestnetz,
          ),
          TextFormField(
            key: formContainer.telMobil,
            decoration: const InputDecoration(labelText: 'Tel. Mobil'),
            initialValue: widget.patient?.telMobil,
          ),
        ],
      ),
    );

    final buttonBar = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 16,
      children: [
        TextButton(
          onPressed: () {
            context.go('/patienten');
          },
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child: const Text('Speichern'),
        ),
      ],
    );

    final content = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: form,
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: buttonBar,
            ),
          ),
        ),
      ],
    );

    if (_loading) {
      return Expanded(
        child: Stack(
          children: [
            ColoredBox(
              color: colorScheme.surfaceDim,
              child: const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
            IgnorePointer(child: content),
          ],
        ),
      );
    }
    return content;
  }

  Future<void> _onSubmit() async {
    if (!formContainer.formKey.currentState!.validate()) {
      return;
    }

    final repo = ref.read(patientRepositoryProvider);

    setState(() {
      _loading = true;
    });

    if (widget.patient == null) {
      await repo.createPatient(formContainer.toFormDto());
    } else {
      await repo.updatePatient(
        widget.patient!.id,
        formContainer.toFormDto(),
      );
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }

    ref.invalidate(patientenProvider);
  }
}

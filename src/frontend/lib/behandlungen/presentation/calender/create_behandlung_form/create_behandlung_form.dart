import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/behandlungen/presentation/calender/create_behandlung_form/create_behandlung_form_container.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_notifier.dart';
import 'package:physio_ai/patienten/presentation/patient_select.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_proxy.dart';
import 'package:physio_ai/shared_kernel/presentation/form_proxy.dart';

class CreateBehandlungForm extends ConsumerStatefulWidget {
  const CreateBehandlungForm({
    required this.startZeit,
    super.key,
  });

  final DateTime startZeit;

  @override
  ConsumerState<CreateBehandlungForm> createState() => _CreateBehandlungFormState();
}

class _CreateBehandlungFormState extends ConsumerState<CreateBehandlungForm> {
  late final CreateBehandlungFormContainer _formContainer;

  @override
  void initState() {
    super.initState();
    _formContainer = CreateBehandlungFormContainer.fromStartZeit(
      startZeit: widget.startZeit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormProxy(
      formContainer: _formContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            children: [
              FormFieldProxy(
                formFieldContainer: _formContainer.startZeit,
                builder: (state) {
                  return DropdownMenu(
                    menuHeight: 400,
                    initialSelection: _formContainer.startZeit.initialValue,
                    dropdownMenuEntries: [
                      for (var i = 0; i < 24 * 2; i++)
                        DropdownMenuEntry(
                          value: DateUtils.dateOnly(
                            widget.startZeit,
                          ).add(Duration(minutes: i * 30)),
                          label: DateFormat.Hm().format(
                            DateUtils.dateOnly(widget.startZeit).add(Duration(minutes: i * 30)),
                          ),
                        ),
                    ],
                  );
                },
              ),
              FormFieldProxy(
                formFieldContainer: _formContainer.endZeit,
                builder: (state) {
                  return DropdownMenu(
                    menuHeight: 400,
                    initialSelection: _formContainer.endZeit.initialValue,
                    onSelected: state.didChange,
                    dropdownMenuEntries: [
                      for (var i = 0; i < 24 * 2; i++)
                        DropdownMenuEntry(
                          value: DateUtils.dateOnly(
                            widget.startZeit,
                          ).add(Duration(minutes: i * 30)),
                          label: DateFormat.Hm().format(
                            DateUtils.dateOnly(widget.startZeit).add(Duration(minutes: i * 30)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          FormFieldProxy(
            formFieldContainer: _formContainer.patient,
            builder: (state) {
              return PatientSelect(
                patient: state.value,
                onPatientSelected: state.didChange,
                errorText: state.errorText,
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _createBehandlung,
              child: const Text('Erstellen'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createBehandlung() async {
    if (!_formContainer.validate()) {
      return;
    }

    final selectedWeek = ref.read(workWeekCalenderSelectedWeekProvider);

    final notifier = ref.read(
      workWeekCalenderBehandlungenProvider(selectedWeek).notifier,
    );

    final creatingDialogNotifier = ref.read(
      workWeekCalenderCreateBehandlungStartZeitProvider.notifier,
    );

    final dto = _formContainer.toFormDto();

    await notifier.erstelleBehandlung(dto);

    creatingDialogNotifier.stopCreating();
  }
}

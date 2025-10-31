import 'package:date_field/date_field.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/rezepte/infrastructure/rezept_repository.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form_container.dart';
import 'package:physio_ai/rezepte/presentation/rezepte_page.dart';

final rezeptFormContainerProvider = Provider.family.autoDispose<RezeptFormContainer, Rezept?>((
  ref,
  rezept,
) {
  final behandlungsarten = ref.watch(behandlungsartenProvider).value!;

  final initialBehandlungsart = behandlungsarten.sort((a, b) => a.name.compareTo(b.name)).first;

  return RezeptFormContainer.fromRezept(
    rezept: rezept,
    initialBehandlungsart: initialBehandlungsart,
  );
});

class RezeptForm extends ConsumerStatefulWidget {
  const RezeptForm({
    this.rezept,
    super.key,
  });

  final Rezept? rezept;

  @override
  ConsumerState<RezeptForm> createState() => _RezeptFormState();
}

class _RezeptFormState extends ConsumerState<RezeptForm> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final behandlungsartenAsync = ref.watch(behandlungsartenProvider);
    final patientenAsync = ref.watch(patientenProvider);

    if (behandlungsartenAsync.isLoading || patientenAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (behandlungsartenAsync.hasError) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Fehler beim Laden der Behandlungsarten'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(behandlungsartenProvider);
                },
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      );
    }

    if (patientenAsync.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Fehler beim Laden der Patientendaten'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(patientenProvider);
              },
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
    }

    final formContainer = ref.watch(rezeptFormContainerProvider(widget.rezept));

    final form = Form(
      key: formContainer.formKey,
      onChanged: () {
        setState(() {});
      },
      child: Column(
        children: [
          _buildPatientSelector(formContainer, patientenAsync.value ?? IList<Patient>(const [])),
          const SizedBox(height: 24),
          DateTimeFormField(
            key: formContainer.ausgestelltAm.key,
            decoration: const InputDecoration(labelText: 'Ausgestellt am*'),
            initialValue: formContainer.ausgestelltAm.initialValue,
            pickerPlatform: DateTimeFieldPickerPlatform.material,
            initialPickerDateTime: DateTime.now(),
            mode: DateTimeFieldPickerMode.date,
            validator: (value) => formContainer.ausgestelltAm.validate(value, context),
          ),
          const SizedBox(height: 24),
          _buildPositionenSection(theme, formContainer),
        ],
      ),
    );

    final buttonBar = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Abbrechen'),
        ),
        const SizedBox(width: 16),
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

  Widget _buildPositionenSection(ThemeData theme, RezeptFormContainer formContainer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Behandlungen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(rezeptFormContainerProvider(widget.rezept)).addPosition();
                setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Hinzufügen'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(51),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(60),
              1: FlexColumnWidth(4),
              2: FixedColumnWidth(100),
              3: FixedColumnWidth(40),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Anzahl',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Behandlungsart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Gesamtpreis',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              for (var i = 0; i < formContainer.positionen.length; i++)
                _buildPositionRow(i, theme, formContainer),
              _buildTableFooterRow(formContainer),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildPositionRow(int index, ThemeData theme, RezeptFormContainer formContainer) {
    final position = formContainer.positionen[index];

    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(25),
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: TextFormField(
            key: position.anzahl.key,
            initialValue: position.anzahl.initialValue,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            validator: (value) => position.anzahl.validate(value, context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: FormField<Behandlungsart>(
            key: position.behandlungsart.key,
            validator: (value) => position.behandlungsart.validate(value, context),
            initialValue: position.behandlungsart.initialValue,
            builder: (state) {
              return MenuAnchor(
                builder: (context, controller, child) {
                  return InkWell(
                    onTap: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration().applyDefaults(theme.inputDecorationTheme),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.value?.name ?? 'Bitte wählen',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  );
                },
                menuChildren:
                    (ref.watch(behandlungsartenProvider).value ?? IList<Behandlungsart>(const []))
                        .map((behandlungsart) {
                          return MenuItemButton(
                            onPressed: () {
                              state.didChange(behandlungsart);
                            },
                            child: Text(behandlungsart.name),
                          );
                        })
                        .toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            NumberFormat.currency(
              decimalDigits: 2,
              symbol: '€',
            ).format(position.price),
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () {
              ref.read(rezeptFormContainerProvider(widget.rezept)).removePosition(index);
              setState(() {});
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableFooterRow(RezeptFormContainer formContainer) {
    return TableRow(
      children: [
        const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            'Gesamtsumme:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            '${formContainer.price.toStringAsFixed(2)} €',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(),
      ],
    );
  }

  Widget _buildPatientSelector(RezeptFormContainer formContainer, IList<Patient> patienten) {
    return FormField<String?>(
      key: formContainer.patientId.key,
      initialValue: formContainer.patientId.initialValue,
      validator: (value) => formContainer.patientId.validate(value, context),
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Patient*',
            errorText: state.errorText,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              isExpanded: true,
              value: state.value,
              hint: const Text('Bitte wählen Sie einen Patienten aus'),
              onChanged: (newValue) {
                state.didChange(newValue);
              },
              items: patienten.map((patient) {
                return DropdownMenuItem<String>(
                  value: patient.id,
                  child: Text(
                    '${patient.fullName} (geb. ${DateFormat('dd.MM.yyyy').format(patient.geburtstag)})',
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSubmit() async {
    final formContainer = ref.read(rezeptFormContainerProvider(widget.rezept));

    if (!formContainer.formKey.currentState!.validate()) {
      return;
    }

    final repo = ref.read(rezeptRepositoryProvider);

    setState(() {
      _loading = true;
    });

    try {
      final rezeptDto = formContainer.toFormDto();

      if (widget.rezept == null) {
        await repo.createRezept(rezeptDto);
      } else {
        await repo.updateRezept(widget.rezept!.id, rezeptDto);
      }

      if (mounted) {
        context.go('/rezepte');
        ref.invalidate(rezepteProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}

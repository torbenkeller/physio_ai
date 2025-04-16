import 'package:date_field/date_field.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/patienten/presentation/validation/validators.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form_container.dart';
import 'package:physio_ai/rezepte/rezept.dart';
import 'package:physio_ai/rezepte/rezept_repository.dart';
import 'package:physio_ai/rezepte/rezepte_page.dart';

final rezeptFormContainerProvider =
    Provider.family.autoDispose<RezeptFormContainer, Rezept?>((ref, rezept) {
  return RezeptFormContainer.fromRezept(rezept);
});

final rezeptFormStateProvider =
    Provider.family.autoDispose<RezeptFormState, Rezept?>((ref, rezept) {
  final formContainer = ref.watch(rezeptFormContainerProvider(rezept));
  return formContainer.toFormState();
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

    if (behandlungsartenAsync.isLoading) {
      return Center(
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

    final formContainer = ref.watch(rezeptFormContainerProvider(widget.rezept));

    final form = Form(
      key: formContainer.formKey,
      onChanged: () {
        ref.invalidate(rezeptFormStateProvider(widget.rezept));
      },
      child: Column(
        children: [
          DateTimeFormField(
            key: formContainer.ausgestelltAm,
            decoration: const InputDecoration(labelText: 'Ausgestellt am*'),
            initialValue: widget.rezept?.ausgestelltAm ?? DateTime.now(),
            pickerPlatform: DateTimeFieldPickerPlatform.material,
            initialPickerDateTime: DateTime.now(),
            mode: DateTimeFieldPickerMode.date,
            validator: (value) => validateRequired(value, context),
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
            context.go('/rezepte');
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
    final formState = ref.watch(rezeptFormStateProvider(widget.rezept));

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

                ref.invalidate(rezeptFormStateProvider(widget.rezept));
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
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
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
              _buildTableFooterRow(formState),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildPositionRow(int index, ThemeData theme, RezeptFormContainer formContainer) {
    final position = formContainer.positionen[index];
    final formState = ref.watch(rezeptFormStateProvider(widget.rezept));
    final behandlungsarten = ref.watch(behandlungsartenProvider).value ?? IList<Behandlungsart>([]);

    final initialAnzahl = widget.rezept?.positionen.getOrNull(index)?.anzahl.toString() ?? '1';
    final initialBehandlungsart = widget.rezept?.positionen.getOrNull(index)?.behandlungsart ??
        (behandlungsarten.isNotEmpty ? behandlungsarten.first : null);

    final positionPrice = formState.calculatePositionPrice(index);

    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: TextFormField(
            key: position.anzahl,
            initialValue: initialAnzahl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            validator: (value) => validateRequired(value, context),
            onChanged: (_) {
              ref.invalidate(rezeptFormStateProvider(widget.rezept));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: FormField<Behandlungsart>(
            key: position.behandlungsart,
            validator: (value) => value == null ? 'Bitte wählen Sie eine Behandlungsart' : null,
            initialValue: initialBehandlungsart,
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
                    (ref.watch(behandlungsartenProvider).value ?? IList<Behandlungsart>([]))
                        .map((behandlungsart) {
                  return MenuItemButton(
                    onPressed: () {
                      state.didChange(behandlungsart);
                      ref.invalidate(rezeptFormStateProvider(widget.rezept));
                    },
                    child: Text(behandlungsart.name),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            '${positionPrice.toStringAsFixed(2)} €',
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

              ref.invalidate(rezeptFormStateProvider(widget.rezept));
              setState(() {});
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableFooterRow(RezeptFormState formState) {
    final totalPrice = formState.calculateTotalPrice();

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
            '${totalPrice.toStringAsFixed(2)} €',
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
      final rezeptCreateDto = formContainer.toRezeptCreateDto();

      if (widget.rezept == null) {
        await repo.createRezept(rezeptCreateDto);
      } else {
        await repo.createRezept(rezeptCreateDto);
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

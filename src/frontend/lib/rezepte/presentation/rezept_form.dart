import 'package:date_field/date_field.dart';
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

  // Hardcoded Behandlungsarten based on the database
  final List<Behandlungsart> _behandlungsarten = [
    const Behandlungsart(
        id: 'cfdc701b-c5f9-4000-8d4b-85ed7aa7a141',
        name: 'Klassische Massagetherapie',
        preis: 22.84),
    const Behandlungsart(
        id: '2a4f9ebd-9963-4c60-a7ec-5591cbf7f3b3',
        name: 'Manuelle Lymphdrainage (30 Min.)',
        preis: 38),
    const Behandlungsart(
        id: 'e9107b42-91da-47a8-9fcc-7e1fdf69b058',
        name: 'Manuelle Lymphdrainage (45 Min.)',
        preis: 56.98),
    const Behandlungsart(
        id: '398df86a-51ef-4f12-8fbc-40377230dcbc',
        name: 'Manuelle Lymphdrainage (60 Min.)',
        preis: 75.99),
    const Behandlungsart(
        id: '1b102da5-b8b4-4e78-8a01-1f9c8552cdc5', name: 'Krankengymnastik', preis: 31.3),
    const Behandlungsart(
        id: 'adf3630e-7706-4aca-b030-5326f164c959',
        name: 'Krankengymnastik Doppelbehandlung',
        preis: 62.6),
    const Behandlungsart(
        id: 'c378461c-f410-4655-a62d-b2d4124ec38b',
        name: 'Krankengymnastik am Gerät',
        preis: 58.94),
    const Behandlungsart(
        id: 'a5422b49-88b0-4e52-915e-f159261c711f', name: 'Krankengymnastik ZNS', preis: 49.71),
    const Behandlungsart(
        id: '65cbab03-f884-4a2a-a510-0fba056224e9',
        name: 'Krankengymnastik ZNS Doppelbehandlung',
        preis: 99.42),
    const Behandlungsart(
        id: 'f5571a9f-c679-4422-8750-5faa760e8ea7', name: 'Manuelle Therapie', preis: 37.6),
    const Behandlungsart(
        id: 'e48f0626-6ecd-4d26-8909-bd1e41508e2e',
        name: 'Manuelle Therapie Doppelbehandlung',
        preis: 75.2),
    const Behandlungsart(
        id: '43c27a35-612b-4297-98da-2bb93c24f723', name: 'Wärmepackung', preis: 17.07),
    const Behandlungsart(
        id: 'e70d961c-80fa-461d-9ecd-17852cc052d0', name: 'Atlastherapie', preis: 290),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Get form container from provider in build method
    final formContainer = ref.watch(rezeptFormContainerProvider(widget.rezept));

    final form = Form(
      key: formContainer.formKey,
      onChanged: () {
        ref.invalidate(rezeptFormStateProvider(widget.rezept));
      },
      child: Column(
        children: [
          // Removed hidden preisGesamt field

          // Only show the date field
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
          _buildPositionenSection(formContainer),
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

  Widget _buildPositionenSection(RezeptFormContainer formContainer) {
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
                // First add the position
                ref.read(rezeptFormContainerProvider(widget.rezept)).addPosition();

                // Then force a rebuild to show the new position
                ref.invalidate(rezeptFormStateProvider(widget.rezept));
                setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Hinzufügen'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Use native Table widget for proper alignment of columns
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(60), // Anzahl
              1: FlexColumnWidth(4), // Behandlungsart
              2: FlexColumnWidth(2), // Gesamtpreis
              3: FixedColumnWidth(40), // Delete button
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  )),
                ),
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

              // Data rows - one for each position
              for (var i = 0; i < formContainer.positionen.length; i++)
                _buildPositionRow(i, formContainer),

              // Footer row with total - integrated directly into the table
              _buildTableFooterRow(formState),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildPositionRow(int index, RezeptFormContainer formContainer) {
    final position = formContainer.positionen[index];
    final formState = ref.watch(rezeptFormStateProvider(widget.rezept));

    final initialAnzahl = widget.rezept?.positionen.getOrNull(index)?.anzahl.toString() ?? '1';
    final initialBehandlungsart =
        widget.rezept?.positionen.getOrNull(index)?.behandlungsart ?? _behandlungsarten.first;

    // Calculate the position price
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
        // Quantity input
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: TextFormField(
            key: position.anzahl,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              border: OutlineInputBorder(),
            ),
            initialValue: initialAnzahl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            validator: (value) => validateRequired(value, context),
            onChanged: (_) {
              // Force update price calculations
              ref.invalidate(rezeptFormStateProvider(widget.rezept));
            },
          ),
        ),

        // Treatment type dropdown with MenuAnchor
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: FormField<Behandlungsart>(
            key: position.behandlungsart,
            validator: (value) => value == null ? 'Bitte wählen Sie eine Behandlungsart' : null,
            initialValue: initialBehandlungsart,
            builder: (state) {
              return MenuAnchor(
                builder: (context, controller, child) {
                  return OutlinedButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                menuChildren: _behandlungsarten.map((behandlungsart) {
                  return MenuItemButton(
                    onPressed: () {
                      state.didChange(behandlungsart);
                      // Force update price calculations
                      ref.invalidate(rezeptFormStateProvider(widget.rezept));
                      setState(() {});
                    },
                    child: Text(behandlungsart.name),
                  );
                }).toList(),
              );
            },
          ),
        ),

        // Position total price
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            '${positionPrice.toStringAsFixed(2)} €',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Delete button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () {
              // Remove the position
              ref.read(rezeptFormContainerProvider(widget.rezept)).removePosition(index);

              // Force a rebuild
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      children: [
        // Empty cell for Anzahl column
        const SizedBox(),

        // Gesamtsumme label
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

        // Total price amount
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

        // Empty cell for Delete button column
        const SizedBox(),
      ],
    );
  }

  Future<void> _onSubmit() async {
    final formContainer = ref.read(rezeptFormContainerProvider(widget.rezept));
    final formState = ref.read(rezeptFormStateProvider(widget.rezept));

    // Get the total price from calculated values

    if (!formContainer.formKey.currentState!.validate()) {
      return;
    }

    final repo = ref.read(rezeptRepositoryProvider);

    setState(() {
      _loading = true;
    });

    try {
      // Use the form container to create the properly formatted request DTO
      final rezeptCreateDto = formContainer.toRezeptCreateDto();

      if (widget.rezept == null) {
        // Creating a new rezept
        await repo.createRezept(rezeptCreateDto);
      } else {
        // When editing, still use the same format but might need adjustments
        // for a real update endpoint
        await repo.createRezept(rezeptCreateDto);
      }

      if (mounted) {
        context.go('/rezepte');
        // Invalidate the rezepte provider to refresh the list
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

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/patienten/presentation/validation/validators.dart';
import 'package:physio_ai/rezepte/rezept.dart';
import 'package:physio_ai/rezepte/rezept_repository.dart';
import 'package:physio_ai/rezepte/rezepte_page.dart';
import 'package:physio_ai/rezepte/presentation/rezept_form_container.dart';

class RezeptForm extends ConsumerStatefulWidget {
  const RezeptForm({
    required this.rezept,
    super.key,
  });

  final Rezept? rezept;

  @override
  ConsumerState<RezeptForm> createState() => _RezeptFormState();
}

class _RezeptFormState extends ConsumerState<RezeptForm> {
  late RezeptFormContainer formContainer;
  var _loading = false;

  @override
  void initState() {
    super.initState();
    formContainer = RezeptFormContainer();
    // Add an initial position if creating a new Rezept
    if (widget.rezept == null) {
      formContainer.addPosition();
    }
  }

  @override
  void didUpdateWidget(covariant RezeptForm oldWidget) {
    if (oldWidget.rezept != widget.rezept) {
      formContainer = RezeptFormContainer();
      // Add an initial position if creating a new Rezept
      if (widget.rezept == null) {
        formContainer.addPosition();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final form = Form(
      key: formContainer.formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DateTimeFormField(
                  key: formContainer.ausgestelltAm,
                  decoration: const InputDecoration(labelText: 'Ausgestellt am*'),
                  initialValue: widget.rezept?.ausgestelltAm ?? DateTime.now(),
                  pickerPlatform: DateTimeFieldPickerPlatform.material,
                  initialPickerDateTime: DateTime.now(),
                  mode: DateTimeFieldPickerMode.date,
                  validator: (value) => validateRequired(value, context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  key: formContainer.preisGesamt,
                  decoration: const InputDecoration(labelText: 'Gesamtpreis*'),
                  initialValue: widget.rezept?.preisGesamt.toString() ?? '0.0',
                  keyboardType: TextInputType.number,
                  validator: (value) => validateRequired(value, context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPositionenSection(),
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

  Widget _buildPositionenSection() {
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
                setState(() {
                  formContainer.addPosition();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Hinzufügen'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(
          formContainer.positionen.length,
          (index) => _buildPositionFormField(index),
        ),
      ],
    );
  }

  Widget _buildPositionFormField(int index) {
    final position = formContainer.positionen[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Position ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      formContainer.removePosition(index);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    key: position.anzahl,
                    decoration: const InputDecoration(labelText: 'Anzahl*'),
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    validator: (value) => validateRequired(value, context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    key: position.behandlungsartName,
                    decoration: const InputDecoration(labelText: 'Behandlungsart*'),
                    validator: (value) => validateRequired(value, context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    key: position.preis,
                    decoration: const InputDecoration(labelText: 'Preis*'),
                    initialValue: '0.0',
                    keyboardType: TextInputType.number,
                    validator: (value) => validateRequired(value, context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!formContainer.formKey.currentState!.validate()) {
      return;
    }

    final repo = ref.read(rezeptRepositoryProvider);

    setState(() {
      _loading = true;
    });

    try {
      final rezept = formContainer.toRezept();
      await repo.createRezept(rezept);
      
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
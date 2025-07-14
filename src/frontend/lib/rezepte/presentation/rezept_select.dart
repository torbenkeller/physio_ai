import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/presentation/rezepte_page.dart';
import 'package:physio_ai/shared_kernel/presentation/anchored_overlay.dart';
import 'package:physio_ai/shared_kernel/presentation/full_screen_overlay.dart';
import 'package:physio_ai/shared_kernel/utils.dart';

class RezeptSelect extends StatefulWidget {
  final ValueChanged<Rezept?> onRezeptSelected;

  final Rezept? rezept;

  final String? errorText;

  final String patientId;

  const RezeptSelect({
    required this.onRezeptSelected,
    required this.patientId,
    this.rezept,
    this.errorText,
    super.key,
  });

  @override
  State<RezeptSelect> createState() => _RezeptSelectState();
}

class _RezeptSelectState extends State<RezeptSelect> {
  bool _isOverlayShowing = false;
  bool _isHovering = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final selectContent = InkWell(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      onHover: (isHovering) {
        setState(() {
          _isHovering = isHovering;
        });
      },
      onTap: () {
        setState(() {
          _isOverlayShowing = true;
        });
      },
      child: InputDecorator(
        isFocused: _isFocused,
        isHovering: _isHovering,
        isEmpty: widget.rezept == null,
        decoration: InputDecoration(
          labelText: 'Rezept',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: 'Rezept auswählen...',
          suffixIcon: widget.rezept == null
              ? const Icon(Icons.arrow_drop_down)
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      widget.onRezeptSelected(null);
                    });
                  },
                ),
          errorText: widget.errorText,
        ),
        child: widget.rezept?.let(
          (rezept) => ListTile(
            mouseCursor: MouseCursor.uncontrolled,
            contentPadding: EdgeInsets.zero,
            title: Text('Ausgestellt am: ${DateFormat.yMd().format(rezept.ausgestelltAm)}'),
            subtitle: Text(
              rezept.positionen.map((p) => '${p.anzahl}x ${p.behandlungsart.name}').join('\n'),
            ),
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (_, constraints) {
        return FullScreenOverlay(
          isShowing: _isOverlayShowing,
          overlayContent: GestureDetector(
            onTap: () {
              setState(() {
                _isOverlayShowing = false;
              });
            },
          ),
          child: AnchoredOverlay(
            isShowing: _isOverlayShowing,
            overlayConstraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
            ),
            anchor: selectContent,
            overlayOffset: const Offset(0, -16),
            overlayContent: _RezeptOverlay(
              patientId: widget.patientId,
              rezept: widget.rezept,
              onRezeptSelected: (rezept) {
                setState(() {
                  _isOverlayShowing = false;
                });
                widget.onRezeptSelected(rezept);
              },
            ),
          ),
        );
      },
    );
  }
}

class _RezeptOverlay extends ConsumerWidget {
  final Rezept? rezept;

  final ValueChanged<Rezept?> onRezeptSelected;

  final String patientId;

  const _RezeptOverlay({
    required this.onRezeptSelected,
    required this.rezept,
    required this.patientId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rezepte = ref.watch(rezepteOfPatientProvider(patientId));

    final content = switch (rezepte) {
      AsyncData<IList<Rezept>>(value: final data) =>
        data.isEmpty
            ? Center(
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Keine Rezepte gefunden.'),
                    ElevatedButton(
                      child: const Text('Schließen'),
                      onPressed: () {
                        onRezeptSelected(null);
                      },
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final rezept = data[index];
                    return ListTile(
                      title: Text(
                        'Ausgestellt am: ${DateFormat.yMd().format(rezept.ausgestelltAm)}',
                      ),
                      subtitle: Text(
                        rezept.positionen
                            .map((p) => '${p.anzahl}x ${p.behandlungsart.name}')
                            .join('\n'),
                      ),
                      onTap: () {
                        onRezeptSelected(rezept);
                      },
                    );
                  },
                ),
              ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError() => const Center(child: Text('Fehler beim Laden der Rezepte.')),
    };

    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 64 * 5,
        ),
        child: content,
      ),
    );
  }
}

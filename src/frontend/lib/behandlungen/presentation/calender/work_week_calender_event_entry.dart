import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:intl/intl.dart';

enum PopUpLocation {
  topRight,
  topLeft,
}

class WorkWeekCalenderEventEntry extends StatefulWidget {
  const WorkWeekCalenderEventEntry({
    required this.title,
    required this.startZeit,
    required this.endZeit,
    this.isDragged = false,
    required this.popupMenu,
    this.popUpLocation = PopUpLocation.topRight,
    this.showPopupMenu = true,
    this.onClosePopupMenu,
    super.key,
  });

  final String title;
  final DateTime startZeit;
  final DateTime endZeit;
  final bool isDragged;
  final Widget popupMenu;
  final PopUpLocation popUpLocation;
  final bool showPopupMenu;
  final VoidCallback? onClosePopupMenu;

  @override
  State<WorkWeekCalenderEventEntry> createState() => _WorkWeekCalenderEventEntryState();
}

class _WorkWeekCalenderEventEntryState extends State<WorkWeekCalenderEventEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      value: 0,
      vsync: this,
    );

    if (widget.showPopupMenu) {
      animationController.animateTo(1, curve: Curves.easeOut);
    }
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WorkWeekCalenderEventEntry oldWidget) {
    if (widget.showPopupMenu != oldWidget.showPopupMenu) {
      if (widget.showPopupMenu) {
        animationController.animateTo(1, curve: Curves.easeOut);
        _focusNode.requestFocus();
      } else {
        animationController.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final eventEntry = RawWorkWeekCalenderEventEntry(
      title: widget.title,
      startZeit: widget.startZeit,
      endZeit: widget.endZeit,
      isDragged: widget.isDragged,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // If constraints.maxWidth < 130: Open new page instead of popup

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return PortalTarget(
              anchor: switch (widget.popUpLocation) {
                PopUpLocation.topRight => Aligned(
                  target: Alignment.topRight,
                  follower: Alignment.topLeft,
                  offset: Offset(constraints.maxWidth / 3 * (animationController.value - 1), 0),
                ),
                PopUpLocation.topLeft => Aligned(
                  target: Alignment.topLeft,
                  follower: Alignment.topRight,
                  offset: Offset(-constraints.maxWidth / 3 * (animationController.value - 1), 0),
                ),
              },
              visible: widget.showPopupMenu,
              portalFollower: Focus(
                focusNode: _focusNode,
                onKeyEvent: (focus, event) {
                  if (event.logicalKey == LogicalKeyboardKey.escape) {
                    if (widget.showPopupMenu) {
                      animationController.reset();
                      widget.onClosePopupMenu?.call();
                      return KeyEventResult.handled;
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: widget.popupMenu,
              ),
              child: child!,
            );
          },
          child: eventEntry,
        );
      },
    );
  }
}

class RawWorkWeekCalenderEventEntry extends StatelessWidget {
  const RawWorkWeekCalenderEventEntry({
    required this.title,
    required this.startZeit,
    required this.endZeit,
    this.isDragged = false,
    super.key,
  });

  final String title;
  final DateTime startZeit;
  final DateTime endZeit;
  final bool isDragged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = isDragged ? colorScheme.primary.withAlpha(51) : colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4, right: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${DateFormat('HH:mm').format(startZeit)} - ${DateFormat('HH:mm').format(endZeit)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w300,
                ),
                overflow: TextOverflow.clip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

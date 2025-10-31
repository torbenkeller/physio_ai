import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:intl/intl.dart';

enum PopUpLocation {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft;

  static PopUpLocation fromStartZeit(DateTime startZeit) {
    if (startZeit.weekday <= 3) {
      return startZeit.hour < 16 ? PopUpLocation.topRight : PopUpLocation.bottomRight;
    }
    return startZeit.hour < 16 ? PopUpLocation.topLeft : PopUpLocation.bottomLeft;
  }
}

class WorkWeekCalenderEventEntry extends StatefulWidget {
  const WorkWeekCalenderEventEntry({
    required this.title,
    required this.startZeit,
    required this.endZeit,
    required this.popupMenu,
    this.isDragged = false,
    this.popUpLocation = PopUpLocation.topRight,
    this.showPopupMenu = true,
    this.onClosePopupMenu,
    this.onOpenPopupMenu,
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
  final VoidCallback? onOpenPopupMenu;

  @override
  State<WorkWeekCalenderEventEntry> createState() => _WorkWeekCalenderEventEntryState();
}

class _WorkWeekCalenderEventEntryState extends State<WorkWeekCalenderEventEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  final _popupFocusNode = FocusNode();

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
    _popupFocusNode.requestFocus();
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
        _popupFocusNode.requestFocus();
      } else {
        animationController.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final eventEntry = Focus(
      canRequestFocus: true,
      onKeyEvent: (focusNode, key) {
        if (key is KeyDownEvent && key.logicalKey == LogicalKeyboardKey.escape) {
          if (widget.showPopupMenu) {
            widget.onClosePopupMenu?.call();
            return KeyEventResult.handled;
          } else {
            focusNode.unfocus();
            return KeyEventResult.handled;
          }
        }

        if (widget.showPopupMenu) {
          return KeyEventResult.ignored;
        }

        if (key is KeyDownEvent &&
            (key.logicalKey == LogicalKeyboardKey.space ||
                key.logicalKey == LogicalKeyboardKey.enter)) {
          widget.onOpenPopupMenu?.call();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: RawWorkWeekCalenderEventEntry(
        title: widget.title,
        startZeit: widget.startZeit,
        endZeit: widget.endZeit,
        isDragged: widget.isDragged,
        isPopupVisible: widget.showPopupMenu,
      ),
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
                PopUpLocation.bottomRight => Aligned(
                  target: Alignment.bottomRight,
                  follower: Alignment.bottomLeft,
                  offset: Offset(constraints.maxWidth / 3 * (animationController.value - 1), 0),
                ),
                PopUpLocation.bottomLeft => Aligned(
                  target: Alignment.bottomLeft,
                  follower: Alignment.bottomRight,
                  offset: Offset(-constraints.maxWidth / 3 * (animationController.value - 1), 0),
                ),
              },
              visible: widget.showPopupMenu,
              portalFollower: Focus(
                focusNode: _popupFocusNode,
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
    this.isPopupVisible = false,
    this.isDragged = false,
    super.key,
  });

  final String title;
  final DateTime startZeit;
  final DateTime endZeit;
  final bool isDragged;
  final bool isPopupVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasFocus = Focus.of(context).hasFocus;

    final color = isDragged
        ? colorScheme.primary.withAlpha(51)
        : hasFocus || isPopupVisible
        ? colorScheme.primaryContainer
        : colorScheme.primary;

    final textColor = hasFocus || isPopupVisible
        ? colorScheme.onPrimaryContainer
        : colorScheme.onPrimary;

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
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${DateFormat('HH:mm').format(startZeit)} - ${DateFormat('HH:mm').format(endZeit)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: textColor,
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

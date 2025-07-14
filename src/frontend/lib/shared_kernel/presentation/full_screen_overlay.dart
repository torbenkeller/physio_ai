import 'package:flutter/material.dart';

class FullScreenOverlay extends StatefulWidget {
  const FullScreenOverlay({
    required this.child,
    required this.overlayContent,
    this.isShowing = false,
    super.key,
  });

  final bool isShowing;
  final Widget child;
  final Widget overlayContent;

  @override
  State<FullScreenOverlay> createState() => _FullScreenOverlayState();
}

class _FullScreenOverlayState extends State<FullScreenOverlay> {
  final OverlayPortalController _overlayPortalController = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isShowing) {
        _overlayPortalController.show();
      }
    });
  }

  @override
  void didUpdateWidget(FullScreenOverlay oldWidget) {
    if (widget.isShowing && !_overlayPortalController.isShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayPortalController.show();
      });
    }

    if (!widget.isShowing && _overlayPortalController.isShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayPortalController.hide();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_overlayPortalController.isShowing) {
      _overlayPortalController.hide();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: _overlayPortalController,
      overlayChildBuilder: (_, _) {
        return Positioned.fill(
          child: widget.overlayContent,
        );
      },
      child: widget.child,
    );
  }
}

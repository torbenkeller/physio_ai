import 'package:flutter/material.dart';

class AnchoredOverlay extends StatefulWidget {
  const AnchoredOverlay({
    required this.anchor,
    required this.overlayContent,
    required this.overlaySize,
    this.overlayOffset = Offset.zero,
    this.isShowing = false,
    super.key,
  });

  final bool isShowing;
  final Widget anchor;
  final Widget overlayContent;
  final Size overlaySize;
  final Offset overlayOffset;

  @override
  State<AnchoredOverlay> createState() => _AnchoredOverlayState();
}

class _AnchoredOverlayState extends State<AnchoredOverlay> {
  final OverlayPortalController _overlayPortalController = OverlayPortalController();
  final _anchorKey = GlobalKey();

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
  void didUpdateWidget(AnchoredOverlay oldWidget) {
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
      key: _anchorKey,
      controller: _overlayPortalController,
      overlayChildBuilder: (_, info) {
        final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;

        final anchor = _anchorKey.currentContext!.findRenderObject()! as RenderBox;
        final anchorPosition = anchor.localToGlobal(Offset.zero, ancestor: overlay);

        return Positioned(
          width: widget.overlaySize.width,
          height: widget.overlaySize.height,
          left: anchorPosition.dx + widget.overlayOffset.dx,
          top: anchorPosition.dy + widget.overlayOffset.dy,
          child: SizedBox.fromSize(
            size: widget.overlaySize,
            child: widget.overlayContent,
          ),
        );
      },
      child: widget.anchor,
    );
  }
}

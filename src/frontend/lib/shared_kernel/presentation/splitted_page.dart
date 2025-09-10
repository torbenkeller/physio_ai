import 'package:flutter/material.dart';

class SplittedPage extends StatelessWidget {
  const SplittedPage({
    required this.leftPane,
    this.rightPane,
    super.key,
  });

  final Widget leftPane;
  final Widget? rightPane;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FocusTraversalGroup(
            child: leftPane,
          ),
        ),
        Expanded(
          child: FocusTraversalGroup(
            child: rightPane ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

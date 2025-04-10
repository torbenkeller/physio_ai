import 'package:flutter/material.dart';
import 'package:physio_ai/generated/l10n.dart';

String? validateRequired(Object? value, BuildContext context) {
  if (value == null || value is String && value.isEmpty) {
    return PhysioAiLocalizations.of(context).validateRequiredError;
  }
  return null;
}

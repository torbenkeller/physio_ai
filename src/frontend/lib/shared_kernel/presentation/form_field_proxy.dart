import 'package:flutter/material.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_container.dart';

class FormFieldProxy<T> extends StatelessWidget {
  const FormFieldProxy({
    required this.builder,
    required this.formFieldContainer,
    this.enabled = true,
    this.autovalidateMode,
    this.errorBuilder,
    this.forceErrorText,
    this.onSaved,
    this.restorationId,
    super.key,
  });

  final FormFieldBuilder<T> builder;

  final FormFieldContainer<T> formFieldContainer;

  final bool enabled;

  final AutovalidateMode? autovalidateMode;

  final FormFieldErrorBuilder? errorBuilder;

  final String? forceErrorText;

  final FormFieldSetter<T>? onSaved;

  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: formFieldContainer.key,
      validator: (value) => formFieldContainer.validate(value, context),
      initialValue: formFieldContainer.initialValue,
      builder: builder,
      autovalidateMode: autovalidateMode,
      errorBuilder: errorBuilder,
      enabled: enabled,
      forceErrorText: forceErrorText,
      onSaved: onSaved,
      restorationId: restorationId,
    );
  }
}

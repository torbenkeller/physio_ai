import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class FormContainer {
  const FormContainer({required this.formKey});

  final GlobalKey<FormState> formKey;

  List<GlobalKey<FormFieldState<dynamic>>> get requiredFields;

  bool validate() {
    return formKey.currentState!.validate();
  }

  bool get areRequiredFieldsFilled {
    return requiredFields.every((field) {
      final value = field.currentState!.value;

      if (value is String) {
        return value.isNotEmpty;
      }

      return value != null;
    });
  }
}

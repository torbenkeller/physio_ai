import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:physio_ai/shared_kernel/presentation/form_field_container.dart';

abstract class FormContainer {
  const FormContainer({required this.formKey});

  final GlobalKey<FormState> formKey;

  List<FormFieldContainer<dynamic>> get requiredFields;

  bool validate() {
    return formKey.currentState!.validate();
  }

  bool get areRequiredFieldsFilled {
    return requiredFields.every((field) {
      final value = field.value;

      if (value == null) {
        return false;
      }

      if (value is String) {
        return value.isNotEmpty;
      }

      return true;
    });
  }
}

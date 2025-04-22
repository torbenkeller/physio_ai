import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

typedef Validator<T> = String? Function(T? value, BuildContext context);

class FormFieldContainer<T> {
  FormFieldContainer({
    required this.initialValue,
    List<Validator<T>> validators = const [],
  })  : key = GlobalKey<FormFieldState<T>>(),
        _validators = validators.lock;

  final T initialValue;
  final GlobalKey<FormFieldState<T>> key;
  final IList<Validator<T>> _validators;

  String? validate(T? value, BuildContext context) {
    for (final validator in _validators) {
      final error = validator(value, context);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  T get value {
    final state = key.currentState;
    if (state != null) {
      return state.value as T;
    } else {
      return initialValue;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:physio_ai/shared_kernel/presentation/form_container.dart';

class FormProxy extends StatefulWidget {
  const FormProxy({
    required this.formContainer,
    required this.child,
    this.onChanged,
    this.onRequiredFieldsFilled,
    this.autovalidateMode,
    this.canPop,
    this.onPopInvokedWithResult,
    super.key,
  });

  final FormContainer formContainer;

  final Widget child;

  final VoidCallback? onChanged;

  final ValueChanged<bool>? onRequiredFieldsFilled;

  final AutovalidateMode? autovalidateMode;

  final bool? canPop;

  final PopInvokedWithResultCallback<Object?>? onPopInvokedWithResult;

  @override
  State<FormProxy> createState() => _FormProxyState();
}

class _FormProxyState extends State<FormProxy> {
  bool areRequiredFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      areRequiredFieldsFilled = widget.formContainer.areRequiredFieldsFilled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formContainer.formKey,
      autovalidateMode: widget.autovalidateMode,
      onChanged: () {
        areRequiredFieldsFilled = widget.formContainer.areRequiredFieldsFilled;
        widget.onRequiredFieldsFilled?.call(areRequiredFieldsFilled);
        widget.onChanged?.call();
      },
      canPop: widget.canPop,
      onPopInvokedWithResult: widget.onPopInvokedWithResult,
      child: widget.child,
    );
  }
}

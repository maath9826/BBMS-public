import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool isEnabled;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool isOptional;
  final String? errorMessage;
  final bool isTextArea;
  final void Function(String)? onChange;
  final void Function(String)? onSubmitted;

  const CustomField({
    required this.label,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.isEnabled = true,
    this.keyboardType,
    this.isOptional = false,
    this.errorMessage,
    this.onChange,
    this.onSubmitted, this.isTextArea  = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isTextArea? TextInputType.multiline : null,
      textInputAction: isTextArea? TextInputAction.newline : null,
      maxLines: isTextArea? 5 : 1,
      enabled: isEnabled,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(fontSize: 14),
      controller: controller,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 18,horizontal: 16),
        labelText: isOptional ? label + '(optional)' : label,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0.5,color: Colors.black45)),
        errorText: errorMessage,
      ),
      onChanged: onChange,
      obscureText: isPassword,
      validator: isOptional
          ? (_) => null
          : validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'this field is required';
                }
              },
    );
  }
}

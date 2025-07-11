import 'package:flutter/material.dart';

// Style commun pour tous les champs
final _inputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
);

class TextInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const TextInput({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: _inputDecoration.copyWith(labelText: label),
    );
  }
}

class PhoneInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function(String)? onChanged;

  const PhoneInput({
    super.key,
    this.label = 'Numéro de téléphone',
    this.controller,
    this.validator,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      decoration: _inputDecoration.copyWith(labelText: label),
    );
  }
}

class PasswordInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function(String)? onChanged;

  const PasswordInput({
    super.key,
    this.label = 'Mot de passe',
    this.controller,
    this.validator,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
      obscureText: true,
      keyboardType: TextInputType.text,
      onChanged: onChanged,
      decoration: _inputDecoration.copyWith(labelText: label),
    );
  }
}

import 'package:ecofier_viz/core/constants.dart';
import 'package:flutter/material.dart';

class AppTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? description;
  final String? initialValue;
  final double width;
  final Icon? prefixIcon;
  final bool isReadOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AppTextInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.description,
    this.width = 256,
    this.prefixIcon,
    this.validator,
    required this.isReadOnly,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(description!),
          ),
        SizedBox(
          width: width,
          child: TextFormField(
            onChanged: onChanged,
            initialValue: initialValue,
            readOnly: isReadOnly,
            controller: controller,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            keyboardType: keyboardType,
            decoration: const InputDecoration().copyWith(
              prefixIcon: prefixIcon,
              hintText: labelText,
              labelText: labelText,
            ),
          ),
        ),
      ],
    );
  }
}

class AppPasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? description;
  final double width;
  final String? Function(String?)? validatePassword;

  const AppPasswordInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.description,
    this.width = 256,
    this.validatePassword,
  });

  @override
  State<AppPasswordInput> createState() => _AppPasswordInputState();
}

class _AppPasswordInputState extends State<AppPasswordInput> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.description != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(widget.description!),
          ),
        SizedBox(
          width: widget.width,
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            validator: widget.validatePassword,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration().copyWith(
              prefixIcon: AppIcons.lock,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText ? AppIcons.closedEye : AppIcons.openedEye,
              ),
              hintText: widget.labelText,
              labelText: widget.labelText,
            ),
          ),
        ),
      ],
    );
  }
}

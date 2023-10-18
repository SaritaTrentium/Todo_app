import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String labelText;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Future<void> Function()? onTap;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.validator,
  this.onChanged,this.onTap, this.readOnly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
    );
  }

}
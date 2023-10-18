import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget{
  final String labelText;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Future<void> Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.validator,
  this.onChanged,this.onTap, this.readOnly, required this.textInputAction});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
          ),
        ),
        suffixIcon: widget.obscureText != null
          ?  IconButton(
              icon: Icon(passwordVisible
              ? Icons.visibility
              : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
              },
            );
          },
        )
          : null,
      ),
      obscureText: widget.obscureText ?? false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      textInputAction: widget.textInputAction,
    );
  }
}
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget{
  final String labelText;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Future<void> Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final bool isPassword;
  final AutovalidateMode? autovalidateMode;
  final Container? prefixIcon;
  final Widget? DropDown;
  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.validator,
  this.onChanged,this.onTap, this.readOnly, required this.textInputAction, this.isPassword= false,this.autovalidateMode, this.prefixIcon, this.DropDown});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofillHints: [AutofillHints.email],
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
          ),
        ),
        suffixIcon: widget.isPassword && widget.obscureText != null
          ? IconButton(
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
      obscureText: widget.isPassword ? !passwordVisible : false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
    );
  }
}
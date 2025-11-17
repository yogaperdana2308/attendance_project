import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool obscure;
  final Function()? onToggleObscure;
  final String? Function(String?)? validator;
  final String? label;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.obscure = false,
    this.onToggleObscure,
    this.validator,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomEventTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final IconData? icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  

  const CustomEventTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.icon,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap:onTap,
      maxLines: maxLines,
      cursorColor: white,
      style:  TextStyle(color: white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: kMainLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 0.2),
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
      ),
    );
  }
}

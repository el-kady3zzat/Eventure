import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericStepperField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;

  const NumericStepperField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
  });

  @override
  _NumericStepperFieldState createState() => _NumericStepperFieldState();
}

class _NumericStepperFieldState extends State<NumericStepperField> {
  void _increment() {
    int currentValue = int.tryParse(widget.controller.text) ?? 0;
    widget.controller.text = (currentValue + 1).toString();
  }

  void _decrement() {
    int currentValue = int.tryParse(widget.controller.text) ?? 0;
    if (currentValue > 0) {
      widget.controller.text = (currentValue - 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: white,
      style:  TextStyle(color: white),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: kMainLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 0.2),
        ),
        prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.white70) : null,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_drop_up, color: Colors.white70),
              onPressed: _increment,
            ),
            IconButton(
              icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
              onPressed: _decrement,
            ),
          ],
        ),
      ),
    );
  }
}

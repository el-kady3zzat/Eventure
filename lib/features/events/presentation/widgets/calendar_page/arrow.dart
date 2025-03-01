import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class Arrow extends StatelessWidget {
  final IconData icon;
  final void Function() onPress;
  const Arrow({super.key, required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: kHeader,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: onPress,
      ),
    );
  }
}

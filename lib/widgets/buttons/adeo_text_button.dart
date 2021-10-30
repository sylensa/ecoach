import 'package:flutter/material.dart';

class AdeoTextButton extends StatelessWidget {
  const AdeoTextButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.background,
  });

  final String label;
  final onPressed;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background ?? Colors.white,
      width: double.infinity,
      height: 52.0,
      child: TextButton(
        child: Text(
          label,
          style: TextStyle(fontSize: 24.0, color: color ?? Color(0xFFA2A2A2)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

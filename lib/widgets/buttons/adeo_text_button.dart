import 'package:flutter/material.dart';

class AdeoTextButton extends StatelessWidget {
  const AdeoTextButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.background,
    this.fontSize,
  });

  final String label;
  final onPressed;
  final Color? color;
  final Color? background;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background ?? Colors.white,
      width: double.infinity,
      height: 56.0,
      child: TextButton(
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? 24.0,
            color: color ?? Color(0xFFA2A2A2),
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: Feedback.wrapForTap(onPressed, context),
      ),
    );
  }
}

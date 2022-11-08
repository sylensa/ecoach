import 'package:ecoach/utils/style_sheet.dart';
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
        onPressed: Feedback.wrapForTap(() async {
          await Future.delayed(Duration(milliseconds: 600));
          onPressed();
        }, context),
      ),
    );
  }
}

class SectionHeaderTextButton extends StatelessWidget {
  const SectionHeaderTextButton({
    required this.label,
    this.onPressed,
    Key? key,
    this.foregroundColor,
    this.textStyle,
  }) : super(key: key);

  final String label;
  final dynamic onPressed;
  final Color? foregroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = textStyle ??
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        );

    // Color? _foregroundColor = foregroundColor ?? kAdeoBlue3;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextButton(
        child: Text(
          label,
          style: _textStyle,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

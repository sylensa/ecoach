import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class LoadingProgressIndicator extends StatelessWidget {
  const LoadingProgressIndicator({
    this.activeColor,
    this.backgroundColor,
    this.size,
    this.strokeWidth,
    Key? key,
  }) : super(key: key);

  final Color? activeColor;
  final Color? backgroundColor;
  final double? size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size ?? 60,
        height: size ?? 60,
        child: CircularProgressIndicator(
          color: activeColor ?? kAdeoGreen,
          strokeWidth: strokeWidth ?? 3.5,
        ),
      ),
    );
  }
}

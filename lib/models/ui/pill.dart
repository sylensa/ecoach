import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class Pill {
  const Pill({
    this.label = 'Pill Label',
    this.height = 28.0,
    this.horizontalPadding = 12.0,
    this.borderRadius = 16.0,
    this.fontSize = 12.0,
    this.borderWidth = 1.7,
    this.activeBackgroundColor = Colors.white,
    this.inActiveBackgroundColor = kAnalysisScreenBackground,
    this.inActiveLabelColor = Colors.white,
    this.activeLabelColor = Colors.black,
    this.borderColor,
  });

  final String label;
  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final double fontSize;
  final double borderWidth;
  final Color activeBackgroundColor;
  final Color inActiveBackgroundColor;
  final Color inActiveLabelColor;
  final Color activeLabelColor;
  final Color? borderColor;
}

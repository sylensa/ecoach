import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LinearPercentIndicatorWrapper extends StatelessWidget {
  const LinearPercentIndicatorWrapper({
    this.progressColor = Colors.orange,
    required this.label,
    required this.percent,
    this.backgroundColor = kBlack38,
  });

  final String label;
  final double percent;
  final Color progressColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      percent: percent,
      lineHeight: 16.0,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      center: Text(
        label,
        style: TextStyle(
          fontSize: 10.0,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

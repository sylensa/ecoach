import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgressIndicatorWrapper extends StatelessWidget {
  const CircularProgressIndicatorWrapper({
    this.onTap,
    this.progress,
    this.progressColor = Colors.orange,
  });

  final onTap;
  final progress;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Stack(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
            ),
          ),
          CircularPercentIndicator(
            radius: 56,
            lineWidth: 6.0,
            percent: progress * 0.01,
            center: Text(
              progress.toInt().toString() + '%',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            progressColor: progressColor,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

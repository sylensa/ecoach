import 'package:flutter/material.dart';

class SpeedArc extends StatelessWidget {
  const SpeedArc({this.speed: 0.1});

  final double speed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        child: Container(),
        painter: SpeedArcPainter(),
      ),
    );
  }
}

class SpeedArcPainter extends CustomPainter {
  const SpeedArcPainter({Key? key});

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

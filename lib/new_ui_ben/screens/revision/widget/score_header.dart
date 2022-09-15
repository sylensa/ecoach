import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ScoreHeader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            SimpleCircularProgressBar(
              progressStrokeWidth: 10,
              backStrokeWidth: 10,
              size: 70,
              mergeMode: true,
              onGetText: (double value) {
                return Text('${value.toInt()}%\navg.score');
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Score",
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
        Column(
          children: const [
            // GlowText("data"),
            GlowText(
              "08:00",
              blurRadius: 3,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Taken Time",
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
        Column(
          children: const [
            GlowText(
              "10",
              blurRadius: 3,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Questions",
              style: TextStyle(fontSize: 14),
            )
          ],
        )
      ],
    );
  }
}

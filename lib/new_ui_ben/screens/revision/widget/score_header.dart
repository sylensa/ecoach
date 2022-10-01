import 'package:animate_do/animate_do.dart';
import 'package:ecoach/new_ui_ben/providers/revision_attempts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/style_sheet.dart';
import '../../../../widgets/courses/circular_progress_indicator_wrapper.dart';

String getDurationTime(Duration duration) {
  int min = (duration.inSeconds / 60).floor();
  int sec = duration.inSeconds % 60;
  return "${NumberFormat('00').format(min)}:${NumberFormat('00').format(sec)}";
}

class ScoreHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RevisionAttemptProvider>(
      builder: (_, attempt, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FadeInLeft(
            child: Column(
              children: [
                CircularProgressIndicatorWrapper(
                  subCenterText: 'avg. score',
                  progress: attempt.avgScore,
                  progressColor: attempt.avgScore > 70 ? kAdeoGreen : Colors.orange,
                  size: ProgressIndicatorSize.small,
                  resultType: true,
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
          ),
          FadeInUp(
            child: Column(
              children: [
                // GlowText("data"),
                GlowText(
                  getDurationTime(attempt.timeTaken!),
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
          ),
          FadeInRight(
            child: Column(
              children: [
                GlowText(
                  "${attempt.questionCount}",
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
            ),
          )
        ],
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:ecoach/new_ui_ben/screens/revision/chose_revision_mode.dart';
import 'package:ecoach/new_ui_ben/screens/revision/revision_new_mission.dart';
import 'package:ecoach/new_ui_ben/screens/revision/revision_review.dart';
import 'package:ecoach/new_ui_ben/screens/revision/widget/score_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controllers/revision_progress_controller.dart';
import '../../providers/revision_attempts_provider.dart';

String getDurationTime(Duration duration) {
  int min = (duration.inSeconds / 60).floor();
  int sec = duration.inSeconds % 60;
  return "${NumberFormat('00').format(min)}:${NumberFormat('00').format(sec)}";
}

class SuccessfulRevision extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RevisionAttemptProvider>(
      builder: (_, attempt, __) => Scaffold(
        bottomNavigationBar: Container(
          color: Color(0xFFF6F6F6),
          height: 47,
          child: Row(children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.to(() => RevisionReview());
                },
                child: const Text(
                  'review',
                  style: TextStyle(fontSize: 20, color: Color(0xFFA2A2A2)),
                ),
              ),
            ),
            const VerticalDivider(
              color: Color(0xFF707070),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  // Get.to(() => ChoseRevisionMode());
                  RevisionProgressController().getRevisionQuestion();
                },
                child: Text(
                  attempt.avgScore >= 70 ? 'Continue' : "revise",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFA2A2A2),
                  ),
                ),
              ),
            ),
          ]),
        ),
        body: Consumer<RevisionAttemptProvider>(
          builder: (_, attempt, __) => SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  child: ScoreHeader(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Bounce(
                  child: Image.asset(
                    attempt.avgScore >= 70
                        ? "assets/images/learn_mode2/congrats2.png"
                        : "assets/images/learn_mode2/revisioned_failed.png",
                    height: 290,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  attempt.avgScore >= 70 ? 'Congratulations' : "Aww",
                  style: TextStyle(color: Color(0xFF323232), fontSize: 30),
                ),
                Text(
                  attempt.avgScore >= 70
                      ? 'You did a great job in the test!'
                      : "You scored below the pass mark. \nLet's try one more time\n Together we can",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFA2A2A2), fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

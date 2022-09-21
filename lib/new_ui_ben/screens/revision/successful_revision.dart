
import 'package:ecoach/new_ui_ben/screens/revision/revision_new_mission.dart';
import 'package:ecoach/new_ui_ben/screens/revision/revision_review.dart';
import 'package:ecoach/new_ui_ben/screens/revision/widget/score_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessfulRevision extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color(0xFFF6F6F6),
        height: 47,
        child: Row(children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Get.to(() =>  RevisionReview());
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
                Get.to(() =>  RevisionNewMission());
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFA2A2A2),
                ),
              ),
            ),
          ),
        ]),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
             SizedBox(
              height: 112,
              child: ScoreHeader(),
            ),
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/images/learn_mode2/congrats2.png",
              height: 290,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Text(
              'Congratulations',
              style: TextStyle(color: Color(0xFF323232), fontSize: 30),
            ),
            const Text(
              'You did a great job in the test!',
              style: TextStyle(color: Color(0xFFA2A2A2), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

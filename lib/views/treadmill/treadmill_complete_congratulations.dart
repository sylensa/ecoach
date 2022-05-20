import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/treadmill/treadmill_introit.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';

class TreadmillCompleteCongratulations extends StatelessWidget {
  TreadmillCompleteCongratulations({required this.controller});

  final TreadmillController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AdeoOutlinedButton(
                label: 'Exit',
                size: Sizes.small,
                color: kAdeoOrange,
                borderRadius: 5,
                fontSize: 14,
                onPressed: () {
                  Navigator.popUntil(context,
                      ModalRoute.withName(CourseDetailsPage.routeName));
                },
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 33),
          Text(
            'Congratulations',
            style: TextStyle(
              fontSize: 41,
              fontFamily: 'Hamelin',
              color: kAdeoBlue,
            ),
          ),
          Text(
            'Run Completed',
            style: TextStyle(
              fontSize: 18,
              color: Color(0x809EE4FF),
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 48),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Net Score: ${controller.treadmill!.totalCorrect! - controller.treadmill!.totalWrong!}',
                    style: TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '${Duration(seconds: controller.treadmill!.totalTime!).inHours} hrs : ${Duration(seconds: controller.treadmill!.totalTime!).inMinutes % 60} min : ${Duration(seconds: controller.treadmill!.totalTime!).inSeconds % 60} sec',
                    style: TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '${controller.questions.length} Questions',
                    style: TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 48),
                  QuizStats(
                    changeUp: true,
                    averageScore:
                        '${controller.getAvgScore().toStringAsFixed(2)}%',
                    speed: '${controller.getAvgTime().toStringAsFixed(2)}s',
                    correctScore: '${controller.getTotalCorrect()}',
                    wrongScrore: '${controller.getTotalWrong()}',
                  ),
                  SizedBox(height: 20),
                  // AdeoTextButton(
                  //   label: 'View Ranking',
                  //   onPressed: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (c) {
                  //       return MarathonRanking();
                  //     }));
                  //   },
                  //   fontSize: 20,
                  //   color: kAdeoBlue,
                  //   background: Colors.transparent,
                  // ),
                  SizedBox(height: 96),
                ],
              ),
            ),
          ),
          Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AdeoTextButton(
                    label: 'new test',
                    fontSize: 20,
                    color: Colors.white,
                    background: kAdeoBlue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) {
                          return TreadmillIntroit(
                            controller.user,
                            controller.course,
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

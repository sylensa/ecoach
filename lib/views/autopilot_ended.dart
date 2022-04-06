import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/autopilot_introit.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';

class AutopilotEnded extends StatelessWidget {
  AutopilotEnded({required this.controller});
  AutopilotController controller;

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
            'Autopilot Ended',
            style: TextStyle(
              fontSize: 41,
              fontFamily: 'Hamelin',
              color: kAdeoBlue,
            ),
          ),
          SizedBox(height: 65),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 46,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Net Score: ${controller.currentTopic!.correct! - controller.currentTopic!.wrong!}',
                    style: TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '${Duration(seconds: controller.currentTopic!.time!).inHours} hrs : ${Duration(seconds: controller.currentTopic!.time!).inMinutes % 60} min : ${Duration(seconds: controller.currentTopic!.time!).inSeconds % 60} sec',
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
                // Expanded(
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: AdeoTextButton(
                //           label: 'review',
                //           fontSize: 20,
                //           color: Colors.white,
                //           background: kAdeoBlue,
                //           onPressed: () {},
                //         ),
                //       ),
                //       Container(
                //         width: 1.0,
                //         color: kAdeoBlueAccent,
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'result',
                          fontSize: 20,
                          color: Colors.white,
                          background: kAdeoBlue,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) {
                              return AutopilotIntroit(
                                  controller.user, controller.course);
                            }));
                          },
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: kAdeoBlueAccent,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AdeoTextButton(
                    label: 'new test',
                    fontSize: 20,
                    color: Colors.white,
                    background: kAdeoBlue,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (c) {
                        return AutopilotIntroit(
                            controller.user, controller.course);
                      }), ModalRoute.withName(CourseDetailsPage.routeName));
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

import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_complete_congratulation.dart';
import 'package:ecoach/views/autopilot/autopilot_topic_menu.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';

import 'package:ecoach/utils/string_extension.dart';

class AutopilotTopicComplete extends StatelessWidget {
  AutopilotTopicComplete({required this.controller});
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainHomePage(
                        controller.user,
                      ),
                    ),
                    (route) => false,
                  );
                  // Navigator.popUntil(context,
                  //     ModalRoute.withName(CoursesDetailsPage.routeName));
                },
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 72),
          Text(
            '${controller.name!.capitalize()}',
            style: TextStyle(
              fontSize: 41,
              fontFamily: 'Hamelin',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'completed',
            style: TextStyle(
              fontSize: 18,
              color: kAdeoBlueAccent.withOpacity(0.58),
              fontStyle: FontStyle.italic,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 43),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Net Score: ${controller.currentTopic!.correct! - controller.currentTopic!.wrong!}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    '${Duration(seconds: controller.currentTopic!.time!).inHours} hrs : ${Duration(seconds: controller.currentTopic!.time!).inMinutes % 60} min : ${Duration(seconds: controller.currentTopic!.time!).inSeconds % 60} sec',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    '${controller.questions.length} Questions',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 66),
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
                  //       return AutopilotRanking();
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
                    label: controller.isLastTopic ? 'Done' : 'Next Topic',
                    fontSize: 20,
                    color: Colors.white,
                    background: kAdeoOrange2,
                    onPressed: () async {
                      await controller.updateCurrentTopic();

                      if (controller.isLastTopic) {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return AutopilotCompleteCongratulations(
                              controller: controller);
                        }));
                      } else {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (c) {
                          return AutopilotTopicMenu(controller: controller);
                        }), ModalRoute.withName(CoursesDetailsPage.routeName));
                      }
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

  substring(int i) {}
}

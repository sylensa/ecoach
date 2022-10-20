import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';

class MarathonEnded extends StatelessWidget {
  MarathonEnded({required this.controller});
  MarathonController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(
            context, ModalRoute.withName(CourseDetailsPage.routeName));
        return true;
      },
      child: Scaffold(
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
              'Marathon Ended',
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
                      'Net Score: ${controller.marathon!.totalCorrect! - controller.marathon!.totalWrong!}',
                      style: TextStyle(
                        fontSize: 15,
                        color: kAdeoBlueAccent,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${Duration(seconds: controller.marathon!.totalTime!).inHours} hrs : ${Duration(seconds: controller.marathon!.totalTime!).inMinutes % 60} min : ${Duration(seconds: controller.marathon!.totalTime!).inSeconds % 60} sec',
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: AdeoTextButton(
                            label: 'review',
                            fontSize: 20,
                            color: Colors.white,
                            background: kAdeoBlue,
                            onPressed: () {
                              final testTaken = controller.getTest();
                              goTo(
                                  context,
                                  QuizReviewPage(
                                    testTaken: testTaken,
                                    user: controller.user,
                                    disgnostic: false,
                                  ));
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
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: AdeoTextButton(
                  //           label: 'result',
                  //           fontSize: 20,
                  //           color: Colors.white,
                  //           background: kAdeoBlue,
                  //           onPressed: () {
                  //             Navigator.push(context,
                  //                 MaterialPageRoute(builder: (c) {
                  //               return MarathonIntroit(
                  //                   controller.user, controller.course);
                  //             }));
                  //           },
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
                    child: AdeoTextButton(
                      label: 'new test',
                      fontSize: 20,
                      color: Colors.white,
                      background: kAdeoBlue,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return MarathonIntroit(
                              controller.user, controller.course);
                        }));
                      },
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

import 'package:ecoach/controllers/conquest_controller.dart';
import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';

class ConquestCompleteCongratulations extends StatelessWidget {
  ConquestCompleteCongratulations({required this.controller});
  ConquestController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName(CoursesDetailsPage.routeName));
        Navigator.pop(context);
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
                    Navigator.pop(context);
                    Navigator.popUntil(context,
                        ModalRoute.withName(CoursesDetailsPage.routeName));
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
                fontFamily: 'Poppins',
                color: kAdeoBlue,
              ),
            ),
            Text(
              'Conquest Completed',
              style: TextStyle(
                fontSize: 18,
                color: Color(0x809EE4FF),
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
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
                      'Net Score: ${controller.getTotalCorrect() - controller.getTotalWrong()}',
                      style: TextStyle(
                        fontSize: 15,
                        color: kAdeoBlueAccent,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${Duration(seconds: controller.avgToTalTime).inHours} hrs : ${Duration(seconds: controller.avgToTalTime).inMinutes % 60} min : ${Duration(seconds: controller.avgToTalTime).inSeconds % 60} sec',
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
                      speed: '${controller.avgTime.toStringAsFixed(2)}s',
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
                        Navigator.pop(context);
                        Navigator.popUntil(context,
                            ModalRoute.withName(CoursesDetailsPage.routeName));
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

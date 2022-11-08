import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpeedQuizEnded extends StatelessWidget {
  SpeedQuizEnded({required this.controller});
  MarathonController controller;

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
                borderRadius: 1,
                fontSize: 14,
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(CoursesDetailsPage.routeName),

                  );
                },
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 33),
          Text(
            'Congratulations',
            style: TextStyle(
              fontSize: 41.sp,
              fontFamily: 'Poppins',
              color: kAdeoBlue,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Speed Test Run ',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Questions Attempted :   ${controller.marathon!.totalCorrect! + controller.marathon!.totalWrong!} / ${controller.questions.length}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Net Points: ',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: kAdeoBlueAccent,
                        ),
                      ),
                      Image.asset(
                        'assets/icons/plus.png',
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${controller.marathon!.totalCorrect! - controller.marathon!.totalWrong!}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: kAdeoBlueAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
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
                          onPressed: () {},
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
                  child: Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'result',
                          fontSize: 20,
                          color: Colors.white,
                          background: kAdeoBlue,
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (c) {
                              return SpeedTestIntro(
                                user: controller.user,
                                course: controller.course,
                              );
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (c) {
                        return SpeedTestIntro(
                          user: controller.user,
                          course: controller.course,
                        );
                      }));
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

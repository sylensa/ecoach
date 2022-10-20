import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_questions.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';

import 'package:ecoach/views/speed/speed_quiz_view.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout_speed.dart';

import 'package:flutter/material.dart';

class SpeedQuizCover extends StatelessWidget {
  SpeedQuizCover(
    this.user,
    this.type,
    this.questions, {
    Key? key,
    this.level,
    required this.name,
    this.category = TestCategory.NONE,
    this.theme = QuizTheme.ORANGE,
    this.course,
    this.time = 300,
    this.diagnostic = false,
  }) : super(key: key);

  User user;
  Level? level;
  Course? course;
  List<Question> questions;
  bool diagnostic;
  String name;
  final TestCategory category;
  final TestType type;
  int time;
  QuizTheme theme;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (questions.length == 0) {
      backgroundColor = Colors.white;
    } else if (theme == QuizTheme.GREEN) {
      backgroundColor = const Color(0xFF00C664);
    } else {
      backgroundColor = const Color(0xFFAAD4FA);
    }
    return TestIntroitLayoutSpeed(
      background: kAdeoOrangeH,
      backgroundImageURL: 'assets/images/deep_pool_orange2.png',
      headerColor: Colors.white,
      pages: [
        TestIntroitLayoutPageSpeed(
          title: 'Instructions',
          middlePiece: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                SizedBox(height: 11),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '1.',
                      style: kCustomizedTestSubtextStyleWhite,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "You have $time seconds for a question. ",
                        style: kCustomizedTestSubtextStyleWhite,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '2.',
                      style: kCustomizedTestSubtextStyleWhite,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "When the counter runs to zero , the test will end automatically",
                        style: kCustomizedTestSubtextStyleWhite,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '3.',
                      style: kCustomizedTestSubtextStyleWhite,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Once you get a question wrong , the test will end automatically',
                        style: kCustomizedTestSubtextStyleWhite,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                label: 'Start',
                onPressed: () async {
                  if(speedTestMode == "quiz"){

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return QuizQuestion(
                            controller: QuizController(
                              user,
                              course!,
                              questions: questions,
                              level: level,
                              name: name,
                              time: time,
                              type: type,
                              challengeType: category,
                            ),
                            theme: theme,
                            diagnostic: diagnostic,
                          );
                        },
                      ),
                    );
                  }else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SpeedQuizView(
                            type,
                            controller: QuizController(
                              user,
                              course!,
                              questions: questions,
                              level: level,
                              name: name,
                              time: time,
                              type: type,
                              challengeType: category,
                            ),
                            theme: theme,
                            diagnostic: diagnostic,
                          );
                        },
                      ),
                    );
                  }


                },
              )
            ],
          ),
        )
      ],
    );
  }
}

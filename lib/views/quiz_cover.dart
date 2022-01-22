import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/quiz_essay_page.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizCover extends StatelessWidget {
  QuizCover(
    this.user,
    this.questions, {
    Key? key,
    this.level,
    required this.name,
    this.type = TestType.NONE,
    this.category = TestCategory.NONE,
    this.theme = QuizTheme.GREEN,
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
    if (theme == QuizTheme.GREEN) {
      backgroundColor = const Color(0xFF00C664);
    } else {
      backgroundColor = const Color(0xFFAAD4FA);
    }
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: -100,
              right: -140,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: theme == QuizTheme.GREEN
                      ? AssetImage('assets/images/deep_pool_green.png')
                      : AssetImage('assets/images/deep_pool_blue.png'),
                )),
              ),
            ),
            Positioned(
              child: Container(
                child: questions.length == 0
                    ? Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 240, width: double.infinity),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Text(
                                    "There are no questions\n for your selection",
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (theme == QuizTheme.GREEN)
                            AdeoOutlinedButton(
                              label: 'Back',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          else if (theme == QuizTheme.BLUE)
                            AdeoFilledButton(
                              label: 'Back',
                              background: kAdeoBlue2,
                              size: Sizes.large,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          SizedBox(height: 56),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 120,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text("Test Type",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                    ":${category.toString().split(".")[1]}",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text("Questions",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                    type != TestType.SPEED
                                        ? ":${questions.length}"
                                        : "---",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text("Time",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 160,
                                child: type != TestType.UNTIMED
                                    ? Text(
                                        ":${NumberFormat('00').format(Duration(seconds: time).inMinutes)}:${NumberFormat('00').format(Duration(seconds: time).inSeconds % 60)}",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))
                                    : Text("Untimed",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Text("answer all questions",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          SizedBox(
                            height: 220,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      if (category == TestCategory.ESSAY)
                                        return QuizEssayView(
                                          user,
                                          questions,
                                          name: name,
                                          course: course,
                                          timeInSec: time,
                                          type: type,
                                          level: level,
                                        );
                                      return QuizView(
                                        user,
                                        questions,
                                        level: level,
                                        name: name,
                                        course: course,
                                        timeInSec: time,
                                        type: type,
                                        challengeType: category,
                                        theme: theme,
                                        speedTest: type == TestType.SPEED
                                            ? true
                                            : false,
                                        disableTime: type == TestType.UNTIMED
                                            ? true
                                            : false,
                                        diagnostic: diagnostic,
                                      );
                                    }));
                                  },
                                  child: Text(
                                    "Let's go",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.fromLTRB(35, 10, 35, 10)),
                                    side: MaterialStateProperty.all(BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

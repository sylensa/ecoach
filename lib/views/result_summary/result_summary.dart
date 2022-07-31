import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/result_summary/components/lower_button.dart';
import 'package:ecoach/views/results.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/views/speed/speed_quiz_cover.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultSummaryScreen extends StatefulWidget {
  ResultSummaryScreen(
    this.user,
    this.course,
    this.testType, {
    Key? key,
    required this.test,
    required this.testCategory,
    this.controller,
    this.history = false,
    this.diagnostic = false,
  }) : super(key: key);

  TestTaken test;
  final User user;
  final Course course;
  bool diagnostic;
  bool history;
  TestType testType;
  TestCategory testCategory;
  QuizController? controller;

  @override
  State<ResultSummaryScreen> createState() => _ResultSummaryScreenState();
}

class _ResultSummaryScreenState extends State<ResultSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2749), Color(0XFF09131F)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.030,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.24),
                          child: Text(
                            'Summary Result',
                            style: TextStyle(
                              fontSize: orientation == Orientation.portrait
                                  ? height * 0.025
                                  : width * 0.030,
                              color: Colors.white..withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.5),
                          size: orientation == Orientation.portrait
                              ? height * 0.040
                              : width * 0.035,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        width: width * 0.85,
                        image: const AssetImage(
                          "assets/images/success.png",
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "You did it !",
                  style: TextStyle(
                    fontSize: orientation == Orientation.portrait
                        ? height * 0.035
                        : width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: height * 0.03),
                Text(
                  "That was some great performance on the test.\n Keep it up",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: orientation == Orientation.portrait
                        ? height * 0.022
                        : width * 0.025,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.03),
                Container(
                  width: orientation == Orientation.portrait
                      ? width * 0.8
                      : width * 0.70,
                  height: orientation == Orientation.portrait
                      ? height * 0.26
                      : height * 0.40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 0.03),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your Score",
                        style: TextStyle(
                          fontSize: orientation == Orientation.portrait
                              ? height * 0.023
                              : width * 0.025,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        widget.test.score!.ceil().toString() + "/ 100",
                        style: TextStyle(
                          fontSize: orientation == Orientation.portrait
                              ? height * 0.04
                              : width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: const Color(0XFFFF7439),
                          minimumSize: Size(
                            width * 0.60,
                            orientation == Orientation.portrait
                                ? height * 0.065
                                : height * 0.090,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(height * 0.03),
                          ),
                        ),
                        onPressed: () {
                          goTo(
                            context,
                            ResultsView(
                              widget.controller!.user,
                              widget.controller!.course,
                              widget.controller!.type,
                              controller: widget.controller,
                              testCategory: widget.controller!.challengeType,
                              diagnostic: widget.diagnostic,
                              test: widget.test,
                            ),
                            replace: true,
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: orientation == Orientation.portrait
                      ? height * 0.045
                      : width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LowerButtons(
                      height: height,
                      width: width,
                      text: "Share",
                      image: "assets/images/share.png",
                      orientation: orientation,
                      onpress: () {},
                    ),
                    LowerButtons(
                      height: height,
                      width: width,
                      text: "Re-Test",
                      image: "assets/images/refresh.png",
                      orientation: orientation,
                      onpress: () async {
                        List<Question> questions = [];
                        switch (widget.testCategory) {
                          case TestCategory.BANK:
                          case TestCategory.EXAM:
                          case TestCategory.ESSAY:
                            questions = await TestController().getQuizQuestions(
                              widget.test.id!,
                              limit: 40,
                            );
                            break;
                          case TestCategory.TOPIC:
                            List<int> topicIds = widget.test.getTopicIds();

                            questions =
                                await TestController().getTopicQuestions(
                              topicIds,
                              limit: () {
                                if (widget.testType == TestType.CUSTOMIZED)
                                  return 40;
                                return widget.testType != TestType.SPEED
                                    ? 10
                                    : 1000;
                              }(),
                            );
                            break;
                          default:
                            questions =
                                await TestController().getMockQuestions(0);
                        }
                        print(questions.toString());
                        print(questions.length);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return QuizCover(
                                widget.user,
                                questions,
                                type: widget.testType,
                                name: widget.test.testname!,
                                theme: QuizTheme.ORANGE,
                                category: widget.testCategory,
                                time: widget.test.testTime != null
                                    ? widget.test.testTime!
                                    : widget.test.testType == TestType.SPEED
                                        ? widget.test.testTime!
                                        : questions.length * 60,
                                course: widget.course,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Return to Course",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                SizedBox(
                  height: orientation == Orientation.portrait
                      ? height * 0.045
                      : width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

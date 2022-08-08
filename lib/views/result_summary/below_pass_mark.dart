import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/result_summary/components/lower_button.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/models/course.dart';

class BelowPassMark extends StatefulWidget {
  BelowPassMark(
    this.user,
    this.course,
    this.testType, {
    required this.test,
    required this.testCategory,
    this.controller,
    this.history = false,
    this.diagnostic = false,
    Key? key,
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
  State<BelowPassMark> createState() => _BelowPassMarkState();
}

class _BelowPassMarkState extends State<BelowPassMark> {
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
                              fontFamily: 'Poppins.500',
                              fontSize: orientation == Orientation.portrait
                                  ? height * 0.025
                                  : width * 0.030,
                              color: Colors.white,
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
                  padding: EdgeInsets.only(
                    left: width * 0.0,
                    bottom: height * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        width: width * 0.30,
                        image: const AssetImage(
                          "assets/images/below.png",
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Let's try again !",
                  style: TextStyle(
                    fontSize: orientation == Orientation.portrait
                        ? height * 0.035
                        : width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: height * 0.03),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Revise a bit more and give this another try. \n Yes you can!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white.withOpacity(0.5),
                      fontSize: orientation == Orientation.portrait
                          ? height * 0.022
                          : width * 0.025,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                          fontFamily: 'Poppins',
                          fontSize: orientation == Orientation.portrait
                              ? height * 0.023
                              : width * 0.025,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        widget.test.score!.ceil().toString() + "/ 10",
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
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: height * 0.023,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                time: questions.length * 60,
                                course: widget.course,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.006),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },
                  child: const Text(
                    "Return to Course",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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

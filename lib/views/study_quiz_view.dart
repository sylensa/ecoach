import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudyQuizView extends StatefulWidget {
  const StudyQuizView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StudyController controller;

  @override
  _StudyQuizViewState createState() => _StudyQuizViewState();
}

class _StudyQuizViewState extends State<StudyQuizView> {
  late StudyController controller;
  late final PageController pageController;

  TestTaken? testTaken;
  TestTaken? testTakenSaved;

  @override
  void initState() {
    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);
    super.initState();
  }

  nextButton() {
    if (controller.currentQuestion == controller.questions.length - 1) {
      return;
    }
    setState(() {
      controller.currentQuestion++;

      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);

      if (controller.type == StudyType.SPEED_ENHANCEMENT &&
          controller.enabled) {
        // resetTimer();
      }
    });
  }

  completeQuiz() async {
    setState(() {
      controller.enabled = false;
    });
    showLoaderDialog(context, message: "Test Completed\nSaving results");

    await Future.delayed(Duration(seconds: 1));

    controller.saveTest(context, (test, success) {
      Navigator.pop(context);
      if (success) {
        setState(() {
          print('setState');
          testTakenSaved = test;
          controller.savedTest = true;
          controller.enabled = false;
        });
        viewResults();
      }
    });
  }

  viewResults() {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ResultsView(
          controller.user,
          controller.course!,
          test: testTakenSaved!,
          diagnostic: false,
        ),
      ),
    ).then((value) {
      setState(() {
        controller.currentQuestion = 0;
        pageController.jumpToPage(controller.currentQuestion);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularPercentIndicator(
                  radius: 25,
                  lineWidth: 3,
                  progressColor: Color(0xFF707070),
                  backgroundColor: Colors.transparent,
                  center: Text(
                    "1",
                    style: TextStyle(fontSize: 14, color: Color(0xFF969696)),
                  ),
                ),
                Text(controller.name,
                    style: TextStyle(
                        color: Color(0xFF15CA70),
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        "Coming soon",
                      )));
                    },
                    child: Text("Exit"))
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < controller.questions.length; i++)
                    StudyQuestionWidget(
                      controller.questions[i],
                      position: i,
                      // enabled: enabled,
                      // useTex: useTex,
                      callback: (Answer answer) async {
                        await Future.delayed(Duration(seconds: 1));
                        if (controller.type == StudyType.SPEED_ENHANCEMENT &&
                            answer.value == 0) {
                          // completeQuiz();
                        } else {
                          // nextButton();
                        }
                      },
                    )
                ],
              ),
            ),
          ),
          Container(
            child: IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (controller.currentQuestion > 0 &&
                        ((controller.type == StudyType.COURSE_COMPLETION &&
                                controller.enabled) ||
                            !controller.enabled))
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            pageController.previousPage(
                                duration: Duration(milliseconds: 1),
                                curve: Curves.ease);
                            setState(() {
                              controller.currentQuestion--;
                            });
                          },
                          child: Text(
                            "Previous",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    if (controller.currentQuestion <
                        controller.questions.length - 1)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (controller.currentQuestion <
                            controller.questions.length - 1 &&
                        !(!controller.enabled &&
                            controller.type == StudyType.SPEED_ENHANCEMENT &&
                            controller.currentQuestion ==
                                controller.finalQuestion))
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: nextButton,
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                    if (!controller.savedTest &&
                        controller.currentQuestion ==
                            controller.questions.length - 1)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (!controller.savedTest &&
                            controller.currentQuestion ==
                                controller.questions.length - 1 ||
                        (controller.enabled &&
                            controller.type == StudyType.SPEED_ENHANCEMENT &&
                            controller.currentQuestion ==
                                controller.finalQuestion))
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            completeQuiz();
                          },
                          child: Text(
                            "Complete",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                    if (controller.savedTest)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (controller.savedTest)
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            viewResults();
                          },
                          child: RichText(
                            softWrap: false,
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              text: "Results",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ]),
            ),
          ),
        ],
      ),
    ));
  }
}

class StudyQuestionWidget extends StatefulWidget {
  StudyQuestionWidget(this.question,
      {Key? key,
      this.position,
      this.useTex = false,
      this.enabled = true,
      this.callback})
      : super(key: key);

  final Question question;
  int? position;
  bool enabled;
  bool useTex;
  Function(Answer selectedAnswer)? callback;

  @override
  _StudyQuestionWidgetState createState() => _StudyQuestionWidgetState();
}

class _StudyQuestionWidgetState extends State<StudyQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      child: Column(
        children: [
          Container(
            height: 47,
            color: Color(0xFFF6F6F6),
            child: Text(widget.question.instructions!),
          ),
        ],
      ),
    ));
  }
}

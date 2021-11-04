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
import 'package:flutter_html/flutter_html.dart';
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
                      enabled: controller.questionEnabled(i),
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
                    if (!controller.savedTest && !controller.enabled)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (!controller.savedTest && !controller.enabled)
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: controller.enableQuestion(false),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
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
  Color textColor = Color(0xFFBABABA);
  Color textColor2 = Color(0xFFACACAC);
  Color textColor3 = Color(0xFFC3CCDE);
  Color textColor4 = Color(0xFFA2A2A2);

  late List<Answer>? answers;
  Answer? selectedAnswer;
  Answer? correctAnswer;

  @override
  void initState() {
    answers = widget.question.answers;
    if (answers != null) {
      answers!.forEach((answer) {
        if (answer.value == 1) {
          correctAnswer = answer;
        }
      });
    }

    selectedAnswer = widget.question.selectedAnswer;
    print(widget.question.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            margin: EdgeInsets.only(bottom: 2),
            color: Color(0xFFF6F6F6),
            child: Text(
              widget.question.instructions!,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            color: Color(0xFFF6F6F6),
            constraints: BoxConstraints(minHeight: 135),
            child: Align(
              alignment: Alignment.center,
              child: Html(data: "${widget.question.text ?? ''}", style: {
                // tables will have the below background color
                "body": Style(
                    color: textColor,
                    fontSize: FontSize(18),
                    textAlign: TextAlign.center),
              }),
            ),
          ),
          Container(
            child: Column(
              children: [
                for (int i = 0; i < answers!.length; i++)
                  SelectAnswerWidget(answers![i], Color(0xFF00C664),
                      (answerSelected) {
                    widget.callback!(answerSelected);
                  }),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget SelectAnswerWidget(Answer answer, Color selectedColor,
      Function(Answer selectedAnswer)? callback) {
    return TextButton(
      style: ButtonStyle(
          fixedSize: selectedAnswer == answer
              ? MaterialStateProperty.all(Size(310, 102))
              : MaterialStateProperty.all(Size(267, 88)),
          backgroundColor: MaterialStateProperty.all(
              selectedAnswer == answer ? selectedColor : Color(0xFFFAFAFA)),
          foregroundColor: MaterialStateProperty.all(
              selectedAnswer == answer ? Colors.white : Color(0xFFBEC7DB))),
      onPressed: () {
        setState(() {
          selectedAnswer = answer;
          callback!(selectedAnswer!);
        });
      },
      child: Html(data: "${answer.text!}", style: {
        // tables will have the below background color
        "body": Style(
            color: selectedAnswer == answer ? Colors.white : textColor,
            fontSize: selectedAnswer == answer ? FontSize(25) : FontSize(20),
            textAlign: TextAlign.center),
      }),
    );
  }
}

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/learn_image_screens.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learning_widget.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/views/study_cc_results.dart';
import 'package:ecoach/views/study_notes_view.dart';
import 'package:ecoach/widgets/select_text.dart';
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
  bool showSubmit = false;
  bool answeredWrong = false;
  bool showNext = false;
  bool showComplete = false;

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
      showNext = false;
      controller.enabled = true;

      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);

      if (controller.type == StudyType.SPEED_ENHANCEMENT &&
          controller.enabled) {
        // resetTimer();
      }
    });
  }

  notesButton() async {
    Topic? topic = await TopicDB().getTopicById(controller.progress.topicId!);
    controller.saveTest(context, (test, success) async {
      if (topic!.notes != "") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return StudyNoteView(topic, controller: controller);
        }));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("This topic has no notes")));

        List<Question> questions =
            await QuestionDB().getTopicQuestions([topic.id!], 10);

        controller.questions = questions;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return LearningWidget(
              controller: controller,
            );
          },
        ), (predicate) {
          return false;
        });
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
          testTakenSaved = test;
          controller.savedTest = true;
          controller.enabled = false;
        });
        if (controller.type == StudyType.REVISION ||
            controller.type == StudyType.COURSE_COMPLETION) {
          controller.updateProgress(test!);
          progressCompleteView();
        } else {
          viewResults();
        }
      }
    });
  }

  progressCompleteView() async {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    int pageIndex = 0;
    int nextLevel = controller.nextLevel;
    Topic? topic =
        await TopicDB().getLevelTopic(controller.course.id!, nextLevel);
    if (topic == null) pageIndex = 1;

    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
        if (StudyType.COURSE_COMPLETION == controller.type)
          return StudyCCResults(test: testTakenSaved!, controller: controller);
        return LearnImageScreens(
          studyController: controller,
          pageIndex: pageIndex,
        );
      }),
    );
  }

  viewResults() {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ResultsView(
          controller.user,
          controller.course,
          test: testTakenSaved!,
          diagnostic: false,
        ),
      ),
    ).then((value) {
      setState(() {
        controller.currentQuestion = 0;
        controller.reviewMode = true;
        pageController.jumpToPage(controller.currentQuestion);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!controller.enabled && !showNext) {
          return showExitDialog();
        }
        // timerController.pause();

        return showPauseDialog();
      },
      child: Scaffold(
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
                    percent: controller.percentageCompleted,
                    center: Text(
                      "${controller.currentQuestion + 1}",
                      style: TextStyle(fontSize: 14, color: Color(0xFF969696)),
                    ),
                  ),
                  Expanded(
                    child: Text(controller.name,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF15CA70),
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        showPauseDialog();
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
                        callback: (Answer answer, correct) async {
                          setState(() {
                            showSubmit = true;
                            if (controller.type == StudyType.REVISION) {
                              if (correct)
                                answeredWrong = false;
                              else
                                answeredWrong = true;
                            }
                          });
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
                      if (showPreviousButton())
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
                                color: Color(0xFFA2A2A2),
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      if (showSubmitButton())
                        VerticalDivider(width: 2, color: Colors.white),
                      if (showSubmitButton())
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                showSubmit = false;
                                showNext = true;
                                controller.enabled = false;

                                if (!controller.savedTest &&
                                        controller.currentQuestion ==
                                            controller.questions.length - 1 ||
                                    (controller.enabled &&
                                        controller.type ==
                                            StudyType.SPEED_ENHANCEMENT &&
                                        controller.currentQuestion ==
                                            controller.finalQuestion)) {
                                  showComplete = true;
                                  showNext = false;
                                }
                              });
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Color(0xFFA2A2A2),
                                fontSize: 21,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFF6F6F6))),
                          ),
                        ),
                      if (showNextButton())
                        VerticalDivider(width: 2, color: Colors.white),
                      if (showNextButton())
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: answeredWrong ? notesButton : nextButton,
                            child: Text(
                              answeredWrong ? "Study Notes" : "Next",
                              style: TextStyle(
                                color: Color(0xFFA2A2A2),
                                fontSize: 21,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFF6F6F6))),
                          ),
                        ),
                      if (showCompleteButton())
                        VerticalDivider(width: 2, color: Colors.white),
                      if (showCompleteButton())
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              completeQuiz();
                            },
                            child: Text(
                              "Complete",
                              style: TextStyle(
                                color: Color(0xFFA2A2A2),
                                fontSize: 21,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFF6F6F6))),
                          ),
                        ),
                      if (showResultButton())
                        VerticalDivider(width: 2, color: Colors.white),
                      if (showResultButton())
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
                                  color: Color(0xFFA2A2A2),
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
      )),
    );
  }

  bool showPreviousButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        if (controller.reviewMode) return true;
        break;
      case StudyType.COURSE_COMPLETION:
        if (controller.currentQuestion > 0) return true;
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    return false;
  }

  bool showSubmitButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    return showSubmit;
  }

  bool showNextButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    return showNext || controller.reviewMode;
  }

  bool showCompleteButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    return showComplete;
  }

  bool showResultButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }

    return controller.savedTest;
  }

  Future<bool> showExitDialog() async {
    bool canExit = true;
    await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Exit?",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to close this quiz?',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Button(
                label: "Yes",
                onPressed: () {
                  canExit = true;
                  Navigator.popUntil(context,
                      ModalRoute.withName(CourseDetailsPage.routeName));
                },
              ),
              Button(
                label: "No",
                onPressed: () {
                  canExit = false;
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
    return Future.value(canExit);
  }

  Future<bool> showPauseDialog() async {
    return (await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return PauseDialog(
                backgroundColor: Colors.grey,
                backgroundColor2: Colors.black12,
                time: 0,
                callback: (action) {
                  Navigator.pop(context);
                  if (action == "resume") {
                    // startTimer();
                  } else if (action == "quit") {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return MainHomePage(controller.user, index: 1);
                    }), (route) => false);
                  }
                },
              );
            })) ??
        false;
  }
}

class PauseDialog extends StatefulWidget {
  PauseDialog(
      {Key? key,
      required this.time,
      required this.callback,
      required this.backgroundColor,
      required this.backgroundColor2})
      : super(key: key);
  int time;
  Function(String action) callback;
  Color backgroundColor, backgroundColor2;

  @override
  _PauseDialogState createState() => _PauseDialogState();
}

class _PauseDialogState extends State<PauseDialog> {
  String action = "";
  int min = 0;
  int sec = 0;
  @override
  void initState() {
    min = (widget.time / 60).floor();
    sec = widget.time % 60;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 380,
          height: 560,
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.backgroundColor2,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Time Remaining ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              decoration: TextDecoration.none)),
                      Text("$min:$sec",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              decoration: TextDecoration.none))
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectText("resume", action == "resume",
                        color: Colors.black,
                        selectedColor: Colors.black,
                        normalSize: 27,
                        selectedSize: 45, select: () {
                      setState(() {
                        action = "resume";
                      });
                    }),
                    SelectText("quit", action == "quit",
                        color: Colors.black,
                        selectedColor: Colors.black,
                        normalSize: 27,
                        selectedSize: 45, select: () {
                      setState(() {
                        action = "quit";
                      });
                    }),
                  ],
                ),
              )),
              SizedBox(
                height: 70,
                child: Container(
                    decoration: BoxDecoration(
                        color: widget.backgroundColor2,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20))),
                    child: Center(
                        child: TextButton(
                      onPressed: () {
                        if (action == "") {
                          return;
                        }
                        widget.callback(action);
                      },
                      child: Text("proceed",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              decoration: TextDecoration.none)),
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
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
  Function(Answer selectedAnswer, bool correct)? callback;

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
  bool isAnswered = false;

  @override
  void initState() {
    if (!widget.enabled) {
      isAnswered = true;
    }

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
    return SingleChildScrollView(
      child: Material(
          child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Html(data: "${widget.question.text ?? ''}", style: {
                    // tables will have the below background color
                    "body": Style(
                        color: textColor,
                        fontSize: FontSize(18),
                        textAlign: TextAlign.center),
                  }),
                  if (widget.question.resource != null &&
                      widget.question.resource != "")
                    Container(
                      padding: EdgeInsets.fromLTRB(2, 12, 2, 4),
                      decoration: BoxDecoration(
                          color: Color(0xFF444444),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Text(
                            "Resource",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          Html(
                              data: "${widget.question.resource ?? ''}",
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                    color: Colors.white,
                                    fontSize: FontSize(23),
                                    textAlign: TextAlign.center),
                              }),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  for (int i = 0; i < answers!.length; i++)
                    SelectAnswerWidget(answers![i], Color(0xFF00C664), (
                      answerSelected,
                    ) {
                      widget.callback!(
                          answerSelected, answerSelected == correctAnswer);
                    }),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget SelectAnswerWidget(Answer answer, Color selectedColor,
      Function(Answer selectedAnswer)? callback) {
    return GestureDetector(
      onTap: () {
        if (!widget.enabled) {
          return;
        }
        setState(() {
          selectedAnswer = widget.question.selectedAnswer = answer;
          callback!(answer);
        });
      },
      child: Container(
        color: getBackgroundColor(answer, selectedColor),
        margin: EdgeInsets.zero,
        width: getWidgetSize(answer).width,
        constraints: BoxConstraints(
          minHeight: getWidgetSize(answer).height,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Html(shrinkWrap: true, data: "${answer.text!}", style: {
            // tables will have the below background color
            "body": Style(
                color: getForegroundColor(answer),
                fontSize:
                    selectedAnswer == answer ? FontSize(25) : FontSize(20),
                textAlign: TextAlign.center),
          }),
        ),
      ),
    );
  }

  Size getWidgetSize(Answer answer) {
    if (widget.enabled) {
      if (selectedAnswer == answer) {
        return Size(310, 102);
      }
    } else {
      if (selectedAnswer == answer && answer == correctAnswer) {
        return Size(310, 102);
      } else if (answer == correctAnswer) {
        return Size(267, 88);
      }
    }
    return Size(267, 88);
  }

  Color getBackgroundColor(Answer answer, Color selectedColor) {
    if (widget.enabled && selectedAnswer == answer) {
      return selectedColor;
    } else if (!widget.enabled && answer == correctAnswer) {
      return selectedColor;
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Color(0xFFFB7B76);
    }
    return Color(0xFFFAFAFA);
  }

  Color getForegroundColor(Answer answer) {
    if (selectedAnswer == answer ||
        !widget.enabled && correctAnswer == answer) {
      return Colors.white;
    }
    return Color(0xFFBEC7DB);
  }
}

import 'dart:async';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot_topic_complete.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/autopilot_complete_congratulation.dart';
import 'package:ecoach/views/autopilot_ended.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_timer/simple_timer.dart';

class AutopilotQuizView extends StatefulWidget {
  AutopilotQuizView({Key? key, required this.controller}) : super(key: key);
  AutopilotController controller;

  @override
  State<AutopilotQuizView> createState() => _AutopilotQuizViewState();
}

class _AutopilotQuizViewState extends State<AutopilotQuizView>
    with SingleTickerProviderStateMixin {
  int selectedObjective = 0;
  Color themeColor = kAdeoOrange;
  late AutopilotController controller;
  late final PageController pageController;
  List<AutopilotQuestionWidget> questionWidgets = [];
  bool showSubmit = false;
  TestTaken? testTaken;
  bool changeUp = false;
  bool showNext = false;
  double avgScore = 0;
  double avgTime = 0;
  int correct = 0;
  int wrong = 0;

  int questionTimer = 0;

  late TimerController _timerController;
  TimerStyle _timerStyle = TimerStyle.expanding_segment;

  @override
  void initState() {
    super.initState();
    /* int count = await TestController()
                          .getTopicQuestions(widget.controller.course); */
    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);

    print("name  is ${controller.name}");
    print("print current question ${controller.currentQuestion}");
    print("No of Questions of Topic ${controller.topics.length}");
    print("No of Questions = ${controller.questions.length}");
    Future.delayed(Duration.zero).then((value) => controller.startTest());
  }

  void handleObjectiveSelection(id) {
    setState(() {
      selectedObjective = id;
    });
  }

  next() {
    setState(() {
      showSubmit = true;
    });

    if (controller.lastQuestion) {
      setState(() {
        controller.pauseTimer();
        controller.stopTimer();
      });
      return;
    }
  }

  nextButton() {
    setState(() {
      showNext = false;
      controller.reviewMode = false;
      controller.nextQuestion();
      controller.resumeTimer();
      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);
    });
  }

  void timerValueChangeListener(Duration timeElapsed) {
    print("timer change ${timeElapsed.inSeconds}");
  }

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }

  sumbitAnswer() async {
    bool success = await controller.scoreCurrentQuestion();
    double newScore = controller.autopilot!.avgScore!;

    setState(() {
      showSubmit = false;
      if (newScore != avgScore) {
        changeUp = newScore > avgScore;
      }
      avgScore = newScore;
    });

    print("last q=${controller.lastQuestion}");
    print("q length=${controller.questions.length}");
    print("curent = ${controller.currentQuestion}");

    if (controller.lastQuestion) {
      testTaken = controller.getTest();
      controller.endAutopilot();
      viewResults();
    } else {
      if (success) {
        setState(() {
          controller.nextQuestion();
          pageController.nextPage(
              duration: Duration(milliseconds: 1), curve: Curves.ease);
        });
      } else {
        setState(() {
          showNext = true;
          controller.reviewMode = true;
          controller.pauseTimer();
        });
      }
    }
  }

  viewResults() {
    print("viewing results");

    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AutopilotTopicComplete(
            controller: controller,
          );
        },
      ),
    ).then((value) {
      setState(() {
        controller.currentQuestion = 0;
        controller.reviewMode = true;
        pageController.jumpToPage(controller.currentQuestion);
      });
    });
  }

  bool showPreviousButton() {
    return controller.reviewMode && controller.currentQuestion > 0;
  }

  bool showNextButton() {
    return controller.reviewMode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.reviewMode) {
          return showExitDialog();
        }
        controller.pauseTimer();
        return showPauseDialog();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF2D3E50),
          body: Column(
            children: [
              Container(
                color: themeColor,
                height: 53,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularPercentIndicator(
                      radius: 25,
                      lineWidth: 3,
                      progressColor: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Colors.transparent,
                      percent: controller.percentageCompleted,
                      center: Text(
                        "${controller.currentQuestion + 1}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 31, right: 4.0),
                      ),
                    ),
                    getTimerWidget(),
                  ],
                ),
              ),
              QuizStats(
                changeUp: changeUp,
                averageScore: controller.getAvgScore().toStringAsFixed(2) + '%',
                speed: controller.getAvgTime().toStringAsFixed(2) + 's',
                correctScore: controller.getTotalCorrect().toString(),
                wrongScrore: controller.getTotalWrong().toString(),
              ),
              Expanded(
                child: Container(
                  child: PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < controller.questions.length; i++)
                        AutopilotQuestionWidget(
                          controller.user,
                          controller.questions[i].question!,
                          position: i,
                          enabled: !showNext,
                          callback: (Answer answer, correct) async {
                            next();
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
                        if (showNextButton())
                          Expanded(
                            flex: 2,
                            child: AdeoTextButton(
                              label: "Next",
                              background: kAdeoOrange2,
                              color: Colors.white,
                              onPressed: nextButton,
                            ),
                          ),
                        if (showSubmit && !controller.reviewMode)
                          VerticalDivider(width: 2, color: Colors.white),
                        if (showSubmit && !controller.reviewMode)
                          Expanded(
                            flex: 2,
                            child: AdeoTextButton(
                              label: "Submit",
                              background: kAdeoOrange2,
                              color: Colors.white,
                              onPressed: () {
                                sumbitAnswer();
                              },
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
                                    color: Color(0xFFFFFFFF),
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
        ),
      ),
    );
  }

  Widget getTimerWidget() {
    return GestureDetector(
      onTap: () {
        if (!controller.enabled) {
          return;
        }
        controller.pauseTimer();

        // showPauseDialog();
      },
      child: controller.enabled
          ? Row(
              children: [
                Image(image: AssetImage('assets/images/watch.png')),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: Feedback.wrapForTap(() {
                    showPauseDialog();
                  }, context),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: 1,
                      ),
                    ),
                    child: CustomTimer(
                      builder: (CustomTimerRemainingTime remaining) {
                        controller.duration = remaining.duration;

                        return Text(
                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                          ),
                        );
                      },
                      controller: controller.timerController,
                      begin: Duration(
                          seconds: controller.autopilot!.totalTime ?? 0),
                      end: Duration(hours: 2000),
                    ),
                  ),
                ),
              ],
            )
          : Text("Time Up",
              style: TextStyle(color: Color(0xFF969696), fontSize: 18)),
    );
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
    if (!showSubmit) return false;
    controller.pauseTimer();
    return (await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return PauseMenuDialog(
                themeColor: themeColor,
                controller: controller,
              );
            })) ??
        false;
  }
}

Future<bool> showPopup(BuildContext context, Widget dialog) async {
  return (await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return dialog;
        },
      )) ??
      false;
}

class PauseMenuDialog extends StatefulWidget {
  const PauseMenuDialog({
    Key? key,
    required this.themeColor,
    required this.controller,
  }) : super(key: key);

  final Color themeColor;
  final AutopilotController controller;

  @override
  _PauseMenuDialogState createState() => _PauseMenuDialogState();
}

class _PauseMenuDialogState extends State<PauseMenuDialog> {
  int selected = -1;

  late AutopilotController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  handleSelection(id) {
    setState(() {
      selected = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 53),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                color: kAdeoRoyalBlue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Objective(
                        controller.user,
                        id: 5,
                        label: 'submit & save',
                        themeColor: widget.themeColor,
                        isSelected: selected == 5,
                        onTap: handleSelection,
                      ),
                      Objective(
                        controller.user,
                        id: 6,
                        label: 'submit & end',
                        themeColor: widget.themeColor,
                        isSelected: selected == 6,
                        onTap: handleSelection,
                      ),
                      Objective(
                        controller.user,
                        id: 7,
                        label: 'submit & pause',
                        themeColor: widget.themeColor,
                        isSelected: selected == 7,
                        onTap: handleSelection,
                      ),
                      Objective(
                        controller.user,
                        id: 8,
                        label: 'resume',
                        themeColor: widget.themeColor,
                        isSelected: selected == 8,
                        onTap: handleSelection,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selected > -1)
              Container(
                child: AdeoTextButton(
                  label: 'Submit',
                  onPressed: () {
                    switch (selected) {
                      case 5:
                        showPopup(context,
                            SessionSavedPrompt(controller: controller));
                        break;
                      case 6:
                        controller.endCurrentTopic();
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return AutopilotEnded(controller: controller);
                        }));
                        break;
                      case 7:
                        controller.scoreCurrentQuestion();
                        showPopup(context, TestPausedPrompt());
                        break;
                      case 8:
                        controller.resumeTimer();
                        Navigator.pop(context);
                        break;
                    }
                  },
                  background: kAdeoBlue,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class SessionSavedPrompt extends StatelessWidget {
  const SessionSavedPrompt({Key? key, required this.controller})
      : super(key: key);
  final AutopilotController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.scoreCurrentQuestion();
        Navigator.popUntil(
            context, ModalRoute.withName(CourseDetailsPage.routeName));
        return false;
      },
      child: Scaffold(
        backgroundColor: kAdeoRoyalBlue,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Session Saved',
                  style: TextStyle(
                    fontSize: 52,
                    fontFamily: 'Hamelin',
                    color: kAdeoBlue,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Continue whenever\nyou are ready',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kAdeoBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 64),
                AdeoOutlinedButton(
                  label: 'Exit',
                  onPressed: () {
                    controller.scoreCurrentQuestion();
                    Navigator.popUntil(context,
                        ModalRoute.withName(CourseDetailsPage.routeName));
                  },
                  size: Sizes.large,
                  color: Color(0xFFFF4949),
                  borderRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestPausedPrompt extends StatelessWidget {
  const TestPausedPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Test Paused',
                style: TextStyle(
                  fontSize: 52,
                  fontFamily: 'Hamelin',
                  color: kAdeoBlue,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'Continue whenever\nyou are ready',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 64),
              AdeoOutlinedButton(
                label: 'Resume',
                onPressed: () {
                  Navigator.pop(context);
                },
                size: Sizes.large,
                color: kAdeoBlue,
                borderRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AutopilotQuestionWidget extends StatefulWidget {
  const AutopilotQuestionWidget(this.user, this.question,
      {Key? key, this.position, this.enabled = true, this.callback})
      : super(key: key);

  final User user;
  final Question question;
  final int? position;
  final bool enabled;
  final Function(Answer selectedAnswer, bool correct)? callback;

  @override
  _AutopilotQuestionWidgetState createState() =>
      _AutopilotQuestionWidgetState();
}

class _AutopilotQuestionWidgetState extends State<AutopilotQuestionWidget> {
  int selectedObjective = -1;
  Color themeColor = kAdeoTaupe;

  void handleObjectiveSelection(id) {
    setState(() {
      print("selected id= $id");
      selectedObjective = id;
      selectedAnswer = widget.question.selectedAnswer = answers![id];
      widget.callback!(answers![id], answers![id] == correctAnswer);
    });
  }

  late List<Answer>? answers;
  Answer? selectedAnswer;
  Answer? correctAnswer;

  @override
  void initState() {
    print("enabled = ${widget.enabled}");
    print('instruction is: ${widget.question.instructions}');
    print('instruction is a resource: ${widget.question.resource}');
    answers = widget.question.answers;
    if (answers != null) {
      answers!.forEach((answer) {
        if (answer.value == 1) {
          correctAnswer = answer;
        }
        print("anwer id=${answer.id}");
        print("question id=${answer.questionId}");
      });
    }

    selectedAnswer = widget.question.selectedAnswer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          QuestionWid(widget.user, question: widget.question.text!),
          /* Instruction(
            widget.user,
            instruction: widget.question.instructions!,
          ), */
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            color: Color(0xFF66717D),
            child: Text(
              "${widget.question.instructions!}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontFamily: 'Hamelin',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (widget.question.resource!.isNotEmpty)
            DetailedInstruction(widget.user,
                details: widget.question.resource!),
          Container(
            width: double.infinity,
            height: 10,
            color: kAdeoOrange,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 30,
            ),
            child: Column(
              children: [
                for (int i = 0; i < answers!.length; i++)
                  Stack(children: [
                    Objective(
                      widget.user,
                      themeColor: themeColor,
                      enabled: widget.enabled,
                      id: i,
                      label: answers![i].text!,
                      isSelected: selectedAnswer == answers![i],
                      isCorrect: answers![i] == correctAnswer,
                      onTap: handleObjectiveSelection,
                    ),
                    getAnswerMarker(answers![i]),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Positioned getAnswerMarker(Answer answer) {
    if (!widget.enabled && answer == correctAnswer) {
      return Positioned(
          left: 5,
          bottom: 5,
          child: Image(
            image: AssetImage('assets/images/correct.png'),
          ));
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Positioned(
          left: 5,
          bottom: 5,
          child: Image(
            image: AssetImage('assets/images/wrong.png'),
          ));
    }
    return Positioned(child: Container());
  }
}

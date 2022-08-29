import 'dart:async';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/marathon/marathon_complete_congratulation.dart';
import 'package:ecoach/views/marathon/marathon_ended.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/views/speed/speed_quiz_ended.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_timer/simple_timer.dart';

class MarathonQuizView extends StatefulWidget {
  MarathonQuizView(
      {Key? key, required this.controller, this.themeColor = kAdeoBlue})
      : super(key: key);
  MarathonController controller;
  Color themeColor;

  @override
  State<MarathonQuizView> createState() => _MarathonQuizViewState();
}

class _MarathonQuizViewState extends State<MarathonQuizView>
    with SingleTickerProviderStateMixin {
  int selectedObjective = 0;

  late MarathonController controller;
  late final PageController pageController;
  List<MarathonQuestionWidget> questionWidgets = [];
  bool showSubmit = false;
  TestTaken? testTaken;
  bool changeUp = false;
  bool showNext = false;
  double avgScore = 0;
  double avgTime = 0;
  int correct = 0;
  int wrong = 0;
  int countdownInSeconds = 0;
  int questionTimer = 0;

  TimerStyle _timerStyle = TimerStyle.expanding_segment;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);

    print("No of Questions = ${controller.questions.length}");
    controller.startTest();
    // controller.endMarathon();
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

  onEnd() {
    print("timer ended");

    controller.endMarathon();
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return SpeedQuizEnded(controller: controller);
    }));
  }

  sumbitAnswer() async {
    bool success = await controller.scoreCurrentQuestion();
    double newScore = controller.marathon!.avgScore!;

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
      controller.endMarathon();
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
          return MarathonCompleteCongratulations(
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
                color: widget.themeColor,
                height: 53,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !controller.speedTest
                        ? CircularPercentIndicator(
                            radius: 25,
                            lineWidth: 3,
                            progressColor: Color(0xFF222E3B),
                            backgroundColor: Colors.transparent,
                            percent: controller.percentageCompleted,
                            center: Text(
                              "${controller.currentQuestion + 1}",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF222E3B)),
                            ),
                          )
                        : CircularPercentIndicator(
                            radius: 20,
                            lineWidth: 3,
                            progressColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            percent: controller.percentageCompleted,
                            center: Text(
                              "${controller.currentQuestion + 1}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontFamily: 'Cocon',
                              ),
                            ),
                          ),
                    !controller.speedTest
                        ? Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 31, right: 4.0),
                              child: Text(
                                controller.name!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kAdeoBlueAccent,
                                  fontSize: 14,
                                  fontFamily: 'Hamelin',
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 31, right: 4.0),
                              child: Text(
                                controller.name!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontFamily: 'Cocon',
                                ),
                              ),
                            ),
                          ),
                    getTimerWidget(),
                  ],
                ),
              ),
              // TODO : COPY HEADER  THAT DISPLAYS  COLLOR FULL FEATURES
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
                        MarathonQuestionWidget(
                          controller.user,
                          controller.questions[i].question!,
                          position: i,
                          enabled: !showNext,
                          callback: (Answer answer, correct) async {
                            next();
                          },
                          themeColor: widget.themeColor,
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
                              background: kAdeoBlue,
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
                              background: kAdeoBlue,
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
        // controller.pauseTimer();

        // showPauseDialog();
      },
      child: controller.enabled
          ? !controller.speedTest
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
                            color: Color(0xFF222E3B),
                            width: 1,
                          ),
                        ),
                        child: CustomTimer(
                          builder: (CustomTimerRemainingTime remaining) {
                            controller.duration = remaining.duration;

                            return Text(
                              "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                              style: TextStyle(
                                color: Color(0xFF222E3B),
                                fontSize: 14,
                              ),
                            );
                          },
                          controller: controller.timerController,
                          begin: Duration(
                              seconds: controller.marathon!.totalTime ?? 0),
                          end: Duration(hours: 12),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Image(image: AssetImage('assets/images/watch.png')),
                    SizedBox(width: 4),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: AdeoTimer(
                          controller: controller.speedtimerController!,
                          startDuration: controller.speedDuration!,
                          callbackWidget: (time) {
                            Duration remaining =
                                Duration(seconds: time.toInt());
                            controller.duration = remaining;
                            countdownInSeconds = remaining.inSeconds;
                            if (remaining.inSeconds == 0) {
                              return Text("Time Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold));
                            }

                            return Text(
                                "${remaining.inMinutes}:${remaining.inSeconds % 60}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold));
                          },
                          onFinish: () {
                            onEnd();
                          }),
                    )
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
                themeColor: widget.themeColor,
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
  final MarathonController controller;

  @override
  _PauseMenuDialogState createState() => _PauseMenuDialogState();
}

class _PauseMenuDialogState extends State<PauseMenuDialog> {
  int selected = -1;

  late MarathonController controller;

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
                        controller.endMarathon();
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return MarathonEnded(controller: controller);
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
  final MarathonController controller;

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
                  onPressed: () async {
                    await controller.scoreCurrentQuestion();
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

class MarathonQuestionWidget extends StatefulWidget {
  MarathonQuestionWidget(this.user, this.question,
      {Key? key,
      this.position,
      this.enabled = true,
      this.callback,
      this.themeColor = kAdeoTaupe})
      : super(key: key);

  final User user;
  final Question question;
  final int? position;
  final bool enabled;
  Color themeColor;
  final Function(Answer selectedAnswer, bool correct)? callback;

  @override
  _MarathonQuestionWidgetState createState() => _MarathonQuestionWidgetState();
}

class _MarathonQuestionWidgetState extends State<MarathonQuestionWidget> {
  int selectedObjective = -1;

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
          Instruction(
            widget.user,
            instruction: widget.question.instructions!,
          ),
          DetailedInstruction(widget.user, details: widget.question.resource!),
          Container(
            width: double.infinity,
            height: 10,
            color: widget.themeColor,
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
                      themeColor: widget.themeColor,
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

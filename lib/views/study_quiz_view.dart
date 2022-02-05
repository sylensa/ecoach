import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/controllers/study_speed_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn_image_screens.dart';
import 'package:ecoach/views/learn_mastery_feedback.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learn_speed_enhancement.dart';
import 'package:ecoach/views/learn_speed_enhancement_completion.dart';
import 'package:ecoach/views/study_cc_results.dart';
import 'package:ecoach/views/study_mastery_results.dart';
import 'package:ecoach/views/study_notes_view.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:ecoach/widgets/select_text.dart';
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
  bool showSubmit = false;
  bool answeredWrong = false;
  bool showNext = false;
  bool showComplete = false;
  List<bool> isAnsweredQuestions = [];

  @override
  void initState() {
    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);

    controller.startTest();
    super.initState();
  }

  nextButton() {
    if (controller.currentQuestion == controller.questions.length - 1) {
      return;
    }
    setState(() {
      controller.currentQuestion++;
      showNext = false;
      if (controller.type == StudyType.REVISION ||
          controller.type == StudyType.SPEED_ENHANCEMENT) {
        controller.enabled = true;
      }

      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);

      if (controller.type == StudyType.SPEED_ENHANCEMENT &&
          controller.enabled) {
        ((controller) as SpeedController).resetTimer();
      }
    });
  }

  notesButton() async {
    Topic? topic = await TopicDB().getTopicById(controller.progress.topicId!);
    controller.saveTest(context, (test, success) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StudyNoteView(topic!, controller: controller);
      }));
    });
  }

  endSpeedSession() async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return LearnSpeed(
        controller.user,
        controller.course,
        controller.progress,
        page: 1,
      );
    }), ModalRoute.withName(LearnSpeed.routeName));
  }

  completeQuiz() async {
    setState(() {
      controller.enabled = false;
    });
    showLoaderDialog(context, message: "Test Completed\nSaving results");

    await Future.delayed(Duration(seconds: 1));

    controller.saveTest(context, (test, success) async {
      Navigator.pop(context);
      if (success) {
        setState(() {
          testTakenSaved = test;
          controller.savedTest = true;
          controller.enabled = false;
        });
        await controller.updateProgress(test!);
        progressCompleteView();
      }
    });
  }

  progressCompleteView() async {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());

    int pageIndex = 0;
    if (StudyType.SPEED_ENHANCEMENT == controller.type) {
      int nextLevel = controller.nextLevel;
      Topic? topic =
          await TopicDB().getLevelTopic(controller.course.id!, nextLevel);
      if (topic == null) pageIndex = 1;
    }

    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
        if (StudyType.COURSE_COMPLETION == controller.type)
          return StudyCCResults(test: testTakenSaved!, controller: controller);
        if (StudyType.SPEED_ENHANCEMENT == controller.type) {
          bool moveUp = controller.progress.section == null ||
              controller.progress.section! <= 3;
          if (moveUp) {
            moveUp = controller.progress.passed!;
          }
          return LearnSpeedEnhancementCompletion(
              controller: controller as SpeedController,
              moveUp: moveUp,
              level: {
                'level':
                    moveUp ? controller.nextLevel : controller.progress.level,
                'duration': controller.resetDuration!.inSeconds,
                'questions': 1
              });
        }
        if (StudyType.MASTERY_IMPROVEMENT == controller.type) {
          int level = controller.progress.level!;
          controller.updateProgressSection(2);
          print("level $level");
          if (level == 1) {
            return StudyMasteryResults(
              test: testTakenSaved!,
              controller: controller as MasteryController,
            );
          }

          return LearnMasteryFeedback(
              passed: controller.progress.passed!,
              topic: controller.progress.name!,
              controller: controller as MasteryController);
        }
        return LearnImageScreens(
          studyController: controller,
          pageIndex: pageIndex,
        );
      }),
    ).then((value) {
      setState(() {
        controller.currentQuestion = 0;
        controller.reviewMode = true;
        pageController.jumpToPage(controller.currentQuestion);
      });
    });
  }

  viewResults() {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          if (controller.type == StudyType.MASTERY_IMPROVEMENT) {
            if (controller.progress.level == 1)
              return StudyMasteryResults(
                  test: testTakenSaved!,
                  controller: controller as MasteryController);
            if (controller.progress.level == 2)
              return LearnMasteryFeedback(
                passed: controller.progress.passed!,
                topic: controller.progress.name!,
                controller: controller as MasteryController,
              );
          }

          return StudyCCResults(test: testTakenSaved!, controller: controller);
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
      child: SafeArea(
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
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF969696)),
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
                    if (controller.type == StudyType.REVISION ||
                        controller.type == StudyType.MASTERY_IMPROVEMENT)
                      OutlinedButton(
                          onPressed: () {
                            showPauseDialog();
                          },
                          child: Text("Exit")),
                    if (controller.type == StudyType.COURSE_COMPLETION ||
                        controller.type == StudyType.SPEED_ENHANCEMENT)
                      getTimerWidget(),
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
                          controller.user,
                          controller.questions[i],
                          position: i,
                          enabled: controller.questionEnabled(i),
                          type: controller.type,
                          // useTex: useTex,
                          callback: (Answer answer, correct) async {
                            setState(() {
                              showSubmit = true;
                              if (controller.type == StudyType.REVISION ||
                                  controller.type ==
                                      StudyType.SPEED_ENHANCEMENT) {
                                if (correct)
                                  answeredWrong = false;
                                else
                                  answeredWrong = true;
                              } else if (controller.type ==
                                  StudyType.MASTERY_IMPROVEMENT) {
                                showNext = true;
                                if (controller.lastQuestion) {
                                  showNext = false;
                                  showComplete = true;
                                }
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
                                  if (controller.type == StudyType.REVISION ||
                                      controller.type ==
                                          StudyType.SPEED_ENHANCEMENT) {
                                    controller.enabled = false;
                                  }

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

                                  if (answeredWrong &&
                                      controller.type == StudyType.REVISION) {
                                    showNext = true;
                                    showComplete = false;
                                  }

                                  if (answeredWrong &&
                                      controller.type ==
                                          StudyType.SPEED_ENHANCEMENT) {
                                    int section =
                                        controller.progress.section ?? 1;
                                    controller
                                        .updateProgressSection(section + 1);
                                    if (section >= 3) {
                                      showComplete = true;
                                      showNext = false;
                                    }
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
                              onPressed: answeredWrong
                                  ? wrongAnswerAction()
                                  : nextButton,
                              child: Text(
                                answeredWrong ? getWrongAnswerText() : "Next",
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
      ),
    );
  }

  Function()? wrongAnswerAction() {
    if (controller.type == StudyType.REVISION) {
      return () {
        return notesButton();
      };
    } else if (controller.type == StudyType.SPEED_ENHANCEMENT) {
      return () {
        return endSpeedSession();
      };
    } else {
      return () {};
    }
  }

  String getWrongAnswerText() {
    if (controller.type == StudyType.REVISION) {
      return "Study Notes";
    } else if (controller.type == StudyType.SPEED_ENHANCEMENT) {
      return "Start Over";
    }

    return "Any Action";
  }

  Widget getTimerWidget() {
    return GestureDetector(
      onTap: () {
        if (!controller.enabled) {
          return;
        }
        controller.pauseTimer();

        showPauseDialog();
      },
      child: controller.enabled
          ? Row(
              children: [
                Image(image: AssetImage('assets/images/watch.png')),
                SizedBox(
                  width: 2,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0xFF969696),
                        width: 1,
                      )),
                  child: CustomTimer(
                    builder: (CustomTimerRemainingTime remaining) {
                      controller.duration = remaining.duration;
                      controller.countdownInSeconds =
                          remaining.duration.inSeconds;
                      if (remaining.duration.inSeconds == 0) {
                        return Text("Time Up",
                            style: TextStyle(
                                color: Color(0xFF969696), fontSize: 14));
                      }

                      return Text(
                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                          style: TextStyle(
                              color: Color(0xFF969696), fontSize: 14));
                    },
                    stateBuilder: (time, state) {
                      if (state == CustomTimerState.paused)
                        return Text("Paused", style: TextStyle(fontSize: 24.0));

                      if (state == CustomTimerState.finished)
                        return Text("Time Up",
                            style: TextStyle(fontSize: 24.0));

                      return null;
                    },
                    onChangeState: (state) {
                      if (state == CustomTimerState.finished) {
                        print("finished");
                        Future.delayed(Duration.zero, () async {
                          endSpeedSession();
                        });
                      }
                      print("Current state: $state");
                    },
                    controller: controller.timerController,
                    begin: controller.duration!,
                    end: Duration(seconds: 0),
                  ),
                ),
              ],
            )
          : Text("Time Up",
              style: TextStyle(color: Color(0xFF969696), fontSize: 18)),
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
        if (controller.reviewMode && controller.currentQuestion > 0)
          return true;
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
        return false;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        return false;
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
        return controller.currentQuestion < controller.questions.length - 1;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    print("show Next= $showNext");
    return showNext || (controller.reviewMode && !controller.lastQuestion);
  }

  bool showCompleteButton() {
    if (controller.reviewMode) return false;

    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        if (!controller.enabled) return false;
        return controller.lastQuestion;
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
        return false;
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
                  Navigator.popUntil(
                      context, ModalRoute.withName(LearnMode.routeName));
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
                    Navigator.popUntil(
                        context, ModalRoute.withName(LearnMode.routeName));
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
  StudyQuestionWidget(this.user, this.question,
      {Key? key,
      this.position,
      this.useTex = false,
      this.enabled = true,
      required this.type,
      this.callback})
      : super(key: key);

  final User user;
  final Question question;
  int? position;
  bool enabled;
  bool useTex;
  StudyType type;
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

  @override
  void initState() {
    if (!widget.enabled) {
      // widget.isAnswered = true;
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
                  AdeoHtmlTex(
                    widget.user,
                    widget.question.text!,
                    fontSize: 18,
                    textColor: textColor,
                  ),
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
                          AdeoHtmlTex(
                            widget.user,
                            widget.question.resource!,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (!widget.enabled &&
                selectedAnswer != null &&
                selectedAnswer!.solution != null &&
                selectedAnswer!.solution != "")
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Container(
                        color: Color(0xFFF6F6F6),
                        child: Center(
                          child: Text(
                            "Solution",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    if (selectedAnswer != null &&
                        selectedAnswer!.solution != null &&
                        selectedAnswer!.solution != "")
                      Container(
                        color: Color(0xFFF6F6F6),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
                            child: AdeoHtmlTex(
                              widget.user,
                              correctAnswer != null
                                  ? correctAnswer!.solution!
                                  : "----",
                              textColor: Colors.black,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  for (int i = 0; i < answers!.length; i++)
                    selectAnswerWidget(answers![i], Color(0xFF00C664), (
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

  Widget selectAnswerWidget(Answer answer, Color selectedColor,
      Function(Answer selectedAnswer)? callback) {
    return SizedBox(
      width: getWidgetSize(answer).width,
      child: Stack(children: [
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(
                      color: getOutlineColor(answer, selectedColor)))),
              minimumSize: MaterialStateProperty.all(getWidgetSize(answer)),
              backgroundColor: MaterialStateProperty.all(
                getBackgroundColor(answer, selectedColor),
              ),
              foregroundColor: MaterialStateProperty.all(
                  getBackgroundColor(answer, selectedColor))),
          onPressed: () {
            if (!widget.enabled) {
              return;
            }
            setState(() {
              selectedAnswer = widget.question.selectedAnswer = answer;
              callback!(answer);
            });
          },
          child: AdeoHtmlTex(
            widget.user,
            answer.text!,
            textColor: getForegroundColor(answer),
            fontSize: selectedAnswer == answer ? 25 : 20,
          ),
        ),
        getAnswerMarker(answer)
      ]),
    );
  }

  Size getWidgetSize(Answer answer) {
    switch (widget.type) {
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

  Color getOutlineColor(Answer answer, Color selectedColor) {
    if (widget.enabled && selectedAnswer == answer) {
      return selectedColor;
    } else if (!widget.enabled && answer == correctAnswer) {
      return selectedColor;
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Color(0xFFFB7B76);
    }
    return Color(0xFFFAFAFA);
  }

  Color getBackgroundColor(Answer answer, Color selectedColor) {
    if (!widget.enabled && answer == correctAnswer) {
      return Color(0xFFFAFAFA);
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Color(0xFFFB7B76);
    }
    return Color(0xFFFAFAFA);
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

  Color getForegroundColor(Answer answer) {
    if (widget.enabled && selectedAnswer == answer) {
      return Colors.black;
    } else if (!widget.enabled && answer == correctAnswer) {
      return Colors.black;
    } else if (selectedAnswer == answer ||
        !widget.enabled && correctAnswer == answer) {
      return Colors.white;
    }
    return Color(0xFFBAC4D9);
  }
}

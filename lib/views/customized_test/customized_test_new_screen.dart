import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/customized_controller.dart';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ecoach/models/question.dart';

class CustomizedTestScreen extends StatefulWidget {
  CustomizedTestScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  CustomizedController controller;

  @override
  State<CustomizedTestScreen> createState() => _CustomizedTestScreenState();
}

class _CustomizedTestScreenState extends State<CustomizedTestScreen> {
  Color themeColor = kAdeoTaupe;

  late CustomizedController controller;
  late final PageController pageController;

  TestTaken? testTaken;
  TestTaken? testTakenSaved;
  bool showComplete = false;
  List<bool> isAnsweredQuestions = [];

  @override
  void initState() {
    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);

    controller.startTest();
    super.initState();
  }

  nextButton() async{
    await scoreCurrentQuestion(controller.questions[controller.currentQuestion]);

    if (controller.lastQuestion) {
      setState(() {
        controller.pauseTimer();
        controller.stopTimer();
        showComplete = true;
      });
      if (controller.enabled) completeQuiz();
      return;
    }
    setState(() {
      controller.currentQuestion++;

      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);
      if (!controller.reviewMode) {
        controller.resetTimer();
      }
    });
  }

  completeQuiz() async {
    await scoreCurrentQuestion(controller.questions[controller.currentQuestion]);
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

        viewResults();
      }
    });
  }

  viewResults() {
    print(testTakenSaved!.toJson().toString());
    Navigator.push<int>(
      context,
      MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return ResultsView(
            controller.user,

            controller.course,
            TestType.NONE,

            test: testTakenSaved!,
          );
        },
      ),
    ).then((value) {
      setState(() {
        controller.currentQuestion = 0;
        controller.reviewMode = true;
        if (value != null) {
          controller.currentQuestion = value;
        }
        pageController.jumpToPage(controller.currentQuestion);
      });
    });
  }

  bool showPreviousButton() {
    return controller.reviewMode && controller.currentQuestion > 0;
  }

  bool showNextButton() {
    return controller.reviewMode && !controller.lastQuestion;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!controller.enabled) {
          return showExitDialog();
        }
        // timerController.pause();

        return showPauseDialog();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF2D3E50),
          body: SafeArea(
            child: Column(
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
                        progressColor: Color(0xFF222E3B),
                        backgroundColor: Colors.transparent,
                        percent: controller.percentageCompleted,
                        center: Text(
                          "${controller.currentQuestion + 1}",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF222E3B)),
                        ),
                      ),
                      getTimerWidget()
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
                          QuestionWidget(
                            controller.user,
                            controller.questions[i],
                            position: i,
                            enabled: controller.enabled,
                            callback: (Answer answer, correct) async {
                              await Future.delayed(Duration(seconds: 1));
                              nextButton();
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
                          if (showNextButton())
                            VerticalDivider(width: 2, color: Colors.white),
                          if (showNextButton())
                            Expanded(
                              flex: 2,
                              child: TextButton(
                                onPressed: nextButton,
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Color(0xFFA2A2A2),
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                            ),
                          if (showComplete && !controller.reviewMode)
                            VerticalDivider(width: 2, color: Colors.white),
                          if (showComplete && !controller.reviewMode)
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

        showPauseDialog();
      },
      child: controller.enabled
          ? Row(
              children: [
                Image(image: AssetImage('assets/images/watch.png')),
                SizedBox(width: 4),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color(0xFF222E3B),
                      width: 1,
                    ),
                  ),
                  child: AdeoTimer(
                    callbackWidget: (time) {
                      Duration remaining = Duration(seconds: time.toInt());
                      controller.duration = remaining;
                      controller.countdownInSeconds = remaining.inSeconds;

                      if (remaining.inSeconds == 0) {
                        return Text("Time Up",
                            style: TextStyle(
                                color: Color(0xFF222E3B), fontSize: 14));
                      }

                      return Text(
                          "${remaining.inHours.remainder(24)}:${remaining.inMinutes.remainder(60)}:${remaining.inSeconds.remainder(60)}",
                          style: TextStyle(
                              color: Color(0xFF222E3B), fontSize: 14));
                    },
                    onFinish: () {
                      Future.delayed(Duration.zero, () async {
                        nextButton();
                      });
                    },
                    controller: controller.timerController!,
                    startDuration: controller.getDuration(),
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
                      ModalRoute.withName(CoursesDetailsPage.routeName));
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
                    Navigator.popUntil(context,
                        ModalRoute.withName(CoursesDetailsPage.routeName));
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
                      Text("Time Remaining  ",
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

class QuestionWidget extends StatefulWidget {
  QuestionWidget(this.user, this.question,
      {Key? key, this.position, this.enabled = true, this.callback})
      : super(key: key);

  final User user;
  final Question question;
  int? position;
  final bool enabled;
  Function(Answer selectedAnswer, bool correct)? callback;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
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

    answers = widget.question.answers;
    if (answers != null) {
      answers!.forEach((answer) {
        if (answer.value == 1) {
          correctAnswer = answer;
        }
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
          Instruction(widget.user, instruction: widget.question.instructions!),
          DetailedInstruction(
            widget.user,
            details: widget.question.resource!,
          ),
          Container(
            width: double.infinity,
            height: 10,
            color: themeColor,
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

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/customized_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
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

  nextButton() {
    if (controller.lastQuestion) {
      setState(() {
        controller.pauseTimer();
        controller.stopTimer();
        showComplete = true;
      });

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

        print('then>>');
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
        builder: (BuildContext context) {
          return ResultsView(
            controller.user,
            controller.course,
            test: testTakenSaved!,
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
    return controller.reviewMode && !controller.lastQuestion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      style: TextStyle(fontSize: 14, color: Color(0xFF222E3B)),
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
                        enabled: controller.questionEnabled(i),
                        callback: (Answer answer, correct) async {
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
    );
  }

  Widget getTimerWidget() {
    print(
        "getTimerWidget called-----------------------------------------------------------------------------------");
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
                  child: CustomTimer(
                    onBuildAction: controller.enabled
                        ? CustomTimerAction.auto_start
                        : CustomTimerAction.go_to_end,
                    builder: (CustomTimerRemainingTime remaining) {
                      controller.duration = remaining.duration;
                      controller.countdownInSeconds =
                          remaining.duration.inSeconds;
                      if (remaining.duration.inSeconds == 0) {}
                      return Text(
                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                          style: TextStyle(
                              color: Color(0xFF969696), fontSize: 14));
                    },
                    controller: controller.timerController,
                    from: controller.getDuration(),
                    to: Duration(seconds: 0),
                    onStart: () {},
                    onPaused: () {},
                    onReset: () {
                      print("onReset");
                    },
                    onFinish: () {
                      print("finished");

                      Future.delayed(Duration.zero, () async {
                        nextButton();
                      });
                    },
                  ),
                ),
              ],
            )
          : Text("Time Up",
              style: TextStyle(color: Color(0xFF969696), fontSize: 18)),
    );
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
                        ModalRoute.withName(CourseDetailsPage.routeName));
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

class QuestionWidget extends StatefulWidget {
  QuestionWidget(this.user, this.question,
      {Key? key, this.position, this.enabled = true, this.callback})
      : super(key: key);

  final User user;
  final Question question;
  int? position;
  bool enabled;
  Function(Answer selectedAnswer, bool correct)? callback;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int selectedObjective = -1;
  Color themeColor = kAdeoTaupe;

  void handleObjectiveSelection(id) {
    setState(() {
      selectedObjective = id;
      widget.callback!(answers![id], answers![id] == correctAnswer);
    });
  }

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
                  Objective(
                    widget.user,
                    themeColor: themeColor,
                    id: i,
                    label: answers![i].text!,
                    isSelected: selectedObjective == i,
                    onTap: handleObjectiveSelection,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

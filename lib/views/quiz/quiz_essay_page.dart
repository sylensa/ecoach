import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/essay_test_question_widgets.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuizEssayView extends StatefulWidget {
  QuizEssayView(
    this.user,
    this.questions, {
    Key? key,
    this.level,
    this.course,
    required this.name,
    this.type = TestType.NONE,
    this.timeInSec = 60,
    this.disableTime = false,
  }) : super(key: key);
  User user;
  Level? level;
  Course? course;
  List<Question> questions;
  int timeInSec;
  String name;
  bool disableTime;
  final TestType type;

  @override
  _QuizEssayViewState createState() => _QuizEssayViewState();
}

class _QuizEssayViewState extends State<QuizEssayView> {
  late final PageController controller;
  int currentQuestion = 0;
  List<QuestionWidget> questionWidgets = [];
  String currentStage = 'QUESTION';

  late TimerController timerController;
  int countdownInSeconds = 0;
  DateTime startTime = DateTime.now();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  bool enabled = true;
  late Duration duration, resetDuration, startingDuration;

  late ItemScrollController numberingController;

  bool useTex = false;
  int finalQuestion = 0;
  late Color backgroundColor, backgroundColor2;

  @override
  void initState() {
    backgroundColor = const Color(0xFF5DA5EA);
    backgroundColor2 = const Color(0xFF5DA5CA);

    controller = PageController(initialPage: currentQuestion);
    numberingController = ItemScrollController();
    duration = Duration(seconds: widget.timeInSec);
    resetDuration = Duration(seconds: widget.timeInSec);
    startingDuration = duration;

    timerController = TimerController();

    startTimer();

    if (widget.course!.name!.toUpperCase().contains("Math".toUpperCase())) {
      useTex = true;
    }
    super.initState();
  }

  startTimer() {
    if (!widget.disableTime) {
      timerController.start();
    }
  }

  resetTimer() {
    setState(() {
      duration = resetDuration;
    });
  }

  onEnd() {
    print("timer ended");

    completeQuiz();
    // timerController.dispose();
  }

  nextButton() {
    if (currentQuestion == widget.questions.length - 1) {
      return;
    }
    setState(() {
      currentQuestion++;

      controller.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);

      numberingController.scrollTo(
          index: currentQuestion,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutCubic);
    });
  }

  completeQuiz() async {
    if (currentStage.toUpperCase() == 'QUESTION') {
      if (!widget.disableTime) {
        timerController.pause();
      }

      showLoaderDialog(context, message: "Fetching answers...");
      await Future.delayed(Duration(seconds: 3), () {
        setState(() {
          enabled = false;
          currentStage = 'ANSWER';
          currentQuestion = 0;
          controller.jumpToPage(0);
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!enabled) {
          return showExitDialog();
        }
        timerController.pause();

        return showPauseDialog();
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: Stack(children: [
              Positioned(
                top: 95,
                right: 0,
                left: 0,
                bottom: 51,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF595959),
                  ),
                  child: PageView(
                    controller: controller,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < widget.questions.length; i++)
                        QuestionWidget(
                          widget.user,
                          widget.questions[i],
                          position: i,
                          enabled: enabled,
                          currentStage: currentStage,
                        )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 40,
                left: 0,
                child: Container(
                  child: SizedBox(
                    height: 100,
                    child: ScrollablePositionedList.builder(
                      itemScrollController: numberingController,
                      itemCount: widget.questions.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Container(
                            child: SelectText(
                                "${(i + 1)}", i == currentQuestion,
                                normalSize: 28,
                                selectedSize: 45,
                                underlineSelected: true,
                                selectedColor: Color(0xFFFD6363),
                                color: Colors.white70, select: () {
                          setState(() {
                            currentQuestion = i;
                          });

                          controller.jumpToPage(i);
                        }));
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: -120,
                  right: -80,
                  child: Image(
                    image: AssetImage('assets/images/white_leave.png'),
                  )),
              Positioned(
                key: UniqueKey(),
                top: 50,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    if (!enabled) {
                      return;
                    }
                    timerController.pause();

                    showPauseDialog();
                  },
                  child: enabled
                      ? getTimerWidget()
                      : Text("Time Up",
                          style:
                              TextStyle(color: backgroundColor, fontSize: 18)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (currentQuestion > 0)
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: () {
                                controller.previousPage(
                                    duration: Duration(milliseconds: 1),
                                    curve: Curves.ease);
                                setState(() {
                                  currentQuestion--;
                                  numberingController.scrollTo(
                                      index: currentQuestion,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInOutCubic);
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
                        if (currentQuestion < widget.questions.length - 1)
                          VerticalDivider(width: 2, color: Colors.white),
                        if (currentQuestion < widget.questions.length - 1)
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
                        if (enabled &&
                            currentQuestion == widget.questions.length - 1)
                          VerticalDivider(width: 2, color: Colors.white),
                        if (enabled &&
                            currentQuestion == widget.questions.length - 1)
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
                        if (!enabled &&
                            currentQuestion == widget.questions.length - 1)
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "End Test",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  getTimerWidget() {
    return AdeoTimer(
        controller: timerController,
        startDuration: duration,
        callbackWidget: (time) {
          if (widget.disableTime) {
            return Image(image: AssetImage("assets/images/infinite.png"));
          }

          Duration remaining = Duration(seconds: time.toInt());
          duration = remaining;
          countdownInSeconds = remaining.inSeconds;
          if (remaining.inSeconds == 0) {
            return Text("Time Up",
                style: TextStyle(color: backgroundColor, fontSize: 18));
          }

          return Text("${remaining.inMinutes}:${remaining.inSeconds % 60}",
              style: TextStyle(color: backgroundColor, fontSize: 28));
        },
        onFinish: () {
          onEnd();
        });
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
                  Navigator.pop(context);
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
              backgroundColor: backgroundColor,
              backgroundColor2: backgroundColor2,
              time: countdownInSeconds,
              callback: (action) {
                Navigator.pop(context);
                if (action == "resume") {
                  startTimer();
                } else if (action == "quit") {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return MainHomePage(widget.user, index: 2);
                  }), (route) => false);
                } else if (action == "end") {
                  completeQuiz();
                }
              },
            );
          },
        )) ??
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor2,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Time Remaining  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        "$min:$sec",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      )
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
                        normalSize: 27, selectedSize: 45, select: () {
                      setState(() {
                        action = "resume";
                      });
                    }),
                    SelectText("quit", action == "quit",
                        normalSize: 27, selectedSize: 45, select: () {
                      setState(() {
                        action = "quit";
                      });
                    }),
                    SelectText("end", action == "end",
                        normalSize: 27, selectedSize: 45, select: () {
                      setState(() {
                        action = "end";
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
                              color: Colors.white,
                              fontSize: 22,
                              decoration: TextDecoration.none)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// Container(
//   color: Color(0xFF595959),
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       Container(
//         color: Color(0xFF444444),
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: FittedBox(
//             fit: BoxFit.cover,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 12,
//                 ),
//                 if (!widget.useTex)
//                   Html(
//                       data: "${widget.question.text ?? ''}",
//                       style: {
//                         // tables will have the below background color
//                         "body": Style(
//                           backgroundColor: Color(0xFF444444),
//                           color: Colors.white,
//                           fontSize: FontSize(23),
//                         ),
//                       }),
//                 if (widget.useTex)
//                   SizedBox(
//                     width: screenWidth(context),
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.fromLTRB(0, 0, 10, 0),
//                       child: TeXView(
//                         renderingEngine:
//                             TeXViewRenderingEngine.katex(),
//                         child: TeXViewDocument(
//                             widget.question.text ?? "",
//                             style: TeXViewStyle(
//                               backgroundColor: Color(0xFF444444),
//                               contentColor: Colors.white,
//                               fontStyle: TeXViewFontStyle(
//                                 fontSize: 23,
//                               ),
//                             )),
//                       ),
//                     ),
//                   )
//               ],
//             ),
//           ),
//         ),
//       ),
//       Container(
//         color: backgroundColor,
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(80, 4, 80, 4),
//             child: widget.question.instructions != null &&
//                     widget.question.instructions!.isNotEmpty
//                 ? Padding(
//                     padding:
//                         const EdgeInsets.fromLTRB(40, 8.0, 40, 8),
//                     child: Text(
//                       widget.question.instructions!,
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontStyle: FontStyle.italic,
//                           color: Colors.white),
//                     ),
//                   )
//                 : null,
//           ),
//         ),
//       ),
//       Container(
//         color: backgroundColor,
//         height: 2,
//       ),
//       Container(
//         color: Color(0xFF595959),
//         child: SizedBox(
//           width: screenWidth(context) + 20,
//           child: ExpansionPanelList(
//             //start changes here
//             dividerColor: Color(0xFF444444),
//             elevation: 0,
//             animationDuration: Duration(seconds: 1),
//             children: [
//               for (int i = 0; i < answers!.length; i++)
//                 ExpansionPanel(
//                   isExpanded: expand[i],
//                   canTapOnHeader: !widget.enabled,
//                   headerBuilder: (context, isOpen) {
//                     return Html(data: answers![i].text!, style: {
//                       // tables will have the below background color
//                       "body": Style(
//                         fontSize: FontSize(20),
//                       ),
//                     });
//                   },
//                   backgroundColor: Color(0xFF444444),
//                   body: Html(data: answers![i].solution!, style: {
//                     // tables will have the below background color
//                     "body": Style(
//                       color: Colors.white,
//                       backgroundColor: Color(0xFF595959),
//                       fontSize: FontSize(15),
//                     ),
//                   }),
//                 )
//             ],
//             expansionCallback: (index, isOpen) {
//               setState(() {
//                 expand[index] = !isOpen;
//               });
//             },
//           ),
//         ),
//       )
//     ],
//   ),
// ),
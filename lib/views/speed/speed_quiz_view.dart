import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/questions_widgets/select_answer_widget.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert';

class SpeedQuizView extends StatefulWidget {
  SpeedQuizView(
      {Key? key,
      required this.controller,
      this.theme = QuizTheme.ORANGE,
      this.diagnostic = false})
      : super(key: key);

  QuizController controller;
  bool diagnostic;
  QuizTheme theme;

  @override
  _SpeedQuizViewState createState() => _SpeedQuizViewState();
}

class _SpeedQuizViewState extends State<SpeedQuizView> {
  late final PageController pageController;
  int currentQuestion = 0;
  List<QuestionWidget> questionWidgets = [];

  late TimerController timerController;
  int countdownInSeconds = 0;

  bool enabled = true;
  bool savedTest = false;
  late Duration duration, resetDuration, startingDuration;

  TestTaken? testTaken;
  TestTaken? testTakenSaved;

  late ItemScrollController numberingController;

  int finalQuestion = 0;
  late Color backgroundColor, backgroundColor2;
  late QuizController controller;

  @override
  void initState() {
    if (widget.theme == QuizTheme.GREEN) {
      backgroundColor = const Color(0xFF00C664);
      backgroundColor2 = const Color(0xFF05A958);
    } else if (widget.theme == QuizTheme.ORANGE) {
      backgroundColor = kAdeoOrangeH;
      backgroundColor2 = kAdeoOrangeH;
    } else {
      backgroundColor = const Color(0xFF5DA5EA);
      backgroundColor2 = const Color(0xFF5DA5CA);
    }
    controller = widget.controller;
    pageController = PageController(initialPage: currentQuestion);
    numberingController = ItemScrollController();

    timerController = TimerController();

    controller.startTest();
    Future.delayed(Duration(seconds: 1), () {
      startTimer();
    });

    super.initState();
  }

  startTimer() {
    if (!controller.disableTime) {
      timerController.start();
    }
  }

  resetTimer() {
    print("reset timer");
    timerController.reset();
    Future.delayed(Duration(seconds: 1), () {
      timerController.start();
    });
    setState(() {
      duration = resetDuration;
    });
  }

  onEnd() {
    print("timer ended");

    completeQuiz();
  }

  nextButton() {
    if (currentQuestion == controller.questions.length - 1) {
      return;
    }
    setState(() {
      currentQuestion++;

      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);

      numberingController.scrollTo(
          index: currentQuestion,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutCubic);

      if (controller.speedTest && enabled) {
        resetTimer();
      }
    });
  }

  double get score {
    int totalQuestions = controller.questions.length;
    int correctAnswers = correct;
    return correctAnswers / totalQuestions * 100;
  }

  double get avgScore {
    print("avg scoring current question= $currentQuestion");
    int totalQuestions = currentQuestion + 1;

    int correctAnswers = correct;
    if (totalQuestions == 0) {
      return 0;
    }
    return correctAnswers / totalQuestions * 100;
  }

  int get correct {
    int score = 0;
    controller.questions.forEach((question) {
      if (question.isCorrect) score++;
    });
    return score;
  }

  int get wrong {
    int wrong = 0;
    controller.questions.forEach((question) {
      if (question.isWrong) wrong++;
    });
    return wrong;
  }

  int get unattempted {
    int unattempted = 0;
    controller.questions.forEach((question) {
      if (question.unattempted) unattempted++;
    });
    return unattempted;
  }

  String get responses {
    Map<String, dynamic> responses = Map();
    int i = 1;
    controller.questions.forEach((question) {
      print(question.topicName);
      Map<String, dynamic> answer = {
        "question_id": question.id,
        "topic_id": question.topicId,
        "topic_name": question.topicName,
        "selected_answer_id": question.selectedAnswer != null
            ? question.selectedAnswer!.id
            : null,
        "status": question.isCorrect
            ? "correct"
            : question.isWrong
                ? "wrong"
                : "unattempted",
      };

      responses["Q$i"] = answer;
      i++;
    });
    return jsonEncode(responses);
  }

  completeQuiz() async {
    if (!controller.disableTime) {
      timerController.pause();
    }
    if (controller.speedTest) {
      finalQuestion = currentQuestion;
    }
    setState(() {
      enabled = false;
    });
    showLoaderDialog(context, message: "Test Completed\nSaving results");
    if (controller.speedTest) {
      await Future.delayed(Duration(seconds: 1));
    }

    controller.saveTest(context, (test, success) {
      Navigator.pop(context);
      testTakenSaved = test;
      setState(() {
        print('setState');
        testTaken = testTakenSaved;
        savedTest = true;
        enabled = false;
      });
      if (success) {
        viewResults();
      }
    });
  }

  viewResults() {
    print("viewing results");
    print(testTakenSaved != null
        ? testTakenSaved!.toJson().toString()
        : "null test");
    Navigator.push<int>(
      context,
      MaterialPageRoute<int>(
        builder: (BuildContext context) => ResultsView(
          controller.user,
          controller.course,
          test: testTakenSaved!,
          diagnostic: widget.diagnostic,
        ),
      ),
    ).then((value) {
      setState(() {
        currentQuestion = 0;
        if (value != null) {
          currentQuestion = value;
        }
        pageController.jumpToPage(currentQuestion);
      });
    });
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
          backgroundColor: Color(0xFF595959),
          body: Column(children: [
            Container(
              color: backgroundColor,
              height: 53,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularPercentIndicator(
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 31, right: 4.0),
                      child: Text(
                        controller.name,
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

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF595959),
                ),
                child: PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    for (int i = 0; i < controller.questions.length; i++)
                      QuestionWidget(
                        controller.user,
                        controller.questions[i],
                        position: i,
                        enabled: enabled,
                        theme: widget.theme,
                        diagnostic: widget.diagnostic,
                        callback: (Answer answer) async {
                          await Future.delayed(Duration(milliseconds: 200));
                          if (controller.speedTest && answer.value == 0) {
                            completeQuiz();
                          } else {
                            nextButton();
                          }
                        },
                      )
                  ],
                ),
              ),
            ),
            // //
            Container(
              height: 100,
              child: ScrollablePositionedList.builder(
                itemScrollController: numberingController,
                itemCount: controller.questions.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  if (controller.speedTest) return Container();
                  return Container(
                      child: SelectText("${(i + 1)}", i == currentQuestion,
                          normalSize: 28,
                          selectedSize: 45,
                          underlineSelected: true,
                          selectedColor: Color(0xFFFD6363),
                          color: Colors.white70, select: () {
                    if (controller.speedTest) {
                      return;
                    }
                    setState(() {
                      currentQuestion = i;
                      controller.currentQuestion += 1;
                    });

                    pageController.jumpToPage(i);
                  }));
                },
              ),
            ),

            // //

            // //

            // // button
            Container(
              height: 60,
              color: backgroundColor,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (currentQuestion > 0 &&
                        (!controller.speedTest ||
                            controller.speedTest && !enabled))
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            pageController.previousPage(
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
                    if (currentQuestion < controller.questions.length - 1)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (currentQuestion < controller.questions.length - 1 &&
                        !(!enabled &&
                            controller.speedTest &&
                            currentQuestion == finalQuestion))
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
                    if (!savedTest &&
                        currentQuestion == controller.questions.length - 1)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (!savedTest &&
                            currentQuestion ==
                                controller.questions.length - 1 ||
                        (enabled &&
                            controller.speedTest &&
                            currentQuestion == finalQuestion))
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
                    if (savedTest)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (savedTest)
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
            )
          ]),
        ),
      ),
    );
  }

  getTimerWidget() {
    return controller.speedTest
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
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: AdeoTimer(
                        controller: timerController,
                        startDuration: controller.duration!,
                        callbackWidget: (time) {
                          if (controller.disableTime) {
                            return Image(
                                image:
                                    AssetImage("assets/images/infinite.png"));
                          }

                          Duration remaining = Duration(seconds: time.toInt());
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
                        })),
              ),
            ],
          )
        : AdeoTimer(
            controller: timerController,
            startDuration: controller.duration!,
            callbackWidget: (time) {
              if (controller.disableTime) {
                return Image(image: AssetImage("assets/images/infinite.png"));
              }

              Duration remaining = Duration(seconds: time.toInt());
              controller.duration = remaining;
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
                    // Navigator.pushAndRemoveUntil(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return MainHomePage(controller.user, index: 2);
                    // }), (route) => false);
                    Navigator.pop(context);
                  } else if (action == "end") {
                    completeQuiz();
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
                              color: Colors.white,
                              fontSize: 20,
                              decoration: TextDecoration.none)),
                      Text("$min:$sec",
                          style: TextStyle(
                              color: Colors.white,
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
      {Key? key,
      this.position,
      this.enabled = true,
      this.diagnostic = false,
      this.theme = QuizTheme.ORANGE,
      this.callback})
      : super(key: key);
  User user;
  Question question;
  int? position;
  bool enabled;
  bool diagnostic;
  Function(Answer selectedAnswer)? callback;
  QuizTheme theme;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late List<Answer>? answers;
  Answer? selectedAnswer;
  Answer? correctAnswer;
  Color? backgroundColor;

  @override
  void initState() {
    if (widget.theme == QuizTheme.GREEN) {
      backgroundColor = const Color(0xFF00C664);
    } else if (widget.theme == QuizTheme.ORANGE) {
      backgroundColor = kAdeoOrangeH;
    } else {
      backgroundColor = const Color(0xFF5DA5EA);
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
      child: Container(
        color: Color(0xFF595959),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFF444444),
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: AdeoHtmlTex(
                          widget.user,
                          widget.question.text!.replaceAll("https", "http"),
                          useLocalImage: !widget.diagnostic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // TODO : add  a better way to handle this
            Container(
              color: backgroundColor,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(80, 4, 90, 4),
                  child: widget.question.instructions != null &&
                          widget.question.instructions!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 50, right: 50),
                          child: Text(
                            widget.question.instructions!,
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Container(
              color: Color(0xFF595959),
              //   color: Colors.red,
              child: widget.question.resource == ""
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            AdeoHtmlTex(
                              widget.user,
                              widget.question.resource!
                                  .replaceAll("https", "http"),
                              useLocalImage: !widget.diagnostic,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Container(
              color: backgroundColor,
              height: 2,
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
                        color: Colors.amber.shade200,
                        child: Center(
                          child: Text(
                            "Solution",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    if (selectedAnswer != null &&
                        selectedAnswer!.solution != null &&
                        selectedAnswer!.solution != "")
                      Container(
                        color: Colors.orange,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
                            child: AdeoHtmlTex(
                              widget.user,
                              correctAnswer != null
                                  ? correctAnswer!.solution!
                                      .replaceAll("https", "http")
                                  : "----",
                              useLocalImage: !widget.diagnostic,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            Container(
              color: Color(0xFF595959),
              //   color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < answers!.length; i++)
                    Stack(children: [
                      SelectAnswerWidget(widget.user, answers![i].text!,
                          widget.question.selectedAnswer == answers![i],
                          normalSize: 15,
                          selectedSize: widget.enabled ? 38 : 24,
                          imposedSize: widget.enabled ||
                                  (widget.enabled && selectedAnswer == null) ||
                                  selectedAnswer != answers![i] &&
                                      answers![i].value == 0
                              ? null
                              : selectedAnswer == answers![i] &&
                                      selectedAnswer!.value == 0
                                  ? 24
                                  : 38,
                          imposedColor: widget.enabled ||
                                  (widget.enabled && selectedAnswer == null) ||
                                  selectedAnswer != answers![i] &&
                                      answers![i].value == 0
                              ? null
                              : selectedAnswer == answers![i] &&
                                      selectedAnswer!.value == 0
                                  ? Colors.red.shade400
                                  : Colors.green.shade600, select: () {
                        if (!widget.enabled) {
                          return;
                        }
                        setState(() {
                          widget.question.selectedAnswer = answers![i];
                        });
                        widget.callback!(answers![i]);
                      }),
                      getAnswerMarker2(answers![i])
                    ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAnswerMarker(Answer answer) {
    if (!widget.enabled && answer == correctAnswer) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 22),
        child: Center(
          child: Container(
            height: 87,
            decoration: BoxDecoration(
              border: Border.all(color: kAdeoOrangeH, width: 1.5),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      );
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Positioned(
          left: 115,
          bottom: 8,
          child: Image(
            image: AssetImage('assets/images/wrong.png'),
          ));
    }
    return Positioned(child: Container());
  }

  Positioned getAnswerMarker2(Answer answer) {
    if (!widget.enabled && answer == correctAnswer) {
      return Positioned(
          left: 115,
          bottom: 35,
          child: Image(
            image: AssetImage('assets/images/correct.png'),
          ));
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Positioned(
          left: 115,
          bottom: 8,
          child: Image(
            image: AssetImage('assets/images/wrong.png'),
          ));
    }
    return Positioned(child: Container());
  }
}

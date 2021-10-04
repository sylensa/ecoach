import 'dart:convert';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/results.dart';
import 'package:ecoach/widgets/questions_widget.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuizView extends StatefulWidget {
  QuizView(this.user, this.questions,
      {Key? key,
      this.level,
      this.course,
      required this.name,
      this.timeInSec = 60,
      this.speedTest = false,
      this.disableTime = false,
      this.diagnostic = false})
      : super(key: key);
  User user;
  Level? level;
  Course? course;
  List<Question> questions;
  int timeInSec;
  bool diagnostic;
  String name;
  bool disableTime;
  bool speedTest;

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final PageController controller;
  int currentQuestion = 0;
  List<QuestionWidget> questionWidgets = [];

  late CustomTimerController timerController;
  int countdownInSeconds = 0;
  DateTime startTime = DateTime.now();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  bool enabled = true;
  bool savedTest = false;
  late Duration duration;

  TestTaken? testTaken;
  TestTaken? testTakenSaved;

  late ItemScrollController numberingController;

  bool useTex = false;
  int finalQuestion = 0;

  @override
  void initState() {
    controller = PageController(initialPage: currentQuestion);
    numberingController = ItemScrollController();
    duration = Duration(seconds: widget.timeInSec);

    timerController = CustomTimerController();
    timerController.onSetStart(() {});
    timerController.onSetPause(() {});
    timerController.onSetReset(() {});

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
    timerController.reset();
  }

  onEnd() {
    print("timer ended");

    completeQuiz();
    timerController.dispose();
  }

  nextButton() {
    if (currentQuestion == widget.questions.length - 1) {
      return;
    }
    setState(() {
      currentQuestion++;

      controller.nextPage(
          duration: Duration(milliseconds: 700), curve: Curves.ease);

      numberingController.scrollTo(
          index: currentQuestion,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutCubic);

      if (widget.speedTest && enabled) {
        resetTimer();
      }
    });
  }

  double get score {
    int totalQuestions = widget.questions.length;
    int correctAnswers = correct;
    return correctAnswers / totalQuestions * 100;
  }

  int get correct {
    int score = 0;
    widget.questions.forEach((question) {
      if (question.isCorrect) score++;
    });
    return score;
  }

  int get wrong {
    int wrong = 0;
    widget.questions.forEach((question) {
      if (question.isWrong) wrong++;
    });
    return wrong;
  }

  int get unattempted {
    int unattempted = 0;
    widget.questions.forEach((question) {
      if (question.unattempted) unattempted++;
    });
    return unattempted;
  }

  String get responses {
    Map<String, dynamic> responses = Map();
    int i = 1;
    widget.questions.forEach((question) {
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

      responses["$i"] = answer;
      i++;
    });
    return jsonEncode(responses);
  }

  completeQuiz() async {
    if (!widget.disableTime) {
      timerController.dispose();
    }
    if (widget.speedTest) {
      finalQuestion = currentQuestion;
    }
    setState(() {
      enabled = false;
    });
    showLoaderDialog(context, message: "Test Completed\nSaving results");
    if (widget.speedTest) {
      await Future.delayed(Duration(seconds: 1));
    }
    testTaken = TestTaken(
        userId: widget.user.id,
        datetime: startTime,
        totalQuestions: widget.questions.length,
        courseId: widget.course!.id,
        testname: widget.name,
        testType: "diagnostic",
        testTime: widget.disableTime ? -1 : duration.inSeconds,
        usedTime: widget.disableTime
            ? DateTime.now().difference(startTime).inSeconds
            : duration.inSeconds - countdownInSeconds,
        responses: responses,
        score: score,
        correct: correct,
        wrong: wrong,
        unattempted: unattempted);

    saveTestTaken(testTaken!).then((value) {});
  }

  Future<void> saveTestTaken(TestTaken testTaken) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AppUrl.testTaken),
        headers: {
          "api-token": widget.user.token!,
          "Content-Type": "application/json"
        },
        body: json.encode(testTaken.toJson()),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        // print(responseData);
        if (responseData["status"] == true) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(responseData['message'])));
          print(response.body);
          print(responseData['data']);
          testTakenSaved = TestTaken.fromJson(responseData['data']);
          TestController().saveTestTaken(testTakenSaved!);

          setState(() {
            testTaken = testTakenSaved!;
            savedTest = true;
            enabled = false;
          });
        } else {
          print("not successful event");
        }
      } else {
        print("Failed ....");
        print(response.statusCode);
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save test. Please try again")));
      }
    } catch (e) {
      print(e);
    } finally {
      Navigator.pop(context);
      if (savedTest) {
        viewResults();
      }
    }
  }

  viewResults() {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ResultView(
          widget.user,
          test: testTakenSaved!,
          diagnostic: widget.diagnostic,
        ),
      ),
    ).then((value) {
      setState(() {
        currentQuestion = 0;
        controller.jumpToPage(currentQuestion);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF00C664)),
        child: Stack(children: [
          Positioned(
            top: 95,
            right: -120,
            left: -100,
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
                      widget.questions[i],
                      position: i,
                      enabled: enabled,
                      useTex: useTex,
                      callback: (Answer answer) {
                        if (widget.speedTest && answer.value == 0) {
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
                    if (widget.speedTest) return Container();
                    return Container(
                        child: SelectText("${(i + 1)}", i == currentQuestion,
                            normalSize: 28,
                            selectedSize: 45,
                            underlineSelected: true,
                            selectedColor: Color(0xFFFD6363),
                            color: Colors.white70, select: () {
                      if (widget.speedTest) {
                        return;
                      }
                      setState(() {
                        currentQuestion = i;
                      });

                      controller.jumpToPage(i);
                      controller.animateToPage(i,
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeInBack);
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

                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return PauseDialog(
                        time: countdownInSeconds,
                        callback: (action) {
                          Navigator.pop(context);
                          if (action == "resume") {
                            startTimer();
                          } else if (action == "quit") {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return MainHomePage(widget.user, index: 1);
                            }), (route) => false);
                          } else if (action == "end") {
                            completeQuiz();
                          }
                        },
                      );
                    });
              },
              child: CustomTimer(
                onBuildAction: enabled
                    ? CustomTimerAction.auto_start
                    : CustomTimerAction.go_to_end,
                builder: (CustomTimerRemainingTime remaining) {
                  countdownInSeconds = remaining.duration.inSeconds;
                  if (widget.disableTime) {
                    return Image(
                        image: AssetImage("assets/images/infinite.png"));
                  }
                  if (remaining.duration.inSeconds == 0) {
                    return Text("Time Up",
                        style:
                            TextStyle(color: Color(0xFF00C664), fontSize: 18));
                  }

                  return Text("${remaining.minutes}:${remaining.seconds}",
                      style: TextStyle(color: Color(0xFF00C664), fontSize: 28));
                },
                controller: timerController,
                from: duration,
                to: Duration(seconds: 0),
                onStart: () {},
                onPaused: () {},
                onReset: () {},
                onFinish: () {
                  print("finished");
                  onEnd();
                },
              ),
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
                      if (currentQuestion > 0 &&
                          (!widget.speedTest || widget.speedTest && !enabled))
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              controller.previousPage(
                                  duration: Duration(milliseconds: 700),
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
                      if (currentQuestion < widget.questions.length - 1 &&
                          !(!enabled &&
                              widget.speedTest &&
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
                          currentQuestion == widget.questions.length - 1)
                        VerticalDivider(width: 2, color: Colors.white),
                      if (!savedTest &&
                              currentQuestion == widget.questions.length - 1 ||
                          (!enabled &&
                              widget.speedTest &&
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
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class PauseDialog extends StatefulWidget {
  PauseDialog({Key? key, required this.time, required this.callback})
      : super(key: key);
  int time;
  Function(String action) callback;

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
              color: Color(0xFF00C664),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF05A958),
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
                        color: Color(0xFF05A958),
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

import 'dart:convert';

import 'package:ecoach/controllers/questions_controller.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/test_taken_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/results.dart';
import 'package:ecoach/widgets/questions_widget.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:http/http.dart' as http;

class QuizView extends StatefulWidget {
  QuizView(this.user, this.questions,
      {Key? key, this.level, this.course, this.diagnostic = false})
      : super(key: key);
  User user;
  Level? level;
  Course? course;
  List<Question> questions;
  bool diagnostic;

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final PageController controller;
  int currentQuestion = 0;
  List<QuestionWidget> questionWidgets = [];

  late CountdownController countdownTimerController;
  DateTime startTime = DateTime.now();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  CurrentRemainingTime? remainingTime;
  bool enabled = true;
  bool savedTest = false;
  Duration duration = Duration(minutes: 5);

  TestTaken? testTaken;
  TestTaken? testTakenSaved;

  late ScrollController numberingController;

  @override
  void initState() {
    controller = PageController(initialPage: currentQuestion);
    numberingController = ScrollController();
    countdownTimerController =
        CountdownController(duration: duration, onEnd: onEnd);

    countdownTimerController.start();

    super.initState();
  }

  onEnd() {
    print("timer ended");
    countdownTimerController.dispose();
    completeQuiz();
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
    countdownTimerController.stop();
    setState(() {
      enabled = false;
    });
    showLoaderDialog(context, message: "Saving results");

    testTaken = TestTaken(
        userId: widget.user.id,
        datetime: startTime,
        totalQuestions: widget.questions.length,
        courseId: widget.course!.id,
        testname: "Test Diagnotic",
        testType: "diagnostic",
        testTime: duration.inSeconds,
        usedTime: duration.inSeconds -
            countdownTimerController.currentDuration.inSeconds,
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
              child: SingleChildScrollView(
                controller: numberingController,
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Row(
                    children: [
                      for (int i = 0; i < widget.questions.length; i++)
                        SelectText("${(i + 1)}", i == currentQuestion,
                            normalSize: 28,
                            selectedSize: 45,
                            underlineSelected: true,
                            selectedColor: Color(0xFFFD6363),
                            color: Colors.white70, select: () {
                          setState(() {
                            currentQuestion = i;
                          });

                          controller.jumpToPage(i);
                          controller.animateToPage(i,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeInBack);
                        })
                    ],
                  ),
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
            top: 55,
            right: 20,
            child: GestureDetector(
              onTap: () {
                if (!enabled) {
                  return;
                }
                countdownTimerController.stop();
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return PauseDialog(
                        time:
                            countdownTimerController.currentDuration.inSeconds,
                        callback: (action) {
                          Navigator.pop(context);
                          if (action == "resume") {
                            countdownTimerController.start();
                          } else if (action == "quit") {
                          } else if (action == "end quiz") {}
                        },
                      );
                    });
              },
              child: Countdown(
                builder: (context, duration) {
                  if (duration.inSeconds == 0) {
                    return Text("Time Up",
                        style:
                            TextStyle(color: Color(0xFF00C664), fontSize: 18));
                  }
                  int min = (duration.inSeconds / 60).floor();
                  int sec = duration.inSeconds % 60;
                  return Text("$min:$sec",
                      style: TextStyle(color: Color(0xFF00C664), fontSize: 28));
                },
                countdownController: countdownTimerController,
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
                      if (currentQuestion > 0)
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              controller.previousPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.ease);
                              setState(() {
                                currentQuestion--;
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
                          child: TextButton(
                            onPressed: () {
                              controller.nextPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.ease);
                              setState(() {
                                currentQuestion++;
                                numberingController
                                    .jumpTo(currentQuestion * 30.0);
                              });
                            },
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
                          currentQuestion == widget.questions.length - 1)
                        Expanded(
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
                          child: TextButton(
                            onPressed: () {
                              viewResults();
                            },
                            child: Text(
                              "Results",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
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

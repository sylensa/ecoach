import 'package:ecoach/controllers/questions_controller.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/test_taken_db.dart';
import 'package:ecoach/views/results.dart';
import 'package:ecoach/widgets/questions_widget.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class QuizView extends StatefulWidget {
  QuizView(this.user, this.questions, {Key? key, this.level, this.course})
      : super(key: key);
  User user;
  Level? level;
  Course? course;
  List<Question> questions;

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
  Duration duration = Duration(minutes: 5);

  @override
  void initState() {
    controller = PageController(initialPage: currentQuestion);
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
    Map<int, dynamic> responses = Map();
    int i = 1;
    widget.questions.forEach((question) {
      Map<String, dynamic> answer = {
        "question_id": question.id,
        "topic_id": question.topicId,
        "selected_answer_id": question.selectedAnswer != null
            ? question.selectedAnswer!.id
            : null,
        "status": question.isCorrect
            ? "correct"
            : question.isWrong
                ? "wrong"
                : "unattempted",
      };

      responses[i] = answer;
      i++;
    });
    return responses.toString();
  }

  completeQuiz() async {
    countdownTimerController.stop();
    showLoaderDialog(context);
    await Future.delayed(Duration(seconds: 2));
    TestTaken testTaken = TestTaken(
        userId: widget.user.id,
        datetime: startTime,
        totalQuestions: widget.questions.length,
        courseId: widget.course!.id,
        testname: "Test Diagnotic",
        testType: "Dianotic",
        testTime: duration.inMinutes,
        responses: responses,
        score: score,
        correct: correct,
        wrong: wrong,
        unattempted: unattempted);

    TestController().saveTestTaken(testTaken);
    setState(() {
      enabled = false;
    });
    Navigator.pop(context);
  }

  viewResults() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DiagnoticResultView(widget.user),
      ),
    );
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (currentQuestion > 0)
                      TextButton(
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
                    if (currentQuestion < widget.questions.length - 1)
                      TextButton(
                        onPressed: () {
                          controller.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.ease);
                          setState(() {
                            currentQuestion++;
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
                    if (enabled &&
                        currentQuestion == widget.questions.length - 1)
                      TextButton(
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
                    if (!enabled)
                      TextButton(
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
                  ]),
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

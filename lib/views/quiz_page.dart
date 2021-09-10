import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subjects.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/questions_widget.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class QuizView extends StatefulWidget {
  QuizView(this.user, this.questions, {Key? key, this.level, this.subject})
      : super(key: key);
  User user;
  Level? level;
  Subject? subject;
  List<Question> questions;

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final PageController controller;
  int currentQuestion = 0;
  List<QuestionWidget> questionWidgets = [];

  late CountdownTimerController countdownTimerController;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  @override
  void initState() {
    controller = PageController(initialPage: currentQuestion);
    controller.addListener(() {
      print("listening...");
    });
    for (int i = 0; i < widget.questions.length; i++)
      questionWidgets.add(QuestionWidget(
        widget.questions[i],
        position: i,
      ));

    countdownTimerController =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);

    super.initState();
  }

  onEnd() {
    print("timer ended");
    countdownTimerController.disposeTimer();
    completeQuiz();
  }

  completeQuiz() {
    // showLoaderDialog(context);
    // Future.delayed(Duration(seconds: 2));
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  color: Color(0xFF636363),
                ),
                child: PageView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: questionWidgets,
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
                        selectText("${(i + 1)}", i == currentQuestion,
                            normalSize: 28, selectedSize: 45, select: () {
                          setState(() {
                            currentQuestion = i;
                          });

                          controller.jumpToPage(i);
                          controller.animateToPage(i,
                              duration: Duration(milliseconds: 100),
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
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return MainHomePage(widget.user);
                  }), (route) => false);
                },
                child: CountdownTimer(
                  controller: countdownTimerController,
                  onEnd: onEnd,
                  endTime: endTime,
                  widgetBuilder: (context, remainingTime) {
                    if (remainingTime == null) {
                      return Text("Time Up",
                          style: TextStyle(
                              color: Color(0xFF00C664), fontSize: 18));
                    }

                    return Text(
                        "${remainingTime.min ?? 0}:${remainingTime.sec}",
                        style:
                            TextStyle(color: Color(0xFF00C664), fontSize: 28));
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                          fontSize: 28,
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
                          fontSize: 28,
                        ),
                      ),
                    ),
                  if (currentQuestion == widget.questions.length - 1)
                    TextButton(
                      onPressed: () {
                        completeQuiz();
                      },
                      child: Text(
                        "Finish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

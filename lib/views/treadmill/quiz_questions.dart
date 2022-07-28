import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/actual_question.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
// import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
// import 'package:flutter_countdown_timer/current_remaining_time.dart';
//import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
//import 'package:flutter_countdown_timer/index.dart';
//import 'package:quiver/async.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../helper/helper.dart';
import '../../database/topics_db.dart';
import '../../utils/style_sheet.dart';
// import '../widgets/actual_question.dart';
// import '../widgets/completed.dart';

class QuizQuestion extends StatefulWidget {
  const QuizQuestion({
    Key? key,
    required this.controller,
    required this.questions,
    this.themeColor = kAdeoLightTeal,
  }) : super(key: key);

  final TreadmillController controller;
  final List<Question> questions;

  final Color themeColor;

  @override
  State<QuizQuestion> createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  late TreadmillController controller;

  int _currentSlide = 0;
  Timer? _timer;
  int questionIndex = 0;
  double? percentage;
  int _start = 0;
  List<Widget> slides = [];
  bool swichValue = false;
  bool selected = false;
  int counting = 6;
  bool progressCode = true;
  String errorMessage = "Fetching Questions";
  String ready = "0";
  double? value = 0.0;

  double values = 0;
  CountdownTimerController? controllerT;
  int endTime = 0;

  List<T> map<T>(int listLength, Function handler) {
    List list = [];
    for (var i = 0; i < listLength; i++) {
      list.add(i);
    }
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // getQuestions() async {
  //   try {
  //     var js = await doGet('questions/get?level_id=1&course_id=2&limit=20');
  //     //print("res comments: $js");
  //     if (js["status"] && js["data"].isNotEmpty) {
  //       for (int i = 0; i < js["data"].length; i++) {
  //         QuestionsResponse dataData =
  //             QuestionsResponse.fromJson(js["data"][i]);
  //         questions.add(dataData);
  //       }
  //     } else {
  //       errorMessage = "No Questions Available";
  //     }
  //     if (mounted) {
  //       setState(() {
  //         if (selectedTime_sec == 'null' || selectedTime_sec == null) {
  //           selectedTime_sec = "0";
  //           countdown += 0;
  //         } else {
  //           countdown += int.parse(selectedTime_sec!);
  //         }
  //         if (selectedTime_min == 'null' || selectedTime_min == null) {
  //           selectedTime_min = "0";
  //           countdown += 0;
  //         } else {
  //           countdown += int.parse(selectedTime_min!) * 60;
  //         }

  //         //ns = countdown;
  //         startTimer();
  //         //countdown = countdown_min! + countdown_sec!;
  //         //endTime = countdown_min! + countdown_sec!;
  //         //controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  //         progressCode = false;
  //         print("time $selectedTime_min");
  //         m = selectedTime_min;
  //         print("M $m");
  //         print("Time $selectedTime_sec");
  //         s = selectedTime_sec;
  //         print("S $s");
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         progressCode = false;
  //       });
  //       // return showDialogOk(
  //       //   message: 'Please check internet connectivity. And try again',
  //       //   context: context,
  //       //   target: const InstructionsPage(),
  //       //   status: true,
  //       //   replace: true,
  //       //   dismiss: false,
  //       // );
  //     }

  //     errorMessage = e.toString();
  //     print("error subscriptions: $e");
  //   }
  // }

  mark({int position = 0}) async {
    // setState(() {
    for (int t = 0; t < widget.questions[questionIndex].answers!.length; t++) {
      // questions[questionIndex].answers![t].answered = 0;
      // questions[questionIndex].correct = 0;
      // questions[questionIndex].skipped = 0;
    }

    //   final Answer qts = questions[questionIndex];
    //   qts.answers![position].answered = 1;
    //   if (questions[questionIndex].answers![position].value == 1) {
    //     qts.correct = 1;
    //     correct++;
    //   }
    //   if (questions[questionIndex].answers![position].value == 0) {
    //     wrong++;
    //   }
    //   percentage = (correct / 20) * 100;
    //   questions[questionIndex] = qts;
    // });
  }

  void startTimer() {
    _start = widget.controller.countdown;
    const oneSec = Duration(milliseconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0 && questionIndex != 19) {
          setState(() {
            // saveForLater();
            questionIndex++;
            _start = widget.controller.countdown;
            value = 0;
          });
        } else {
          setState(() {
            values = (_start - 1) / widget.controller.countdown;
            value = 1.0 - values;
            _start--;
          });
        }
        if (questionIndex == 19) {
          // mark(position: 19);
          if (value == 1) {
            _timer!.cancel();
            //  deleteSaveForLater();
            // saveCompleted();
            showDialogOk(
              message: 'Time is up. View Scores.',
              context: context,
              //   target: const Completed(),
              status: true,
              replace: true,
              dismiss: false,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    print("No of Questions = ${controller.questions.length}");
    controller.startTest();
    controller.endTreadmill();

    //countdown = 0;

    //controller = widget.controller;
    // correct = 0;
    // wrong = 0;
    // remainingTime = null;
    // questions.clear();
    // getQuestions();
  }

  // saveForLater() async {
  //   saved_correct = correct;
  //   saved_wrong = wrong;
  //   saved_questionIndex = questionIndex;
  //   if (percentage == null) {
  //     percentage = 0.00;
  //   }
  //   saved_percentage = percentage;
  //   save_ques = true;
  //   prefs = await SharedPreferences.getInstance();
  //   prefs?.setInt("countdown", countdown);
  //   prefs?.setInt("correct", saved_correct!);
  //   prefs?.setInt("wrong", saved_wrong!);
  //   prefs?.setInt("questionIndex", saved_questionIndex!);
  //   prefs?.setDouble("percentage", percentage!);
  //   prefs?.setBool("save_ques", save_ques!);
  // }

  // saveCompleted() async {
  //   prefs = await SharedPreferences.getInstance();
  //   prefs?.setInt("score", correct);
  //   prefs?.setInt("countdown", countdown);
  //   prefs?.setString("date", "${date}");
  //   prefs?.setString("time", "${currentTime}");
  //   // prefs?.setString("min", "$m");
  //   // prefs?.setString("sec", "$s");
  // }

  @override
  Widget build(BuildContext context) {
    // if (save_ques == false) {
    //   deleteSaveForLater();
    // }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        // saveForLater();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const DialogQuit(),
        //   ),
        // );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          actions: [
            Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: Stack(
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                      value: 0.7,
                    ),
                    Center(
                      child: Text(
                        widget.questions.isNotEmpty
                            ? '${questionIndex + 1}'
                            : '0',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
          title: Text(
            "${widget.controller.topicData!.name}",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            setState(() {
              questionIndex++;
            });
            //  saveForLater();
            if (questionIndex != 19) {
              _timer!.cancel();

              startTimer();
              questionIndex++;
              setState(() {});
            }

            if (questionIndex == 19) {
              mark(position: 19);

              if (value == 1) {
                _timer!.cancel();
                // deleteSaveForLater();
                // saveCompleted();
                // showDialogOk(
                //   message: 'Time is up. View Scores.',
                //   context: context,
                //   target: Container(),
                //   status: true,
                //   replace: true,
                //   dismiss: false,
                // );

              }
            }
          },
          child: Container(
            color: kAccessmentButtonColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const Text(
              'Skip',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xFF2D3E50),
              height: 47,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Treadmill",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9EE4FF),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  const SizedBox(
                    height: 16,
                    child: VerticalDivider(
                      color: Color(0xFF9EE4FF),
                      width: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    "assets/images/fav.svg",
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  percentage == null
                      ? const Text(
                          '0.00%',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9EE4FF),
                          ),
                        )
                      : Text(
                          "${percentage!.toStringAsFixed(2)}%",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9EE4FF),
                          ),
                        ),
                  const SizedBox(
                    width: 18.2,
                  ),
                  SvgPicture.asset(
                    "assets/images/speed.svg",
                  ),
                  const SizedBox(
                    width: 6.4,
                  ),
                  widget.controller.countdown == 0
                      ? const Text(
                          '0s',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9EE4FF),
                          ),
                        )
                      : Text(
                          '${widget.controller.countdown}s',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9EE4FF),
                          ),
                        ),
                  const SizedBox(
                    width: 17.6,
                  ),
                  Image.asset(
                    "assets/images/correct.png",
                    height: 13.8,
                    width: 13.8,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    "0",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9EE4FF),
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  Image.asset(
                    "assets/images/wrong.png",
                    height: 13.8,
                    width: 13.8,
                  ),
                  const SizedBox(
                    width: 6.4,
                  ),
                  const Text(
                    "0",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9EE4FF),
                    ),
                  ),
                  const SizedBox(
                    width: 4.2,
                  ),
                  const SizedBox(
                    height: 16,
                    child: VerticalDivider(
                      color: Color(0xFF9EE4FF),
                      width: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 6.2,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        swichValue = !swichValue;
                      });
                    },
                    child: SvgPicture.asset(
                      swichValue
                          ? "assets/images/off_switch.svg"
                          : "assets/images/on_switch.svg",
                    ),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: value,
            ),
            widget.questions.isNotEmpty
                ? Expanded(
                    child: ListView(
                      children: [
                        ActualQuestion(
                          question: "${widget.questions[questionIndex].text}",
                          user: widget.controller.user,
                          direction:
                              "Choose the right answer to the question above",
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        Container(
                          padding: const EdgeInsets.all(17.0),
                          decoration: const BoxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 26,
                              ),
                              for (int i = 0;
                                  i <
                                      widget.questions[questionIndex].answers!
                                          .length;
                                  i++)
                                GestureDetector(
                                  onTap: () async {
                                    _timer!.cancel();
                                    // saveForLater();

                                    startTimer();
                                    if (questionIndex == 19) {
                                      await mark(position: i);
                                      // saveCompleted();
                                      AlertDialog(
                                        title: Text("Alert"),
                                        content: const Text(
                                          'You\'re done answering all questions. View Scores.',
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text("No"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Container(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                      showDialogOk(
                                        message:
                                            'You\'re done answering all questions. View Scores.',
                                        context: context,
                                        target: Container(),
                                        status: true,
                                        replace: true,
                                        dismiss: false,
                                      );
                                    } else {
                                      await mark(position: i);
                                      questionIndex++;
                                    }
                                  },
                                  child: Container(
                                    child: AdeoHtmlTex(
                                      widget.controller.user,
                                      widget.questions[questionIndex]
                                          .answers![i].text!
                                          .replaceAll("https", "http"),
                                      textColor: Colors.black,
                                      removeBr: true,
                                    ),
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF0367B4)
                                          : const Color(0xFFE7E7E7),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xFFE7E7E7),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : progressCode
                    ? Expanded(
                        child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            progress(),
                            SizedBox(
                              height: 10,
                            ),
                            sText("$errorMessage", color: Colors.white)
                          ],
                        ),
                      ))
                    : Expanded(
                        child: Center(
                          child: sText("$errorMessage", color: Colors.white),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

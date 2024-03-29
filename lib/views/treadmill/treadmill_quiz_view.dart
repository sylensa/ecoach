import 'dart:async';
import 'dart:io';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/treadmill/treadmill_complete_congratulations.dart';
import 'package:ecoach/views/treadmill/treadmill_completed.dart';
import 'package:ecoach/views/treadmill/treadmill_ended.dart';
import 'package:ecoach/views/treadmill/treadmill_introit.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../controllers/quiz_controller.dart';
import '../../controllers/test_controller.dart';
import '../../helper/helper.dart';
import '../../models/flag_model.dart';
import '../../revamp/core/utils/app_colors.dart';
import '../../revamp/features/questions/view/widgets/actual_question.dart';
import '../../widgets/questions_widgets/adeo_html_tex.dart';

class TreadmillQuizView extends StatefulWidget {
  TreadmillQuizView({
    Key? key,
    required this.controller,
    this.mode,
    this.themeColor = kAdeoLightTeal,
  }) : super(key: key);

  final TreadmillController controller;
  final Color themeColor;
  final TreadmillMode? mode;

  @override
  State<TreadmillQuizView> createState() => _TreadmillQuizViewState();
}

class _TreadmillQuizViewState extends State<TreadmillQuizView>
    with SingleTickerProviderStateMixin {
  int selectedObjective = 0;
  List<ListNames> listReportsTypes = [
    ListNames(name: "Select Error Type", id: "0"),
    ListNames(name: "Typographical Mistake", id: "1"),
    ListNames(name: "Wrong Answer", id: "2"),
    ListNames(name: "Problem With The Question", id: "3")
  ];
  ListNames? reportTypes;
  TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionNode = FocusNode();
  late TreadmillController controller;
  late final PageController pageController;
  List<TreadmillQuestionWidget> questionWidgets = [];
  bool isCorrect = false;
  bool showSubmit = false;
  TestTaken? testTaken;
  int finalQuestion = 0;
  int _start = 0;
  bool changeUp = false;
  bool savedTest = false;
  bool showNext = false;
  double avgScore = 0;
  double avgTime = 0;
  int correct = 0;
  TestTaken? testTakenSaved;
  int wrong = 0;
  bool swichValue = false;
  double? value = 0.0;
  double values = 0;
  bool enabled = true;
  bool answered = false;
  var timeSpent = 0;
  var durationStart;
  int countdownInSeconds = 0;
  int questionTimer = 0;
  // StopW
  currentCorrectScoreState() async {
    setState(() {
      if (controller.questions[controller.currentQuestion].isCorrect) {
        isCorrect = true;
      } else {
        isCorrect = false;
      }
    });
  }

  avgTimeComplete() {
    print("avgTimeComplete");

    for (int i = 0; i < widget.controller.questions.length; i++) {
      controller.count += widget.controller.questions[i].question!.time!;
    }

    if (controller.count == 0 && controller.currentQuestion == 0) {
      controller.count = 0;
    } else {
      controller.count = controller.count / controller.currentQuestion;
    }

    return controller.count.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);
    var dateFormat = DateFormat('h:m:s');
    durationStart =
        dateFormat.parse(DateFormat('hh:mm:ss').format(DateTime.now()));
    print("No of Questions = ${controller.questions.length}");
    print("CURRENT QUESTION ================= ${controller.currentQuestion}");
    print(controller.time);
    Future.delayed(Duration.zero, () {
      controller.startTest();
    });
  }

  @override
  void dispose() {
    controller.stopTimer();
    super.dispose();
  }

  void handleObjectiveSelection(id) {
    setState(() {
      selectedObjective = id;
    });
  }

  next() {
    setState(() {
      showSubmit = true;
    });

    if (controller.lastQuestion) {
      setState(() {
        controller.pauseTimer();
        controller.stopTimer();
      });
      return;
    }
  }

  nextButton() {
    setState(() {
      showNext = false;
      controller.reviewMode = false;
      controller.nextQuestion();
      controller.resetTimer();
      pageController.nextPage(
        duration: Duration(milliseconds: 1),
        curve: Curves.ease,
      );
    });
  }

  void timerValueChangeListener(Duration timeElapsed) {
    print("timer change ${timeElapsed.inSeconds}");
  }

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }

  onEnd() {
    print("timer ended");
    print("timer ended");
    print("timer ended");

    controller.endTreadmill();
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return SpeedQuizEnded(controller: controller);
    }));
  }

  insertSaveTestQuestion(int qid) async {
    await TestController().insertSaveTestQuestion(qid);
    setState(() {
      print("savedQuestions2:$savedQuestions");
    });
  }

  completeQuiz() async {
    controller.pauseTimer();

    print('++++++++++++++++++++++++++++++');
    // setState(() {
    //   enabled = false;
    //   answered = true;
    // });
    showLoaderDialog(context, message: "Test Completed\nSaving results");

    widget.controller.saveTest(context, (test, success) {
      Navigator.pop(context);
      if (success) {
        testTakenSaved = test;
        setState(() {
          print('setState');
          testTaken = testTakenSaved;

          savedTest = true;
          enabled = false;
        });
        viewResults();
        controller.endTreadmill();
      } else {
        // Navigator.pop(context);
        print("success $success");
      }
    });
  }

  submitAnswer() async {
    answered = true;
    controller.pauseTimer();
    await scoreCurrentQuestion(
        controller.questions[controller.currentQuestion].question!);
    await controller.scoreCurrentQuestion();
    double newScore = controller.treadmill!.avgScore!;
    if (mounted) {
      setState(() {
        currentCorrectScoreState();
        showSubmit = false;
        if (newScore != avgScore) {
          changeUp = newScore > avgScore;
        }
        avgScore = newScore;
      });
    }

    if (controller.lastQuestion) {
      testTaken = controller.getTest();

      controller.resumeTimer();
      completeQuiz();
    } else {
      setState(() {
        controller.nextQuestion();
        answered = false;
        pageController.nextPage(
            duration: Duration(milliseconds: 1), curve: Curves.ease);
      });
    }
  }

  viewResults() {
    print("viewing results");

    goTo(
        context,
        TreadmillCompleteCongratulations(
          correct: correct,
          wrong: wrong,
          avgScore: avgScore,
          controller: controller,
          mode: widget.mode,
          // avgTimeComplete: avgTimeComplete(),
        ),
        replace: true);
    // .then((value) {
    //   setState(() {
    //     controller.currentQuestion = 0;
    //     controller.reviewMode = true;
    //     pageController.jumpToPage(controller.currentQuestion);
    //   });
    // });
  }

  bool showPreviousButton() {
    return controller.reviewMode && controller.currentQuestion > 0;
  }

  bool showNextButton() {
    return controller.reviewMode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // printtimerController.pause();
        setState(() {
          controller.pauseTimer();
        });

        Get.bottomSheet(quitWidget());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(245, 245, 245, 1),
          body: Column(
            children: [
              if (Platform.isIOS)
                const SizedBox(
                  height: 30,
                ),
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          controller.pauseTimer();
                        });

                        Get.bottomSheet(quitWidget());
                        return;
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Container(
                        width: 250,
                        child: Text(
                          controller.name!,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 20,
                      lineWidth: 3,
                      progressColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      percent: controller.percentageCompleted,
                      center: Text(
                        "${controller.currentQuestion + 1}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Cocon',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        controller.pauseTimer();

                        await reportModalBottomSheet(context,
                            question: widget
                                .controller
                                .questions[controller.currentQuestion]
                                .question);
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              getQuestionStats(),
              getTimerWidget(),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    for (int i = 0; i < controller.questions.length; i++)
                      // TreadmillQuestionWidget(
                      //   controller.user,
                      //   controller.questions[i].question!,
                      //   position: i,
                      //   enabled: !showNext,
                      //   callback: (Answer answer, correct) async {
                      //     next();
                      //   },
                      //   themeColor: widget.themeColor,
                      // )
                      Column(
                        children: [
                          ActualQuestion(
                            user: controller.user,
                            question:
                                "${controller.questions[i].question!.text}",
                            diagnostic: false,
                            direction:
                                "Choose the right answer to the question above",
                          ),
                          const SizedBox(
                            height: 26,
                          ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Visibility(
                                      visible: controller
                                              .questions[
                                                  controller.currentQuestion]
                                              .question!
                                              .instructions!
                                              .isNotEmpty
                                          ? true
                                          : false,
                                      child: Card(
                                          elevation: 0,
                                          color: Colors.white,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: AdeoHtmlTex(
                                            controller.user,
                                            controller
                                                .questions[
                                                    controller.currentQuestion]
                                                .question!
                                                .instructions!,
                                            useLocalImage: false,
                                            fontWeight: FontWeight.normal,
                                            textColor: Colors.black,
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        avgTimeComplete();
                                        // print("object");
                                      },
                                      child: Visibility(
                                        visible: widget
                                                .controller
                                                .questions[
                                                    controller.currentQuestion]
                                                .question!
                                                .resource!
                                                .isNotEmpty
                                            ? true
                                            : false,
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.white,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: AdeoHtmlTex(
                                            controller.user,
                                            widget
                                                .controller
                                                .questions[
                                                    controller.currentQuestion]
                                                .question!
                                                .resource!,
                                            // removeTags:  widget.controller.questions[i].question!.resource!.contains("src") ? false : true,

                                            textColor: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...List.generate(
                                        widget
                                            .controller
                                            .questions[
                                                controller.currentQuestion]
                                            .question!
                                            .answers!
                                            .length, (index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            widget
                                                    .controller
                                                    .questions[controller
                                                        .currentQuestion]
                                                    .question!
                                                    .selectedAnswer =
                                                widget
                                                    .controller
                                                    .questions[controller
                                                        .currentQuestion]
                                                    .question!
                                                    .answers![index];
                                            var dateFormat =
                                                DateFormat('h:m:s');
                                            DateTime durationEnd = dateFormat
                                                .parse(DateFormat('hh:mm:ss')
                                                    .format(DateTime.now()));
                                            timeSpent = durationEnd
                                                .difference(durationStart)
                                                .inSeconds;
                                            widget
                                                .controller
                                                .questions[
                                                    controller.currentQuestion]
                                                .question!
                                                .time = timeSpent;
                                            durationStart = dateFormat.parse(
                                                DateFormat('hh:mm:ss')
                                                    .format(DateTime.now()));
                                          });

                                          await submitAnswer();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10, right: 20, left: 20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: AdeoHtmlTex(
                                                  controller.user,
                                                  controller
                                                      .questions[controller
                                                          .currentQuestion]
                                                      .question!
                                                      .answers![index]
                                                      .text!,
                                                  textColor: widget
                                                              .controller
                                                              .questions[controller
                                                                  .currentQuestion]
                                                              .question!
                                                              .selectedAnswer ==
                                                          widget
                                                              .controller
                                                              .questions[controller
                                                                  .currentQuestion]
                                                              .question!
                                                              .answers![index]
                                                      ? Colors.white
                                                      : kSecondaryTextColor,
                                                  fontSize: widget
                                                              .controller
                                                              .questions[controller
                                                                  .currentQuestion]
                                                              .question!
                                                              .selectedAnswer ==
                                                          widget
                                                              .controller
                                                              .questions[controller
                                                                  .currentQuestion]
                                                              .question!
                                                              .answers![index]
                                                      ? 25
                                                      : 16,
                                                  textAlign: TextAlign.left,
                                                  fontWeight: FontWeight.bold,
                                                  removeBr: true,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(
                                                Icons.radio_button_off,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: widget
                                                        .controller
                                                        .questions[controller
                                                            .currentQuestion]
                                                        .question!
                                                        .selectedAnswer ==
                                                    widget
                                                        .controller
                                                        .questions[controller
                                                            .currentQuestion]
                                                        .question!
                                                        .answers![index]
                                                ? const Color(0xFF0367B4)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              width: widget
                                                          .controller
                                                          .questions[controller
                                                              .currentQuestion]
                                                          .question!
                                                          .selectedAnswer ==
                                                      widget
                                                          .controller
                                                          .questions[controller
                                                              .currentQuestion]
                                                          .question!
                                                          .answers![index]
                                                  ? 1
                                                  : 1,
                                              color: widget
                                                          .controller
                                                          .questions[controller
                                                              .currentQuestion]
                                                          .question!
                                                          .selectedAnswer ==
                                                      widget
                                                          .controller
                                                          .questions[controller
                                                              .currentQuestion]
                                                          .question!
                                                          .answers![index]
                                                  ? Colors.transparent
                                                  : const Color(0xFFC8C8C8),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (controller.currentQuestion <
                            widget.controller.questions.length - 1 &&
                        !(!enabled &&
                            controller.speedTest &&
                            controller.currentQuestion == finalQuestion))
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            // Get.to(() => const QuizReviewPage());
                            if (controller.currentQuestion ==
                                widget.controller.questions.length - 1) {
                              return;
                            }
                            setState(() {});

                            await submitAnswer();
                          },
                          child: Container(
                            color: kAccessmentButtonColor,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text(
                              'Skip',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (!savedTest &&
                            controller.currentQuestion ==
                                widget.controller.questions.length - 1 ||
                        (enabled &&
                            controller.speedTest &&
                            controller.currentQuestion == finalQuestion))
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {});

                            await submitAnswer();
                          },
                          child: Container(
                            color: kAccessmentButtonColor,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text(
                              'Complete',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getQuestionStats() {
    return Container(
      color: const Color(0xFF2D3E50),
      height: 47,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Treadmill',
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
          isCorrect
              ? Image.asset(
                  "assets/images/un_fav.png",
                  color: Colors.green,
                )
              : SvgPicture.asset(
                  "assets/images/fav.svg",
                ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "${controller.getAvgScore().toStringAsFixed(2)}%",
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
          Text(
            "${widget.controller.getAvgTime().toStringAsFixed(2)}s",
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9EE4FF),
            ),
          ),
          const SizedBox(
            width: 17.6,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            controller.getTotalCorrect().toString(),
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9EE4FF),
            ),
          ),
          const SizedBox(
            width: 17,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 16,
            ),
          ),
          const SizedBox(
            width: 6.4,
          ),
          Text(
            controller.getTotalWrong().toString(),
            style: const TextStyle(
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
              insertSaveTestQuestion(controller
                  .questions[controller.currentQuestion].question!.id!);
            },
            child: SvgPicture.asset(
              savedQuestions.contains(controller
                      .questions[controller.currentQuestion].question!.id)
                  ? "assets/images/on_switch.svg"
                  : "assets/images/off_switch.svg",
            ),
          ),
        ],
      ),
    );
  }

  reportModalBottomSheet(context, {Question? question}) async {
    double sheetHeight = 440.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              controller.resumeTimer();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                right: 20,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        child: Icon(
                          Icons.warning,
                          color: Colors.orange,
                          size: 50,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[200]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: sText("Error Reporting",
                            weight: FontWeight.bold, size: 20),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.only(left: 12, right: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ListNames>(
                                    value: reportTypes == null
                                        ? listReportsTypes[0]
                                        : reportTypes,
                                    itemHeight: 48,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: kDefaultBlack,
                                    ),
                                    // onTap: (){
                                    //   stateSetter((){
                                    //     sheetHeight = 400;
                                    //   });
                                    // },

                                    onChanged: (ListNames? value) {
                                      stateSetter(() {
                                        reportTypes = value;
                                        sheetHeight = 700;
                                        FocusScope.of(context)
                                            .requestFocus(descriptionNode);
                                      });
                                    },
                                    items: listReportsTypes
                                        .map(
                                          (item) => DropdownMenuItem<ListNames>(
                                            value: item,
                                            child: Text(
                                              item.name,
                                              style: const TextStyle(
                                                color: kDefaultBlack,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      // autofocus: true,
                                      controller: descriptionController,
                                      focusNode: descriptionNode,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please check that you\'ve entered your email correctly';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        stateSetter(() {
                                          sheetHeight = 440;
                                        });
                                      },
                                      onTap: () {
                                        stateSetter(() {
                                          sheetHeight = 700;
                                        });
                                      },
                                      decoration: textDecorNoBorder(
                                        hint: 'Description',
                                        radius: 10,
                                        labelText: "Description",
                                        hintColor: Colors.black,
                                        fill: Colors.white,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // print("${reportTypes}");
                          if (descriptionController.text.isNotEmpty) {
                            if (reportTypes != null) {
                              stateSetter(() {
                                isSubmit = false;
                              });
                              try {
                                FlagData flagData = FlagData(
                                    reason: descriptionController.text,
                                    type: reportTypes!.name,
                                    questionId: question!.id);
                                var res = await QuizController(
                                        controller.user, controller.course,
                                        name: "")
                                    .saveFlagQuestion(
                                        context, flagData, question.id!);
                                print("final res:$res");
                                if (res) {
                                  stateSetter(() {
                                    descriptionController.clear();
                                  });
                                  Navigator.pop(context);
                                  successModalBottomSheet(context);
                                } else {
                                  Navigator.pop(context);
                                  failedModalBottomSheet(context);
                                  // print("object res: $res");
                                }
                              } catch (e) {
                                stateSetter(() {
                                  isSubmit = true;
                                });
                                print("error: $e");
                              }
                            } else {
                              toastMessage("Select error type");
                            }
                          } else {
                            toastMessage("Description is required");
                          }
                        },
                        child: Container(
                          padding: appPadding(20),
                          width: appWidth(context),
                          color: isSubmit ? Colors.blue : Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              sText("Submit",
                                  align: TextAlign.center,
                                  weight: FontWeight.bold,
                                  color: isSubmit ? Colors.white : Colors.black,
                                  size: 25),
                              const SizedBox(
                                width: 10,
                              ),
                              isSubmit ? Container() : progress()
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            },
          );
        });
  }

  quitWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: SizedBox(
              width: 20,
              child: Divider(
                thickness: 3,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Are you sure you want to quit the test",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF606C7A),
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 33),
          OutlinedButton(
            onPressed: () {
              setState(() {
                // submitAnswer();
                controller.stopTimer();
              });

              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => MainHomePage(
                    controller.user,
                  ),
                ),
                (route) => false,
              );
            },
            style: ButtonStyle(
              animationDuration: const Duration(milliseconds: 200),
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                vertical: 17,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),

              side: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) {
                  return states.contains(MaterialState.pressed)
                      ? BorderSide.none
                      : const BorderSide(
                          color: Color(0xFF707070),
                          width: 1,
                        );
                },
              ),
              // backgroundColor: MaterialStateProperty.resolveWith(
              //   (states) => states.contains(MaterialState.pressed)
              //       ? Colors.red
              //       : Colors.white,
              // ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed)
                    ? Colors.white
                    : Colors.black,
              ),
              overlayColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed)
                    ? Color(0xFFFF6060)
                    : Colors.white,
              ),
            ),
            child: Text(
              "Save & Quit",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              setState(() {
                controller.resumeTimer();
              });

              Navigator.pop(context);
            },
            style: ButtonStyle(
              animationDuration: const Duration(milliseconds: 200),
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                vertical: 17,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),

              side: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) {
                  return states.contains(MaterialState.pressed)
                      ? BorderSide.none
                      : const BorderSide(
                          color: Color(0xFF707070),
                          width: 1,
                        );
                },
              ),
              // backgroundColor: MaterialStateProperty.resolveWith(
              //   (states) => states.contains(MaterialState.pressed)
              //       ? Colors.red
              //       : Colors.white,
              // ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed)
                    ? Colors.white
                    : Colors.black,
              ),
              overlayColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed)
                    ? Color(0xFF00C664)
                    : Colors.white,
              ),
            ),
            child: Text(
              "Cancel",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              // startTimer();
              controller.endTreadmill();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => MainHomePage(
                    controller.user,
                  ),
                ),
                (route) => false,
              );
              // Navigator.popUntil(
              //   context,
              //   ModalRoute.withName(CoursesDetailsPage.routeName),
              // );
            },
            style: ButtonStyle(
              animationDuration: const Duration(milliseconds: 200),
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                vertical: 17,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),

              side: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) {
                  return states.contains(MaterialState.pressed)
                      ? BorderSide.none
                      : const BorderSide(
                          color: Color(0xFF707070),
                          width: 1,
                        );
                },
              ),
              // backgroundColor: MaterialStateProperty.resolveWith(
              //   (states) => states.contains(MaterialState.pressed)
              //       ? Colors.red
              //       : Colors.white,
              // ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed)
                    ? Colors.white
                    : Colors.black,
              ),
              overlayColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed)
                    ? Color(0xFF00C664)
                    : Colors.white,
              ),
            ),
            child: Text(
              "Complete & Exit",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  Widget getTimerWidget() {
    return AdeoTimer(
        controller: controller.speedtimerController!,
        startDuration: controller.duration!,
        callbackWidget: (time) {
          print("duration=${controller.duration!.inSeconds}, time= ${time}");
          Duration remaining = Duration(seconds: time.toInt());
          controller.duration = remaining;
          countdownInSeconds = remaining.inSeconds;

          print("remaining time: ${remaining.inMilliseconds}");
          if (answered) {
            return FAProgressBar(
              changeColorValue: 100,
              changeProgressColor: Color(0xFF87F6FF),
              backgroundColor: Colors.white,
              progressColor: Color(0xFF87F6FF),
              animatedDuration: controller.duration!,
              direction: Axis.horizontal,
              verticalDirection: VerticalDirection.up,
              currentValue: controller.timerProgress().toDouble(),
              maxValue: controller.resetDuration!.inSeconds.toDouble(),
              size: 8,
            );
          }
          if (remaining.inSeconds == 0) {
            submitAnswer();
            return FAProgressBar(
              changeColorValue: 100,
              changeProgressColor: Color(0xFF87F6FF),
              backgroundColor: Colors.white,
              progressColor: Color(0xFF87F6FF),
              animatedDuration: controller.duration!,
              direction: Axis.horizontal,
              verticalDirection: VerticalDirection.up,
              currentValue: controller.timerProgress().toDouble(),
              maxValue: controller.resetDuration!.inSeconds.toDouble(),
              size: 8,
            );
          }
          if (controller.currentQuestion ==
              widget.controller.questions.length - 1) {
            submitAnswer();
            // showDialogOk(
            //   message: 'Time is up. View Scores.',
            //   context: context,
            //   target: TreadmillCompleteCongratulations(
            //     controller: widget.controller,
            //     correct: correct,
            //     wrong: wrong,
            //     avgScore: avgScore,
            //   ),
            //   // target: TreadmillCompleted(
            //   //     widget.controller.user, widget.controller.course),
            //   status: true,
            //   replace: true,
            //   dismiss: false,
            // );
          }
          return TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            tween: Tween<double>(
              begin: 0,
              end: controller.timerPercentage(),
            ),
            builder: (context, value, _) => LinearProgressIndicator(
              backgroundColor: Colors.grey,
              value: value,
              minHeight: 8,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF87F6FF)),
            ),
          );
        },
        onFinish: () {
          print("Finished"); // onEnd();
        });
  }

  successModalBottomSheet(context, {Question? question}) {
    double sheetHeight = 350.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              //timerController.resume();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.green, width: 15),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 100,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: sText("Error report successfully submitted",
                            weight: FontWeight.bold,
                            size: 20,
                            align: TextAlign.center),
                      )
                    ],
                  ));
            },
          );
        });
  }

  failedModalBottomSheet(context, {Question? question}) {
    double sheetHeight = 330.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              //  timerController.resume();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.red, width: 15),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 100,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: sText("Error report failed try again",
                            weight: FontWeight.bold,
                            size: 20,
                            align: TextAlign.center),
                      )
                    ],
                  ));
            },
          );
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
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainHomePage(
                        controller.user,
                      ),
                    ),
                    (route) => false,
                  );
                  // Navigator.popUntil(
                  //   context,
                  //   ModalRoute.withName(CoursesDetailsPage.routeName),
                  // );
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
    if (!showSubmit) return false;
    controller.pauseTimer();
    return (await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return PauseMenuDialog(
                themeColor: widget.themeColor,
                controller: controller,
              );
            })) ??
        false;
  }
}

Future<bool> showPopup(BuildContext context, Widget dialog) async {
  return (await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return dialog;
        },
      )) ??
      false;
}

class PauseMenuDialog extends StatefulWidget {
  const PauseMenuDialog({
    Key? key,
    required this.themeColor,
    required this.controller,
  }) : super(key: key);

  final Color themeColor;
  final TreadmillController controller;

  @override
  _PauseMenuDialogState createState() => _PauseMenuDialogState();
}

class _PauseMenuDialogState extends State<PauseMenuDialog> {
  int selected = -1;

  late TreadmillController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  handleSelection(id) {
    setState(() {
      selected = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 53),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                color: kAdeoRoyalBlue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Objective(
                        controller.user,
                        id: 5,
                        label: 'submit & save',
                        themeColor: widget.themeColor,
                        isSelected: selected == 5,
                        onTap: handleSelection,
                      ),
                      Objective(
                        controller.user,
                        id: 6,
                        label: 'submit & end',
                        themeColor: widget.themeColor,
                        isSelected: selected == 6,
                        onTap: handleSelection,
                      ),
                      Objective(
                        controller.user,
                        id: 7,
                        label: 'submit & pause',
                        themeColor: widget.themeColor,
                        isSelected: selected == 7,
                        onTap: handleSelection,
                      ),
                      Objective(
                        controller.user,
                        id: 8,
                        label: 'resume',
                        themeColor: widget.themeColor,
                        isSelected: selected == 8,
                        onTap: handleSelection,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selected > -1)
              Container(
                child: AdeoTextButton(
                  label: 'Submit',
                  onPressed: () {
                    switch (selected) {
                      case 5:
                        showPopup(context,
                            SessionSavedPrompt(controller: controller));
                        break;
                      case 6:
                        controller.endTreadmill();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (c) {
                            return TreadmillEnded(controller: controller);
                          }),
                        );
                        break;
                      case 7:
                        controller.scoreCurrentQuestion();
                        showPopup(context, TestPausedPrompt());
                        break;
                      case 8:
                        controller.resumeTimer();
                        Navigator.pop(context);
                        break;
                    }
                  },
                  background: kAdeoLightTeal,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class SessionSavedPrompt extends StatelessWidget {
  const SessionSavedPrompt({Key? key, required this.controller})
      : super(key: key);
  final TreadmillController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.scoreCurrentQuestion();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => MainHomePage(
              controller.user,
            ),
          ),
          (route) => false,
        );
        // Navigator.popUntil(
        //     context, ModalRoute.withName(CoursesDetailsPage.routeName));
        return false;
      },
      child: Scaffold(
        backgroundColor: kAdeoRoyalBlue,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Session Saved',
                  style: TextStyle(
                    fontSize: 52,
                    fontFamily: 'Hamelin',
                    color: kAdeoBlue,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Continue whenever\nyou are ready',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kAdeoBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 64),
                AdeoOutlinedButton(
                  label: 'Exit',
                  onPressed: () {
                    controller.scoreCurrentQuestion();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MainHomePage(
                          controller.user,
                        ),
                      ),
                      (route) => false,
                    );
                    // Navigator.popUntil(context,
                    //     ModalRoute.withName(CoursesDetailsPage.routeName));
                  },
                  size: Sizes.large,
                  color: Color(0xFFFF4949),
                  borderRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestPausedPrompt extends StatelessWidget {
  const TestPausedPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Test Paused',
                style: TextStyle(
                  fontSize: 52,
                  fontFamily: 'Hamelin',
                  color: kAdeoBlue,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'Continue whenever\nyou are ready',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 64),
              AdeoOutlinedButton(
                label: 'Resume',
                onPressed: () {
                  Navigator.pop(context);
                },
                size: Sizes.large,
                color: kAdeoBlue,
                borderRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreadmillQuestionWidget extends StatefulWidget {
  TreadmillQuestionWidget(
    this.user,
    this.question, {
    Key? key,
    this.position,
    this.enabled = true,
    this.callback,
    this.themeColor = kAdeoLightTeal,
  }) : super(key: key);

  final User user;
  final Question question;
  final int? position;
  final bool enabled;
  final Color themeColor;
  final Function(Answer selectedAnswer, bool correct)? callback;

  @override
  _TreadmillQuestionWidgetState createState() =>
      _TreadmillQuestionWidgetState();
}

class _TreadmillQuestionWidgetState extends State<TreadmillQuestionWidget> {
  int selectedObjective = -1;

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
        print("anwer id=${answer.id}");
        print("question id=${answer.questionId}");
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
          Instruction(
            widget.user,
            instruction: widget.question.instructions!,
          ),
          DetailedInstruction(widget.user, details: widget.question.resource!),
          Container(
            width: double.infinity,
            height: 10,
            color: widget.themeColor,
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
                      themeColor: widget.themeColor,
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
        ),
      );
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Positioned(
        left: 5,
        bottom: 5,
        child: Image(
          image: AssetImage('assets/images/wrong.png'),
        ),
      );
    }
    return Positioned(child: Container());
  }
}

class SpeedQuizEnded extends StatelessWidget {
  SpeedQuizEnded({required this.controller});
  final TreadmillController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AdeoOutlinedButton(
                label: 'Exit',
                size: Sizes.small,
                color: kAdeoOrange,
                borderRadius: 1,
                fontSize: 14,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainHomePage(
                        controller.user,
                      ),
                    ),
                    (route) => false,
                  );
                  // Navigator.popUntil(
                  //   context,
                  //   ModalRoute.withName(CoursesDetailsPage.routeName),
                  // );
                },
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 33),
          Text(
            'Congratulations',
            style: TextStyle(
              fontSize: 41.sp,
              fontFamily: 'Poppins',
              color: kAdeoBlue,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Speed Test Run ',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Questions Attempted :   ${controller.treadmill!.totalCorrect! + controller.treadmill!.totalWrong!} / ${controller.questions.length}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Net Points: ',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: kAdeoBlueAccent,
                        ),
                      ),
                      Image.asset(
                        'assets/icons/plus.png',
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${controller.treadmill!.totalCorrect! - controller.treadmill!.totalWrong!}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: kAdeoBlueAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  QuizStats(
                    changeUp: true,
                    averageScore:
                        '${controller.getAvgScore().toStringAsFixed(2)}%',
                    speed: '${controller.getAvgTime().toStringAsFixed(2)}s',
                    correctScore: '${controller.getTotalCorrect()}',
                    wrongScrore: '${controller.getTotalWrong()}',
                  ),
                  SizedBox(height: 96),
                ],
              ),
            ),
          ),
          Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'review',
                          fontSize: 20,
                          color: Colors.white,
                          background: kAdeoBlue,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: kAdeoBlueAccent,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'result',
                          fontSize: 20,
                          color: Colors.white,
                          background: kAdeoBlue,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (c) {
                                return TreadmillIntroit(
                                    controller.user, controller.course, null);
                              }),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: kAdeoBlueAccent,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AdeoTextButton(
                    label: 'new test',
                    fontSize: 20,
                    color: Colors.white,
                    background: kAdeoBlue,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) {
                          return TreadmillIntroit(
                              controller.user, controller.course, null);
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

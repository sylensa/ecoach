import 'dart:convert';

import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/lib/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/lib/features/questions/view/widgets/actual_question.dart';
import 'package:ecoach/lib/features/questions/view/widgets/end_question.dart';
import 'package:ecoach/lib/features/questions/view/widgets/question_answer.dart';
import 'package:ecoach/lib/features/questions/view/widgets/questions_app_bar.dart';
import 'package:ecoach/lib/features/questions/view/widgets/questions_header.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../core/utils/app_colors.dart';

class QuizQuestion extends StatefulWidget {
  QuizQuestion(
      {Key? key,
        required this.controller,
        this.theme = QuizTheme.GREEN,
        this.diagnostic = false})
      : super(key: key);

  QuizController controller;
  bool diagnostic;
  QuizTheme theme;

  @override
  State<QuizQuestion> createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
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
  List<ListNames> listReportsTypes = [ListNames(name: "Select Error Type",id: "0"),ListNames(name: "Typographical Mistake",id: "1"),ListNames(name: "Wrong Answer",id: "2"),ListNames(name: "Problem With The Question",id: "3")];
  ListNames? reportTypes;
  TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionNode = FocusNode();
  double totalAverage = 0.0;
  var timeSpent = 0;
  var avgTimeSpent = 0;
  var durationStart ;
  Duration remainingTimeQuestion = Duration(seconds: 0);
  @override
  void initState() {
    var dateFormat = DateFormat('h:m:s');
    durationStart = dateFormat.parse(DateFormat('hh:mm:ss').format(DateTime.now()));

    getAllSaveTestQuestions();
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
      avgScore ();
      pageController.nextPage(
          duration: Duration(seconds: 1), curve: Curves.ease);

      // numberingController.scrollTo(
      //     index: currentQuestion,
      //     duration: Duration(seconds: 1),
      //     curve: Curves.easeInOutCubic);

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

  avgTimeComplete(){
    int count = 0;
    for(int i = 0; i <  controller.questions.length; i++){
      count += controller.questions[i].time!;
    }
    return count;
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
          controller.type,
          controller: controller,
          testCategory: controller.challengeType,
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
  bool swichValue = false;
  insertSaveTestQuestion(int qid)async{
    await TestController().insertSaveTestQuestion(qid);
    setState(() {
      print("savedQuestions2:$savedQuestions");
    });
  }
  getAllSaveTestQuestions()async{
    await TestController().getAllSaveTestQuestions();
    setState(() {
      print("again savedQuestions:${savedQuestions}");
    });

  }

  avgScore () {
    print("avg scoring current question= $currentQuestion");
    int totalQuestions = currentQuestion + 1;

    int correctAnswers = correct;
    if (totalQuestions == 0) {
      return 0;
    }
    totalAverage = correctAnswers / totalQuestions * 100;
    setState((){

    });
  }
  correctScore () {
    print("avg scoring current question= $currentQuestion");
    int totalQuestions = currentQuestion + 1;

    int correctAnswers = correct;
    if (totalQuestions == 0) {
      return 0;
    }
    totalAverage = correctAnswers / totalQuestions * 100;
    setState((){

    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        timerController.pause();
        Get.bottomSheet(quitWidget());
        return false;
      },
      child: Scaffold(
        appBar:   AppBar(
          actions: [
            Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: Stack(
                  children:  [
                    CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                      value: currentQuestion == controller.questions.length -1 ? 1 :  currentQuestion/(controller.questions.length -1),
                    ),
                    Center(
                      child: Text(
                        "${currentQuestion + 1}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(onPressed: ()async{
              timerController.pause();
              await reportModalBottomSheet(context,question: controller.questions[currentQuestion]);

            }, icon: Icon(Icons.more_vert,color: Colors.white,)),
          ],
          title:  Text(
            controller.name,
            style: TextStyle(fontSize: 14),
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
                  getTimerWidget(),
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
                   Text(
                    "${totalAverage.toStringAsFixed(2)}%",
                    style: TextStyle(
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
                    "${avgTimeComplete()}s",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9EE4FF),
                    ),
                  ),
                  const SizedBox(
                    width: 17.6,
                  ),
                  SvgPicture.asset(
                    "assets/images/add.svg",
                    height: 13.8,
                    width: 13.8,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                   Text(
                    "$correct",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9EE4FF),
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  const Icon(
                    Icons.remove,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 6.4,
                  ),
                   Text(
                    "$wrong",
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
                      insertSaveTestQuestion(controller.questions[currentQuestion].id!);
                    },
                    child: SvgPicture.asset(
                      savedQuestions.contains(controller.questions[currentQuestion].id) ? "assets/images/off_switch.svg" : "assets/images/on_switch.svg",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:  PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < controller.questions.length; i++)
                    Column(
                      children: [
                       Expanded(
                         child: ListView(
                           children: [
                             ActualQuestion(
                               user: controller.user,
                               question: "${controller.questions[i].text}",
                               direction: "Choose the right answer to the question above",
                             ),
                             Container(
                            padding: const EdgeInsets.all(17.0),
                            decoration: const BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Visibility(
                                  visible: controller.questions[i].instructions!.isNotEmpty ? true : false,
                                  child: Card(
                                      elevation: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:  AdeoHtmlTex(
                                          controller.user,
                                          controller.questions[i].instructions!.replaceAll("https", "http"),
                                          useLocalImage: false,
                                          textColor: Colors.black,
                                        ),
                                      )),
                                ),
                                Visibility(
                                    visible: controller.questions[i].resource!.isNotEmpty ? true : false,
                                    child: AdeoHtmlTex(
                                      controller.user,
                                      controller.questions[i].resource!.replaceAll("https", "http"),
                                      useLocalImage: false,
                                      textColor: Colors.black,
                                    ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                  visible: controller.questions[i].answers![0].solution!.isNotEmpty ? true : false,
                                  child:  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00C9B9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ExpansionTile(
                                      textColor: Colors.white,
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      title: const Text(
                                        'Solution',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      children: <Widget>[
                                        const Divider(
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child:  AdeoHtmlTex(
                                            controller.user,
                                            controller.questions[i].answers![0].solution!.replaceAll("https", "http"),
                                            useLocalImage: false,
                                            textColor: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 26,
                                ),
                                ...List.generate(controller.questions[i].answers!.length, (index) {
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        print("countdownInSeconds:$countdownInSeconds");
                                        controller.questions[i].selectedAnswer = controller.questions[i].answers![index];
                                        var dateFormat = DateFormat('h:m:s');
                                        DateTime durationEnd =  dateFormat.parse(DateFormat('hh:mm:ss').format(DateTime.now()));
                                        timeSpent = durationEnd.difference(durationStart).inSeconds;
                                        controller.questions[i].time = timeSpent;
                                        durationStart = dateFormat.parse(DateFormat('hh:mm:ss').format(DateTime.now()));
                                        nextButton();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:  AdeoHtmlTex(
                                                controller.user,
                                                controller.questions[i].answers![index].text!.replaceAll("https", "http"),
                                                  useLocalImage: false,
                                                  textColor: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: controller.questions[i].selectedAnswer == controller.questions[i].answers![index] ? FontWeight.bold : FontWeight.normal,

                                                ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                           Icon(
                                            controller.questions[i].selectedAnswer == controller.questions[i].answers![index] ? Icons.radio_button_checked : Icons.radio_button_off ,
                                            color: controller.questions[i].selectedAnswer == controller.questions[i].answers![index] ? Color(0xFF00C9B9) : Colors.white,
                                          )
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color:  controller.questions[i].selectedAnswer == controller.questions[i].answers![index] ? Color(0xFFEFEFEF) : Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          width: 1,
                                          color: controller.questions[i].selectedAnswer == controller.questions[i].answers![index] ? Color(0xFF00C9B9) : Colors.grey[400]!,
                                        ),
                                      ),
                                    ),
                                  );

                                })
                              ],
                            ),
                          )
                           ],
                         ),
                       )
                      ],
                    )
                  // QuestionWidget(
                  //   controller.user,
                  //   controller.questions[i],
                  //   position: i,
                  //   enabled: enabled,
                  //   theme: widget.theme,
                  //   diagnostic: widget.diagnostic,
                  //   callback: (Answer answer) async {
                  //     await Future.delayed(Duration(milliseconds: 200));
                  //     if (controller.speedTest && answer.value == 0) {
                  //       completeQuiz();
                  //     } else {
                  //       nextButton();
                  //     }
                  //   },
                  // )
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (currentQuestion > 0 && (!controller.speedTest || controller.speedTest && !enabled))
                    Expanded(
                    child: InkWell(
                      onTap: () {
                        // Get.to(() => const QuizReviewPage());
                        pageController.previousPage(duration: Duration(milliseconds: 1), curve: Curves.ease);
                        setState(() {
                          currentQuestion--;
                          // numberingController.scrollTo(
                          //     index: currentQuestion,
                          //     duration: Duration(seconds: 1),
                          //     curve: Curves.easeInOutCubic);
                        });
                      },
                      child: Container(
                        color: kAccessmentButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          'Previous',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),
                  if (currentQuestion < controller.questions.length - 1 && !(!enabled && controller.speedTest && currentQuestion == finalQuestion))
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Get.to(() => const QuizReviewPage());
                        if (currentQuestion == controller.questions.length - 1) {
                          return;
                        }
                        setState(() {
                          currentQuestion++;
                          avgScore ();
                          pageController.nextPage(
                              duration: Duration(milliseconds: 1), curve: Curves.ease);

                          // numberingController.scrollTo(
                          //     index: currentQuestion,
                          //     duration: Duration(seconds: 1),
                          //     curve: Curves.easeInOutCubic);

                          if (controller.speedTest && enabled) {
                            resetTimer();
                          }
                        });
                      },
                      child: Container(
                        color: kAccessmentButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          'Next',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!savedTest && currentQuestion == controller.questions.length - 1 || (enabled && controller.speedTest && currentQuestion == finalQuestion))
                    Expanded(
                    child: InkWell(
                      onTap: () {
                        completeQuiz();
                      },
                      child: Container(
                        color: kAccessmentButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          'Complete',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
    );
  }

  quitWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: 20,
              child: const Divider(
                thickness: 3,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const SizedBox(
            height: 52,
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
            onPressed: (){
              Navigator.pop(context);
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
                    (states) =>
                states.contains(MaterialState.pressed) ?  Color(0xFFFF6060) : Colors.white,
              ),
            ),
            child: Text(
              "Yes",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),

          SizedBox(height: 10),
          OutlinedButton(
            onPressed: (){
              startTimer();
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
                    (states) =>
                states.contains(MaterialState.pressed) ?  Color(0xFF00C664) : Colors.white,
              ),
            ),
            child: Text(
              "No",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),

          SizedBox(height: 82),
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

  reportModalBottomSheet(context,{Question? question}) async{
    double sheetHeight = 440.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),

                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              timerController.resume();
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20,),
                              child: Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0,),
                      Container(
                        child: Icon(Icons.warning,color: Colors.orange,size: 50,),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200]
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: sText("Error Reporting",weight: FontWeight.bold,size: 20),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 40,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.only(left: 12, right: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ListNames>(
                                    value: reportTypes == null ? listReportsTypes[0] : reportTypes,
                                    itemHeight: 48,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: kDefaultBlack,
                                    ),
                                    // onTap: (){
                                    //   stateSetter((){
                                    //     sheetHeight = 400;
                                    //   });
                                    // },

                                    onChanged: (ListNames? value){
                                      stateSetter((){
                                        reportTypes = value;
                                        sheetHeight = 700;
                                        FocusScope.of(context).requestFocus(descriptionNode);
                                      });
                                    },
                                    items: listReportsTypes.map(
                                          (item) => DropdownMenuItem<ListNames>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
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
                            SizedBox(height: 40,),
                            Container(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      onFieldSubmitted: (value){
                                        stateSetter((){
                                          sheetHeight = 440;
                                        });
                                      },
                                      onTap: (){
                                        stateSetter((){
                                          sheetHeight = 700;
                                        });
                                      },
                                      decoration: textDecorNoBorder(
                                        hint: 'Description',
                                        radius: 10,
                                        labelText: "Description",
                                        hintColor: Colors.black,
                                        fill: Colors.white,
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40,),



                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{
                          print("${reportTypes}");
                          if(descriptionController.text.isNotEmpty){
                            if( reportTypes != null){
                              stateSetter((){
                                isSubmit = false;
                              });
                              try{
                                FlagData flagData = FlagData(reason: descriptionController.text,type:reportTypes!.name,questionId:question!.id );
                                var res = await QuizController(controller.user,controller.course,name: "").saveFlagQuestion(context, flagData,question.id!);
                                print("final res:$res");
                                if(res){
                                  stateSetter((){
                                    descriptionController.clear();
                                  });
                                  Navigator.pop(context);
                                  successModalBottomSheet(context);
                                }else{
                                  Navigator.pop(context);
                                  failedModalBottomSheet(context);
                                  print("object res: $res");
                                }
                              }catch(e){
                                stateSetter((){
                                  isSubmit = true;
                                });
                                print("error: $e");
                              }
                            }else{
                              toastMessage("Select error type");
                            }
                          }
                          else{
                            toastMessage("Description is required");
                          }
                        },
                        child: Container(
                          padding: appPadding(20),
                          width: appWidth(context),
                          color: isSubmit ?  Colors.blue : Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              sText("Submit",align: TextAlign.center,weight: FontWeight.bold,color: isSubmit ? Colors.white : Colors.black,size: 25),
                              SizedBox(width: 10,),
                              isSubmit ? Container() : progress()
                            ],
                          ),

                        ),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }

  successModalBottomSheet(context,{Question? question}){
    double sheetHeight = 350.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),

                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              timerController.resume();
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20,),
                              child: Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0,),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green,width: 15),
                              shape: BoxShape.circle
                          ),
                          child: Icon(Icons.check,color: Colors.green,size: 100,)
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: sText("Error report successfully submitted",weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }
  failedModalBottomSheet(context,{Question? question}){
    double sheetHeight = 330.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),

                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              timerController.resume();
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20,),
                              child: Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0,),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.red,width: 15),
                              shape: BoxShape.circle
                          ),
                          child: Icon(Icons.close,color: Colors.red,size: 100,)
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: sText("Error report failed try again",weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }
  getTimerWidget() {
    return controller.speedTest
        ?
    Row(
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
                  color: Color(0xFF222E3B),
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
                              color: backgroundColor, fontSize: 12));
                    }

                    return Text(
                        "${remaining.inMinutes}:${remaining.inSeconds % 60}",
                        style: TextStyle(
                            color: backgroundColor, fontSize: 12));
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
                style: TextStyle(color: backgroundColor, fontSize: 14));
          }

          return Text("${remaining.inMinutes}:${remaining.inSeconds % 60}",
              style: TextStyle(color: backgroundColor, fontSize: 14));
        },
        onFinish: () {
          onEnd();
        });
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

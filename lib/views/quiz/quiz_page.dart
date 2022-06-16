import 'dart:convert';
import 'dart:ffi';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:ecoach/widgets/questions_widgets/select_answer_widget.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

enum QuizTheme { GREEN, BLUE, ORANGE }

class QuizView extends StatefulWidget {
  QuizView(
      {Key? key,
      required this.controller,
      this.theme = QuizTheme.GREEN,
      this.diagnostic = false})
      : super(key: key);

  QuizController controller;
  bool diagnostic;
  QuizTheme theme;

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {

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
              Align(
                  alignment: Alignment.topCenter,
                  child: controller.speedTest
                      ? Container(
                          color: backgroundColor,
                          height: 53,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [],
                          ),
                        )
                      : Container()),
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
              //
              Positioned(
                top: 0,
                right: 40,
                left: 0,
                child: Container(
                  child: SizedBox(
                    height: 100,
                    child: ScrollablePositionedList.builder(
                      itemScrollController: numberingController,
                      itemCount: controller.questions.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        if (controller.speedTest) return Container();
                        return Container(
                            child: SelectText(
                                "${(i + 1)}", i == currentQuestion,
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
                          });

                          pageController.jumpToPage(i);
                        }));
                      },
                    ),
                  ),
                ),
              ),

              //
              Positioned(
                  top: -120,
                  right: -80,
                  child: Image(
                    image: AssetImage('assets/images/white_leave.png'),
                  )),
              //

              Positioned(
                key: UniqueKey(),
                top: 30,
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
                      : Text(
                          "Time Up",
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),

              // button
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
                          if (currentQuestion <
                                  controller.questions.length - 1 &&
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
                              currentQuestion ==
                                  controller.questions.length - 1)
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
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 130,
                child: Container(
                  child: IconButton(onPressed: ()async{
                    timerController.pause();
                   await reportModalBottomSheet(context,question: controller.questions[currentQuestion]);

                  }, icon: Icon(Icons.more_horiz,color: Colors.white,)),
                ),
              )
            ]),
          ),
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
                                    color: backgroundColor, fontSize: 18));
                          }

                          return Text(
                              "${remaining.inMinutes}:${remaining.inSeconds % 60}",
                              style: TextStyle(
                                  color: backgroundColor, fontSize: 28));
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
        this.answerValue = 0,
      this.theme = QuizTheme.GREEN,
      this.callback})
      : super(key: key);
  User user;
  Question question;
  int? position;
  int? answerValue;
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
                      getAnswerMarker(answers![i])
                    ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Positioned getAnswerMarker(Answer answer) {
    if (!widget.enabled && answer == correctAnswer) {
      return Positioned(
          left: 115,
          bottom: 8,
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


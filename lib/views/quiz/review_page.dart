import 'dart:convert';
import 'dart:io';

import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class ReviewTest extends StatefulWidget {
  TestTaken? testTaken;
  User? user;

  ReviewTest({this.testTaken, this.user});

  @override
  State<ReviewTest> createState() => _ReviewTestState();
}

class _ReviewTestState extends State<ReviewTest> {
  int _currentPage = 0;
  List<Widget> slides = [];
  int questionIndex = 0;
  int questionCount = 0;
  String ready = "Reveiw";
  int endTime = 0;
  bool switchOn = false;
  late final PageController pageController;

  popUpMenu({BuildContext? context}) {
    return PopupMenuButton(
      onSelected: (result) async {
        if (result == "report") {
          Course course = Course(
            id: widget.testTaken!.courseId,
            name: widget.testTaken!.testname,
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
            courseId: widget.testTaken!.courseId.toString(),
          );
          QuizController(widget.user!,course,name: widget.testTaken!.testname!).reportModalBottomSheet(context,question:reviewQuestionsBack[questionIndex]);
        }
        // else if (result == "remove") {
        //   await QuestionDB()
        //       .deleteSavedTestByCourseId(widget.testTaken!.courseId!);
        //   List<Question> ques = await QuestionDB()
        //       .getSavedTestQuestionsByType(widget.testTaken!.courseId!);
        //   await getAllSaveTestQuestions();
        //   setState(() {
        //     if (ques.isEmpty) {
        //       toastMessage("Course removed from saved questions");
        //     } else {
        //       print("Failed");
        //     }
        //   });
        // }
      },
      padding: bottomPadding(0),
      child: Container(
        child: Icon(Icons.more_vert, color: Colors.white),
      ),
      // add this line
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Container(
            // height: 30,
            child: sText("Report", size: 18),
          ),
          value: 'report',
          onTap: () {},
        ),
        // PopupMenuItem<String>(
        //   child: Container(
        //     // height: 30,
        //     child: sText("Remove saved topic", size: 18),
        //   ),
        //   value: 'remove',
        //   onTap: () {},
        // ),
      ],
    );
  }
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

  getQuestionIndex(){
    int q_index = 0;
    if(selectAnsweredQuestions.isNotEmpty){
      q_index = selectAnsweredQuestions[questionIndex]["position"];
    }else if(unSelectAnsweredQuestions.isNotEmpty){
      q_index = unSelectAnsweredQuestions[questionIndex]["position"];
    }else{
      q_index = questionIndex + 1;
    }

    return q_index;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    questionCount = getQuestionIndex();

    // getAllSaveTestQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: reviewSelectedColor,
      appBar: AppBar(
        backgroundColor: reviewBackgroundColors,
        elevation: 0,
        title: sText(
            "${widget.testTaken!.testname}",
            color: Colors.white,
            weight: FontWeight.bold,
            size: 20,
            align: TextAlign.center),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [popUpMenu(context: context)],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int index = 0; index < reviewQuestionsBack.length; index++)
                    ListView(
                      children: [
                        // question
                        Container(
                          color: reviewSelectedColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 5,
                                          value: ((questionIndex + 1) /
                                                  reviewQuestionsBack.length) *
                                              1,
                                          backgroundColor: reviewSelectedColor,
                                          semanticsLabel: "5",
                                          semanticsValue: "4",
                                        ),
                                        Positioned(
                                          left: 10,
                                          top: 7,
                                          child: sText("$questionCount",
                                              color: Colors.white,
                                              size: 18,
                                              align: TextAlign.center),
                                        )
                                      ],
                                    ),
                                    FlutterSwitch(
                                      width: 50.0,
                                      height: 20.0,
                                      valueFontSize: 10.0,
                                      toggleSize: 15.0,
                                      value: savedQuestions.contains(
                                              reviewQuestionsBack[questionIndex]
                                                  .id)
                                          ? true
                                          : false,
                                      borderRadius: 30.0,
                                      padding: 2.0,
                                      showOnOff: false,
                                      activeColor: reviewBackgroundColors,
                                      inactiveColor: reviewDividerColor,
                                      inactiveTextColor: Colors.red,
                                      inactiveToggleColor: reviewSelectedColor,
                                      onToggle: (val) {
                                        setState(() {
                                          switchOn = val;
                                          insertSaveTestQuestion(
                                              reviewQuestionsBack[questionIndex]
                                                  .id!);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              AdeoHtmlTex(
                                widget.user!,
                                reviewQuestionsBack[questionIndex]
                                    .text!
                                    .replaceAll("https", "http"),
                                useLocalImage: true,
                              ),
                            ],
                          ),
                        ),
                        // choose the right
                        Container(
                          color: Colors.grey,
                          width: appWidth(context),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: sText(
                              "Choose the right answer for the question",
                              color: Colors.white,
                              size: 16,
                              align: TextAlign.center,
                              weight: FontWeight.bold),
                        ),
                        // instructions
                        instructionWidget(),
                        // resource
                        // resourceWidget(),
                       // solutions
                        solutionWidget(),
                        Container(
                          height: 1,
                          width: appWidth(context),
                          color: reviewDividerColor,
                        ),
                       // answer
                        for (int index = 0; index < reviewQuestionsBack[questionIndex].answers!.length; index++)
                        answerWidget(reviewQuestionsBack[questionIndex].answers![index])
                      ],
                    ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  questionIndex != 0
                      ?
                  Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (questionIndex == 0) {
                                toastMessage("Do you want to quit the questions");
                              } else {
                                questionIndex--;
                                questionCount = getQuestionIndex();
                              }
                              await Future.delayed(Duration(milliseconds: 200));
                              setState(() {
                                pageController.previousPage(duration: Duration(milliseconds: 1), curve: Curves.ease);
                              });
                            },
                            child: Container(
                              padding: appPadding(20),
                              color: reviewBackgroundColors,
                              child: sText("Previous",
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                  size: 20,
                                  align: TextAlign.center),
                            ),
                          ),
                        )
                      : Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (questionIndex == 0) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              padding: appPadding(20),
                              color: reviewBackgroundColors,
                              child: sText("Cancel",
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                  size: 20,
                                  align: TextAlign.center),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 2,
                  ),
                  questionIndex != reviewQuestionsBack.length - 1
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (questionIndex == reviewQuestionsBack.length - 1) {
                                toastMessage("Done");
                                Navigator.pop(context, 1);
                                // showDialogOk(message: "You've finished answering the questions, click on ok to view your scores",context: context,target: Dashboard(),status: true,replace: true,dismiss: false);
                              } else {
                                await Future.delayed(Duration(milliseconds: 200));
                                questionIndex++;
                                questionCount = getQuestionIndex();
                              }
                              setState(() {
                                pageController.nextPage(duration: Duration(milliseconds: 1), curve: Curves.ease);
                              });
                            },
                            child: Container(
                              padding: appPadding(20),
                              color: reviewBackgroundColors,
                              child: sText("Next",
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                  size: 20,
                                  align: TextAlign.center),
                            ),
                          ),
                        )
                      : Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              toastMessage("Done");
                              Navigator.pop(context, 1);
                            },
                            child: Container(
                              padding: appPadding(20),
                              color: reviewBackgroundColors,
                              child: sText("Completed",
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                  size: 20,
                                  align: TextAlign.center),
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  instructionWidget() {
    if(reviewQuestionsBack[questionIndex].instructions!.isNotEmpty){
      return  Column(
        children: [
          Container(
            color: reviewDividerColor,
            height: 10,
          ),
          Container(
              color: reviewSelectedColor,
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              width: appWidth(context),
              child: sText("${reviewQuestionsBack[questionIndex].instructions}",
                  color: Colors.white,
                  weight: FontWeight.normal,
                  size: 20,
                  align: TextAlign.center))
        ],
      );
    }else{
      return Container();
    }

  }
  resourceWidget() {
    if(reviewQuestionsBack[questionIndex].resource!.isNotEmpty){
      return  Column(
        children: [
          Container(
            color: reviewDividerColor,
            height: 10,
          ),
          Container(
              color: reviewSelectedColor,
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              width: appWidth(context),
              child: sText("${reviewQuestionsBack[questionIndex].resource}",
                  color: Colors.white,
                  weight: FontWeight.normal,
                  size: 20,
                  align: TextAlign.center))
        ],
      );
    }else{
      return Container();
    }

  }
  solutionWidget() {
    for (int index = 0; index < reviewQuestionsBack[questionIndex].answers!.length; index++)
      if(reviewQuestionsBack[questionIndex].answers![index].solution!.isNotEmpty){
      return  Column(
        children: [
          Container(
            color: reviewDividerColor,
            height: 10,
          ),
          SizedBox(height: 10,),
          Container(
            child: sText("Solution",weight: FontWeight.bold,color: reviewDividerColor,size: 30),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: reviewDividerColor,width: 2)
                )
            ),
          ),

          Container(
              color: reviewSelectedColor,
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              width: appWidth(context),
              child:  AdeoHtmlTex(
                widget.user!,
                reviewQuestionsBack[questionIndex].answers![index].solution!
                    .replaceAll("https", "http"),
                useLocalImage: true,
              ),
              // sText("${reviewQuestionsBack[questionIndex].answers![index].solution!}",
              //     color: Colors.white,
              //     weight: FontWeight.normal,
              //     size: 20,
              //     align: TextAlign.center)
          )
        ],
      );
    }else{
      return Container();
    }

  }
  answerWidget(Answer answer) {
      return  Container(
        color: reviewSelectedColor,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: appWidth(context),
                margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10),
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                child: AdeoHtmlTex(
                  widget.user!, answer.text!.replaceAll("https", "http"),
                  useLocalImage: true,
                  removeBr: true,
                  textColor: answer.value == 1 ? Colors.green : Colors.white,
                ),

                // sText("${reviewQuestionsBack[questionIndex].text}",weight: FontWeight.bold,color: reviewQuestionsBack[questionIndex].answers![index].value == 1 ? Colors.green : Colors.white,size: reviewQuestionsBack[questionIndex].answers![index].value == 1 ? 25 : 16,align: TextAlign.center),

                decoration: (reviewQuestionsBack[questionIndex].isCorrect && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id) ||
                    (reviewQuestionsBack[questionIndex].isWrong && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id)
                    // reviewQuestionsBack[questionIndex].unattempted && answer.value == 1 && reviewQuestionsBack[questionIndex].selectedAnswer == null
                    ? BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: reviewDividerColor, width: 1),
                    borderRadius: BorderRadius.circular(10))
                    : BoxDecoration(),
              ),
            ),
            reviewQuestionsBack[questionIndex].isCorrect && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id
                ? Positioned(
              left: 40,
              bottom: 15,
              child: Image.asset(
                  "assets/images/correct.png"),
            )
                : reviewQuestionsBack[questionIndex].isWrong && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id
                ? Positioned(
              left: 40,
              bottom: 15,
              child: Image.asset(
                  "assets/images/wrong.png"),
            )
                : reviewQuestionsBack[questionIndex].unattempted && answer.value == 1 && reviewQuestionsBack[questionIndex].selectedAnswer == null
                ?
            Container() : Container(),
            // Positioned(
            //   left: 40,
            //   bottom: 15,
            //   child: Image.asset(
            //       "assets/icons/courses/not_attempted.png"),
            //     )
            //     : Container(),
          ],
        ),
      );
  }
}

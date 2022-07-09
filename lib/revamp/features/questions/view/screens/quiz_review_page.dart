import 'dart:convert';

import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/actual_question.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/end_question.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/question_answer.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/questions_app_bar.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/questions_header.dart';
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

class QuizReviewPage extends StatefulWidget {
  TestTaken? testTaken;
  User? user;

  QuizReviewPage({this.testTaken, this.user});

  @override
  State<QuizReviewPage> createState() => _QuizReviewPageState();
}

class _QuizReviewPageState extends State<QuizReviewPage> {
  int _currentPage = 0;
  List<Widget> slides = [];
  int questionIndex = 0;
  int questionCount = 0;
  String ready = "Reveiw";
  int endTime = 0;
  bool switchOn = false;
  bool isCorrect = false;
  List<Answer> answers=  [];
  double totalAverage = 0.0;
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
    pageController = PageController(initialPage: 0);
    questionCount = getQuestionIndex();
    getAllSaveTestQuestions();
    for(int i =0; i< reviewQuestionsBack.length; i++){
      for(int t = 0; t < reviewQuestionsBack[i].answers!.length; t++){
        if(reviewQuestionsBack[i].answers![t].value == 1){
          answers.add(reviewQuestionsBack[i].answers![t]);
        }
      }
    }
    super.initState();
  }

  // avgTimeComplete(){
  //   int count = 0;
  //   for(int i = 0; i <  reviewQuestionsBack.length; i++){
  //     count += reviewQuestionsBack[questionIndex].time!;
  //   }
  //   return count;
  // }

  avgTimeComplete(){
    double count = 0.0;
    for(int i = 0; i <  reviewQuestionsBack.length; i++){
      count += reviewQuestionsBack[questionIndex].time!;
    }

    if(count == 0 && questionIndex == 0){
      count = 0;
    }else{
      count = count/questionIndex;
    }

    print("count:$count");
    return count.toStringAsFixed(2);
  }

  completeQuiz() async {
  Navigator.pop(context);
  }


  bool swichValue = false;
  double get score {
    int totalQuestions = reviewQuestionsBack.length;
    int correctAnswers = correct;
    return correctAnswers / totalQuestions * 100;
  }

  int get correct {
    int score = 0;
    reviewQuestionsBack.forEach((question) {
      if (question.isCorrect) score++;
    });    return score;
  }

  int get wrong {
    int wrong = 0;
    reviewQuestionsBack.forEach((question) {
      if (!question.isCorrect) wrong++;
    });
    return wrong;
  }

  int get unattempted {
    int unattempted = 0;
    reviewQuestionsBack.forEach((question) {
      if (question.unattempted) unattempted++;
    });
    return unattempted;
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
       Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor:Colors.grey[100],
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
                      value: questionIndex == reviewQuestionsBack.length -1 ? 1 :  questionIndex/(reviewQuestionsBack.length -1),
                    ),
                    Center(
                      child: Text(
                        "${questionIndex + 1}",
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

            }, icon: popUpMenu(context: context)),
          ],
          title:  Container(
            width: 250,
            child: Text(
              widget.testTaken!.testname!,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
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
                  sText("Review",color: Colors.white),
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
                  isCorrect ?
                  Image.asset(
                    "assets/images/un_fav.png",
                    color: Colors.green,
                  ) :   SvgPicture.asset(
                    "assets/images/fav.svg",
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${widget.testTaken!.score!.toStringAsFixed(2)}%",
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
                    "${widget.testTaken!.usedTime}s",
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
                    "${widget.testTaken!.correct}",
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
                    "${widget.testTaken!.wrong}",
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
                        insertSaveTestQuestion(reviewQuestionsBack[questionIndex].id!);
                      },
                      child: SvgPicture.asset(
                        savedQuestions.contains(reviewQuestionsBack[questionIndex].id) ? "assets/images/on_switch.svg" : "assets/images/off_switch.svg",
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
                  for (int i = 0; i < reviewQuestionsBack.length; i++)
                    Column(
                      children: [
                        ActualQuestion(
                          user: widget.user!,
                          question: "${reviewQuestionsBack[questionIndex].text}",
                          direction: "Choose the right answer to the question above",
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if(reviewQuestionsBack[questionIndex].instructions!.isNotEmpty)
                                  Visibility(
                                    visible: reviewQuestionsBack[questionIndex].instructions!.isNotEmpty ? true : false,
                                    child: Card(
                                        elevation: 0,
                                        color: Colors.white,
                                        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child:  AdeoHtmlTex(
                                            widget.user!,
                                            reviewQuestionsBack[questionIndex].instructions!.replaceAll("https", "http"),
                                            useLocalImage: true,
                                            // removeTags: reviewQuestionsBack[questionIndex].instructions!.contains("src") ? false : true,
                                            textColor: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )),
                                  ),
                                  if(reviewQuestionsBack[questionIndex].resource!.isNotEmpty)
                                  Visibility(
                                    visible: reviewQuestionsBack[questionIndex].resource!.isNotEmpty ? true : false,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      child: AdeoHtmlTex(
                                       widget.user!,
                                        reviewQuestionsBack[questionIndex].resource!.replaceAll("https", "http"),
                                        useLocalImage: true,
                                        // removeTags: reviewQuestionsBack[questionIndex].resource!.contains("src") ? false : true,
                                        textColor: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),

                                  Visibility(
                                    visible: reviewQuestionsBack[questionIndex].correctAnswer!.solution!.isNotEmpty ? true : false,
                                    child:  Container(
                                      padding: const EdgeInsets.all(0),
                                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                        ),
                                        children: <Widget>[
                                          const Divider(
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child:  AdeoHtmlTex(
                                             widget.user!,
                                              reviewQuestionsBack[questionIndex].correctAnswer!.solution!.replaceAll("https", "http"),
                                              useLocalImage: false,
                                              // removeTags: reviewQuestionsBack[questionIndex].answers![t].solution!.contains("src") ? false : true,
                                              textColor: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ...List.generate(reviewQuestionsBack[questionIndex].answers!.length, (index) {
                                   return answerWidget(reviewQuestionsBack[questionIndex].answers![index]);

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
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  questionIndex != 0
                      ?
                    Expanded(
                      child: InkWell(
                        onTap: () async{
                          if (questionIndex == 0) {
                            toastMessage("Do you want to quit the questions");
                          } else {
                            questionIndex--;
                            questionCount = getQuestionIndex();
                          }
                          await Future.delayed(Duration(milliseconds: 1));
                          setState(() {
                            pageController.previousPage(duration: Duration(milliseconds: 1), curve: Curves.ease);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: const Text(
                            'Previous',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ) :
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (questionIndex == 0) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          'Return',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),
                  if (questionIndex < reviewQuestionsBack.length - 1)
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (questionIndex == reviewQuestionsBack.length - 1) {
                            toastMessage("Done");
                            Navigator.pop(context, 1);
                            // showDialogOk(message: "You've finished answering the questions, click on ok to view your scores",context: context,target: Dashboard(),status: true,replace: true,dismiss: false);
                          } else {
                            questionIndex++;
                            questionCount = getQuestionIndex();
                          }
                          await Future.delayed(Duration(milliseconds: 1));
                          pageController.nextPage(duration: Duration(milliseconds: 1), curve: Curves.ease);

                          setState(() {
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: const Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if ( questionIndex == reviewQuestionsBack.length - 1)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                        Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: const Text(
                            'Complete',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
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

  answerWidget(Answer answer) {

    return  Column(
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 10,right: 20,left: 20),
          child: Row(
            children: [
              Expanded(
                child:  AdeoHtmlTex(
                  widget.user!,
                  answer.text!.replaceAll("https", "http"),
                  useLocalImage: true,
                  textColor: reviewQuestionsBack[questionIndex].selectedAnswer == null && answer.value == 0 ? Colors.black :
                  reviewQuestionsBack[questionIndex].selectedAnswer == null && answer.value == 1 ? Colors.white :
                  ((reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id && answer.value == 1) ||  answer.value == 1) ||  (reviewQuestionsBack[questionIndex].isCorrect && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id) || (reviewQuestionsBack[questionIndex].isWrong && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id)  ? Colors.white : Colors.black ,
                  fontSize: 25,
                  // removeTags: answer.text!.contains("src") ? false : true,
                    removeBr: true,
                  fontWeight: reviewQuestionsBack[questionIndex].selectedAnswer == answer ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                reviewQuestionsBack[questionIndex].selectedAnswer == answer ? Icons.radio_button_checked : Icons.radio_button_off ,
                color:  answer.value == 1 ? Colors.transparent : Colors.white,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration:
          reviewQuestionsBack[questionIndex].selectedAnswer == null && answer.value == 0 ?
          BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color: Colors.grey[400]!,
            ),
          ) :
          reviewQuestionsBack[questionIndex].selectedAnswer == null && answer.value == 1 ?
          BoxDecoration(
            color:  Color(0xFF00C9B9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color: reviewQuestionsBack[questionIndex].selectedAnswer == answer ? Color(0xFF00C9B9) : Colors.grey[400]!,
            ),
          )
              :
          (reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id && answer.value == 1) ||  answer.value == 1 ?
          BoxDecoration(
            color:  Color(0xFF00C9B9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color: reviewQuestionsBack[questionIndex].selectedAnswer == answer ? Color(0xFF00C9B9) : Colors.grey[400]!,
            ),
          ) :
            reviewQuestionsBack[questionIndex].isCorrect && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id ?
          BoxDecoration(
            color:  Color(0xFF00C9B9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color: reviewQuestionsBack[questionIndex].selectedAnswer == answer ? Color(0xFF00C9B9) : Colors.grey[400]!,
            ),
          ) :
          reviewQuestionsBack[questionIndex].isWrong && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id ?
          BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color: Colors.grey[400]!,
            ),
          ) :
          BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color: Colors.grey[400]!,
            ),
          )
        ),




        // Container(
        //   color: reviewSelectedColor,
        //   child: Stack(
        //     children: [
        //       Center(
        //         child: Container(
        //           width: appWidth(context),
        //           margin: EdgeInsets.only(
        //               left: 20,
        //               right: 20,
        //               top: 10,
        //               bottom: 10),
        //           padding: EdgeInsets.symmetric(
        //               horizontal: 20, vertical: 20),
        //           child: AdeoHtmlTex(
        //             widget.user!, answer.text!.replaceAll("https", "http"),
        //             useLocalImage: false,
        //             textColor: answer.value == 1 ? Colors.green : Colors.white,
        //           ),
        //
        //           // sText("${reviewQuestionsBack[questionIndex].text}",weight: FontWeight.bold,color: reviewQuestionsBack[questionIndex].answers![index].value == 1 ? Colors.green : Colors.white,size: reviewQuestionsBack[questionIndex].answers![index].value == 1 ? 25 : 16,align: TextAlign.center),
        //
        //           decoration: (reviewQuestionsBack[questionIndex].isCorrect && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id) ||
        //               (reviewQuestionsBack[questionIndex].isWrong && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id)
        //               ? BoxDecoration(
        //               color: Colors.black26,
        //               border: Border.all(color: reviewDividerColor, width: 1),
        //               borderRadius: BorderRadius.circular(10))
        //               : BoxDecoration(),
        //         ),
        //       ),
        //       reviewQuestionsBack[questionIndex].isCorrect && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id
        //           ? Positioned(
        //         left: 40,
        //         bottom: 15,
        //         child: Image.asset(
        //             "assets/images/correct.png"),
        //       )
        //           : reviewQuestionsBack[questionIndex].isWrong && reviewQuestionsBack[questionIndex].selectedAnswer!.id == answer.id
        //           ? Positioned(
        //         left: 40,
        //         bottom: 15,
        //         child: Image.asset(
        //             "assets/images/wrong.png"),
        //       )
        //           : reviewQuestionsBack[questionIndex].unattempted && answer.value == 1 && reviewQuestionsBack[questionIndex].selectedAnswer == null
        //           ?
        //       Container() : Container(),
        //       // Positioned(
        //       //   left: 40,
        //       //   bottom: 15,
        //       //   child: Image.asset(
        //       //       "assets/icons/courses/not_attempted.png"),
        //       //     )
        //       //     : Container(),
        //     ],
        //   ),
        // ),
      ],
    );
  }



}

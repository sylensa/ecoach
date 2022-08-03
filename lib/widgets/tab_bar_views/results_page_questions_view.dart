import 'dart:convert';

import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/quiz/quiz_essay_page.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/quiz/review_page.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/views/test/test_type.dart';
import 'package:ecoach/widgets/QuestionCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionsTabPage extends StatefulWidget {
  const QuestionsTabPage({
    required this.questions,
    required this.diagnostic,
    required this.user,
    required this.testTaken,
    this.course,
    this.testType,
    this.challengeType,
    this.level,
    this.controller,
    this.history = false,
    Key? key,
  }) : super(key: key);

  final List questions;
  final diagnostic;
  final user;
  final bool history;
  final TestTaken? testTaken;
  final Course? course;
  final TestType? testType;
  final TestCategory? challengeType;
  final Level? level;
  final QuizController? controller;

  @override
  _QuestionsTabPageState createState() => _QuestionsTabPageState();
}

class _QuestionsTabPageState extends State<QuestionsTabPage> {
  List selected = [];
  int selectedQuestion = 0;
  late int page;
  String answerType = "";
  late PageController controller;
  List tabs = [
    {
      'label': 'All\nQuestions',
      'icon': null,
    },
    {
      'label': 'Correctly\nAnswered',
      'icon': 'assets/icons/courses/answered.png',
    },
    {
      'label': 'Wrongly\nAnswered',
      'icon': 'assets/icons/courses/unanswered.png',
    },
    {
      'label': 'Not\nAttempted',
      'icon': 'assets/icons/courses/not_attempted.png',
    }
  ];
  late List questions;

  TextStyle tabStyle(bool isActive) {
    return TextStyle(
      fontSize: 10,
      color: isActive ? Colors.black : kAdeoGray2,
      fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
      height: 1.6,
    );
  }


List<Question>reviewQuestions = [];

  getAll()async{
    reviewQuestionsBack.clear();
    List<Question> questions = await TestController().getAllQuestions(widget.testTaken!);
    for(int i = 0; i < questions.length; i++){
      print("hmm:${questions[i].selectedAnswer}");
        // await  QuestionDB().insertTestQuestion(questions[i]);
      reviewQuestions.add(questions[i]);
      // reviewQuestionsBack.add(questions[i]);
    }

    setState(() {
      print("again savedQuestions:${reviewQuestions.length}");
    });

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
  selectedAnsweredQuestions(){
    reviewQuestionsBack.clear();
    unSelectAnsweredQuestions.clear();

    for(int i = 0; i < reviewQuestions.length; i++){
      for(int t =0; t < selectAnsweredQuestions.length; t++){
        if(reviewQuestions[i].id == selectAnsweredQuestions[t]['id']){
          reviewQuestionsBack.add(reviewQuestions[i]);
        }
      }
    }
    setState((){

    });
  }
  unSelectedAnsweredQuestions(var question){
    for(int i = 0; i < reviewQuestions.length; i++){
        if(reviewQuestions[i].id == question['id']){
          reviewQuestionsBack.remove(reviewQuestions[i]);
          selectAnsweredQuestions.remove(question);
          setState(() {
            print("again reviewQuestionsBack:${reviewQuestionsBack}");
            print("again reviewQuestions:${reviewQuestions}");
          });
        }


    }


  }

  fromMap(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<TestAnswer> data = [];
    json.forEach((k, v) {
      // print(k);
      data.add(create(v));
    });

    // print(data);
    return data;
  }
  getAllAnsweredQuestions(String examScore) async {
    unSelectAnsweredQuestions.clear();
    selectAnsweredQuestions.clear();
    reviewQuestionsBack.clear();

    if(examScore.toString() == ExamScore.CORRECTLY_ANSWERED.toString()){
      for(int i = 0; i < widget.questions.length; i++){
        if(examScore.toString() == widget.questions[i]["score"].toString()){
          Question? question = await QuestionDB().getQuestionById(widget.questions[i]["id"]);
          unSelectAnsweredQuestions.add(widget.questions[i]);
          reviewQuestionsBack.add(question!);
        }
      }

    }else if(examScore.toString() == ExamScore.WRONGLY_ANSWERED.toString()){
      for(int i = 0; i < widget.questions.length; i++){
        if(examScore.toString() == widget.questions[i]["score"].toString()){
          Question? question = await QuestionDB().getQuestionById(widget.questions[i]["id"]);
          unSelectAnsweredQuestions.add(widget.questions[i]);
          reviewQuestionsBack.add(question!);
        }
      }
    }else if(examScore.toString() == ExamScore.NOT_ATTEMPTED.toString()){
      for(int i = 0; i < widget.questions.length; i++){
        if(examScore.toString() == widget.questions[i]["score"].toString()){
          Question? question = await QuestionDB().getQuestionById(widget.questions[i]["id"]);
          unSelectAnsweredQuestions.add(widget.questions[i]);
          reviewQuestionsBack.add(question!);
        }
      }
    }else{
      for(int i = 0; i < widget.questions.length; i++){
          Question? question = await QuestionDB().getQuestionById(widget.questions[i]["id"]);
          unSelectAnsweredQuestions.add(widget.questions[i]);
          reviewQuestionsBack.add(question!);
      }
    }
    await  goTo(context, QuizReviewPage(testTaken: widget.testTaken,user: widget.user,));
    setState(() {

    });
  }
  @override
  void initState() {
    if(savedQuestions.isEmpty){
      getAllSaveTestQuestions();
    }
    selectAnsweredQuestions.clear();
    getAll();
    page = 0;
    controller = PageController();
    questions = widget.questions;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 41),
        Container(
          height: 5,
          color: Colors.white,
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: tabs
                      .map(
                        (tab) => Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: tabs.indexOf(tab) == page
                                    ? BorderSide(
                                        color: kAdeoGray2,
                                        width: 2,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  page = tabs.indexOf(tab);
                                  print("page tabs:$page");
                                  controller.animateToPage(
                                    tabs.indexOf(tab),
                                    duration: Duration(milliseconds: 5),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                  );
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (tab['icon'] != null)
                                    Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: Image.asset(
                                            tab['icon'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                      ],
                                    ),
                                  Text(
                                    tab['label'],
                                    textAlign: TextAlign.center,
                                    style: tabStyle(page == tabs.indexOf(tab)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (newPage) {
                    setState(() {
                      page = newPage;
                    });
                  },
                  children: [
                    !widget.diagnostic  || widget.diagnostic ?
                    QuestionTabView(
                      diagnostic:  widget.diagnostic,
                      score: "",
                      user: widget.user,
                      questions: questions,
                      testTaken: widget.testTaken,
                      savedQuestions: savedQuestions,
                      selectedQuestions: selectAnsweredQuestions,
                      onSelected: (question) {
                        answerType  = "";
                        if (!selectAnsweredQuestions.contains(question))
                          setState(
                            () {
                              selectAnsweredQuestions = [...selectAnsweredQuestions, question];
                              selectedQuestion = question['position'];
                              print("selectAnsweredQuestions: ${selectAnsweredQuestions}");
                              selectedAnsweredQuestions();

                            },
                          );
                        else
                          setState(() {
                            selectAnsweredQuestions = selectAnsweredQuestions.where((q) => q != question).toList();
                               unSelectedAnsweredQuestions(question);

                          });
                      },
                      onQuestionToggled: (int id, bool isOn) async{
                        print("$isOn , $id");

                        if (isOn)
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = [...savedQuestions, id];
                            // print("savedQuestions:$savedQuestions");
                          });
                        else
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = savedQuestions
                            //     .where((qid) => qid != id)
                            //     .toList();
                        print("savedQuestions3:$savedQuestions");

                        });
                      },
                    ) :
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                                return MainHomePage(
                                  widget.user,
                                  index: 0,
                                );
                              }));
                        },
                        child: Center(child: sText(context.read<DownloadUpdate>().plans.isNotEmpty ? "No review for diagnostic test" :"Purchase to get full access to quiz",color: Colors.black,weight: FontWeight.bold,size: 18),),
                      ),
                    ) ,
                    !widget.diagnostic  || widget.diagnostic ?
                    QuestionTabView(
                      diagnostic:  widget.diagnostic,

                      score: ExamScore.CORRECTLY_ANSWERED.toString(),
                      user: widget.user,
                      testTaken: widget.testTaken,
                      questions: questions
                          .where(
                            (question) =>
                                question['score'] ==
                                ExamScore.CORRECTLY_ANSWERED,
                          )
                          .toList(),
                      savedQuestions: savedQuestions,
                      selectedQuestions: selectAnsweredQuestions,
                      onSelected: (question) {

                        answerType  = ExamScore.CORRECTLY_ANSWERED.toString();
                        if (!selectAnsweredQuestions.contains(question))
                          setState(
                            () {
                              selectAnsweredQuestions = [...selectAnsweredQuestions, question];
                              selectedQuestion = question['position'];
                              selectedAnsweredQuestions();
                            },
                          );
                        else
                          setState(() {
                            selectAnsweredQuestions =
                                selectAnsweredQuestions.where((q) => q != question).toList();
                            unSelectedAnsweredQuestions(question);
                          });
                      },
                      onQuestionToggled: (int id, bool isOn) {
                        print("$isOn , $id");

                        if (isOn)
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = [...savedQuestions, id];
                            // print("savedQuestions:$savedQuestions");
                          });
                        else
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = savedQuestions
                            //     .where((qid) => qid != id)
                            //     .toList();
                            print("savedQuestions:$savedQuestions");

                          });
                      },
                    ) :
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                                return MainHomePage(
                                  widget.user,
                                  index: 0,
                                );
                              }));
                        },
                        child: Center(child: sText(context.read<DownloadUpdate>().plans.isNotEmpty ? "No review for diagnostic test" :"Purchase to get full access to quiz",color: Colors.black,weight: FontWeight.bold,size: 18),),
                      ),
                    ) ,
                    !widget.diagnostic || widget.diagnostic  ?
                    QuestionTabView(
                      diagnostic:  widget.diagnostic,

                      score: ExamScore.WRONGLY_ANSWERED.toString(),
                      testTaken: widget.testTaken,
                      user: widget.user,
                      questions: questions
                          .where(
                            (question) =>
                                question['score'] == ExamScore.WRONGLY_ANSWERED,
                          )
                          .toList(),
                      savedQuestions: savedQuestions,
                      selectedQuestions: selectAnsweredQuestions,
                      onSelected: (question) {
                        answerType  = ExamScore.WRONGLY_ANSWERED.toString();;
                        if (!selectAnsweredQuestions.contains(question))
                          setState(
                            () {
                              selectAnsweredQuestions = [...selectAnsweredQuestions, question];
                              selectedQuestion = question['position'];
                              selectedAnsweredQuestions();
                            },
                          );
                        else
                          setState(() {
                            selectAnsweredQuestions =
                                selectAnsweredQuestions.where((q) => q != question).toList();
                            unSelectedAnsweredQuestions(question);
                          });
                      },
                      onQuestionToggled: (int id, bool isOn) {
                        print("$isOn , $id");

                        if (isOn)
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = [...savedQuestions, id];
                            // print("savedQuestions:$savedQuestions");
                          });
                        else
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = savedQuestions
                            //     .where((qid) => qid != id)
                            //     .toList();
                            print("savedQuestions:$savedQuestions");

                          });
                      },
                    ) :
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                                return MainHomePage(
                                  widget.user,
                                  index: 0,
                                );
                              }));
                        },
                        child: Center(child: sText(context.read<DownloadUpdate>().plans.isNotEmpty ? "No review for diagnostic test" :"Purchase to get full access to quiz",color: Colors.black,weight: FontWeight.bold,size: 18),),
                      ),
                    ),
                    !widget.diagnostic || widget.diagnostic  ?
                    QuestionTabView(
                      diagnostic:  widget.diagnostic,

                      score: ExamScore.NOT_ATTEMPTED.toString(),
                      testTaken: widget.testTaken,
                      user: widget.user,
                      questions: questions
                          .where(
                            (question) =>
                                question['score'] == ExamScore.NOT_ATTEMPTED,
                          )
                          .toList(),
                      savedQuestions: savedQuestions,
                      selectedQuestions: selectAnsweredQuestions,
                      onSelected: (question) {
                        answerType  = ExamScore.NOT_ATTEMPTED.toString();;
                        if (!selectAnsweredQuestions.contains(question))
                          setState(
                            () {
                              selectAnsweredQuestions = [...selectAnsweredQuestions, question];
                              selectedQuestion = question['position'];
                              selectedAnsweredQuestions();
                            },
                          );
                        else
                          setState(() {
                            selectAnsweredQuestions =
                                selectAnsweredQuestions.where((q) => q != question).toList();
                            unSelectedAnsweredQuestions(question);
                          });
                      },
                      onQuestionToggled: (int id, bool isOn) {
                        print("$isOn , $id");

                        if (isOn)
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = [...savedQuestions, id];
                            // print("savedQuestions:$savedQuestions");
                          });
                        else
                          setState(() {
                            insertSaveTestQuestion(id);
                            // savedQuestions = savedQuestions
                            //     .where((qid) => qid != id)
                            //     .toList();
                            print("savedQuestions:$savedQuestions");

                          });
                      },
                    ) :
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                                return MainHomePage(
                                  widget.user,
                                  index: 0,
                                );
                              }));
                        },
                        child: Center(child: sText(context.read<DownloadUpdate>().plans.isNotEmpty ? "No review for diagnostic test" :"Purchase to get full access to quiz",color: Colors.black,weight: FontWeight.bold,size: 18),),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 3.0,
          color: kPageBackgroundGray,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              if (!widget.diagnostic || widget.diagnostic)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'review',
                          onPressed: () async{
                            if(widget.diagnostic){
                              // toastMessage("No review for diagnostic test");
                              if(reviewQuestionsBack.isNotEmpty){
                                await  goTo(context, QuizReviewPage(testTaken: widget.testTaken,user: widget.user,disgnostic: true,));
                                setState(() {

                                });
                              }else{
                                // getAllAnsweredQuestions(answerType);
                                // toastMessage("No review for diagnostic test");
                              }

                            }
                              else{
                              if (widget.history) {
                              } else {
                                if(reviewQuestionsBack.isNotEmpty){
                                  await  goTo(context, QuizReviewPage(testTaken: widget.testTaken,user: widget.user,));
                                  setState(() {

                                  });
                                }else{
                                  // getAllAnsweredQuestions(answerType);
                                  // toastMessage("No review for diagnostic test");
                                }


                              }
                            }
                          },
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
              // if (!widget.diagnostic && selectAnsweredQuestions.length > 0)
              //   Expanded(
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Button(
              //             label: 'revise',
              //             onPressed: () async {},
              //           ),
              //         ),
              //         Container(width: 1.0, color: kPageBackgroundGray),
              //       ],
              //     ),
              //   ),
              if (!widget.diagnostic)
                widget.testType == TestType.SPEED
                    ? Expanded(
                  child: Button(
                    label: 'new test',
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return SpeedTestIntro(
                              user: widget.user,
                              course: widget.course!,
                            );
                          }));
                    },
                  ),
                )
                    : Expanded(
                  child: Button(
                    label: 'new test',
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TestTypeView(
                              widget.user,
                              widget.course!,
                            );
                          }));
                    },
                  ),
                ),
              if (widget.diagnostic && context.read<DownloadUpdate>().plans.isEmpty)
                Expanded(
                  child: Button(
                    label: 'Purchase',
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return MainHomePage(
                              widget.user,
                              index: 0,
                            );
                          }));
                    },
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class QuestionTabView extends StatefulWidget {
   QuestionTabView({
    required this.user,
    required this.questions,
    required this.savedQuestions,
    required this.selectedQuestions,
    required this.onQuestionToggled,
    required this.onSelected,
    required this.testTaken,
    required this.diagnostic,
     this.score = "",
    Key? key,
  }) : super(key: key);

  final User user;
  final List questions;
  final List savedQuestions;
  final List selectedQuestions;
  final Function onQuestionToggled;
   final TestTaken? testTaken;
  final Function onSelected;
  final String score ;
  bool diagnostic;

  @override
  State<QuestionTabView> createState() => _QuestionTabViewState();
}

class _QuestionTabViewState extends State<QuestionTabView> {
  fromMap(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<TestAnswer> data = [];
    json.forEach((k, v) {
      // print(k);
      data.add(create(v));
    });

    // print(data);
    return data;
  }
  getAllAnsweredQuestions() async {
    unSelectAnsweredQuestions.clear();
    selectAnsweredQuestions.clear();
    reviewQuestionsBack.clear();
    String responses = widget.testTaken!.responses;
    responses = responses.replaceAll("(", "").replaceAll(")", "");
    Map<String, dynamic> res = json.decode(responses);
    List<TestAnswer>? answers = fromMap(res, (answer) {
      return TestAnswer.fromJson(answer);
    });
    for (int i = 0; i < answers!.length; i++) {
      TestAnswer answer = answers[i];
      for(int i = 0; i < widget.questions.length; i++){
        if(answer.questionId! == widget.questions[i]["id"] ){
          Question? question = await QuestionDB().getQuestionById(widget.questions[i]["id"]);
          if (question != null) {
            if (answer.selectedAnswerId != null) {
              question.selectedAnswer = await AnswerDB().getAnswerById(answer.selectedAnswerId!);
            }
             if(widget.score == widget.questions[i]["score"].toString()){
              unSelectAnsweredQuestions.add(widget.questions[i]);
              reviewQuestionsBack.add(question);
            }else if(widget.score == widget.questions[i]["score"].toString()){
              unSelectAnsweredQuestions.add(widget.questions[i]);
              reviewQuestionsBack.add(question);
            }else if(widget.score == widget.questions[i]["score"].toString()){
              unSelectAnsweredQuestions.add(widget.questions[i]);
              reviewQuestionsBack.add(question);
            }else{
               unSelectAnsweredQuestions.add(widget.questions[i]);
               reviewQuestionsBack.add(question);
             }

          }
        }

      }

    }
  }
  @override
 void initState(){
    getAllAnsweredQuestions();
    print("object: ${widget.score}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.questions.length,
      itemBuilder: (context, i) {
        var question = widget.questions[i];

        return QuestionCard(
          user: widget.user,
          question: question,
          diagnostic: widget.diagnostic,
          questionNumber: question['position'].toString(),
          isSaved: widget.savedQuestions.contains(question['id']),
          isSelected: widget.selectedQuestions.contains(question),
          onSaveToggled: widget.onQuestionToggled,
          onSelected: () {
            widget.onSelected(question);
          },
        );
      },
    );
  }
}

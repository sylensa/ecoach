import 'dart:convert';

import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/review_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/review/review_onboarding.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ReviewQuestions extends StatefulWidget {
  ReviewQuestions({
    required this.user,
    this.listQuestionsReview,
    required this.course,
    required this.testType,
     this.topicId = "0",
    this.reviewTestTaken,
    this.questionIndex = 0,
    this.testCategory,
    Key? key,
  }) : super(key: key);
  final User user;
   List<Question>? listQuestionsReview = [];
  final Course course;
  final TestType testType;
  String topicId;
  ReviewTestTaken? reviewTestTaken;
  int questionIndex;
  TestCategory? testCategory;
  @override
  State<ReviewQuestions> createState() => _ReviewQuestionsState();
}

class _ReviewQuestionsState extends State<ReviewQuestions> {
  bool switchOn = false;
  int changeIndex = 0;
  late final PageController pageController;

  popUpMenu({BuildContext? context}) {
    return PopupMenuButton(
      onSelected: (result) async {
        if (result == "report") {
          QuizController(widget.user,widget.course,name:widget.course.name!).reportModalBottomSheet(context,question:widget.listQuestionsReview![widget.questionIndex]);
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

  saveReviewTestTaken(ReviewTestTaken reviewTestTaken)async {
    await TestTakenDB().insertReviewTest(reviewTestTaken);
    Navigator.pop(context,1);
  }

  updateReviewTestTaken(ReviewTestTaken reviewTestTaken) async{
    await TestTakenDB().updateReviewTest(reviewTestTaken);
    Navigator.pop(context,1);
  }




  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    getAllSaveTestQuestions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: reviewSelectedColor,
      appBar: AppBar(
        backgroundColor: reviewBackgroundColors,
        elevation: 0,
        title: sText("${widget.testCategory!.name}",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
        leading: IconButton(onPressed: ()async{
          if(widget.reviewTestTaken == null){
            ReviewTestTaken reviewTaken = ReviewTestTaken(
                courseId: widget.course.id,
                topicId: widget.topicId,
                category: widget.testCategory.toString(),
                count: widget.questionIndex,
                completed: widget.listQuestionsReview!.length -1 == widget.questionIndex ? 1 : 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                testType: widget.testType.name,
                userId: widget.user.id
            );
            await saveReviewTestTaken(reviewTaken);
          }
          else{
            ReviewTestTaken reviewTaken = ReviewTestTaken(
                id: widget.reviewTestTaken!.id,
                courseId: widget.course.id,
                category: widget.testCategory.toString(),
                topicId: widget.reviewTestTaken!.topicId,
                count: widget.questionIndex,
                completed: widget.listQuestionsReview!.length -1 == widget.questionIndex ?  widget.reviewTestTaken!.completed! + 1 : widget.reviewTestTaken!.completed!,
                createdAt: widget.reviewTestTaken!.createdAt,
                updatedAt: DateTime.now(),
                testType: widget.reviewTestTaken!.testType,
                userId: widget.reviewTestTaken!.userId
            );
            await updateReviewTestTaken(reviewTaken);
          }
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        actions: [
          popUpMenu(context: context)
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for(int index = 0; index < widget.listQuestionsReview!.length; index++)
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
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 5,
                                        value: ((widget.questionIndex + 1)/widget.listQuestionsReview!.length) * 1,
                                        backgroundColor: reviewDividerColor,
                                        semanticsLabel: "5",
                                        semanticsValue: "4",
                                      ),
                                      Positioned(
                                        left: 12,
                                        top: 7,
                                        child: sText("${widget.questionIndex + 1}",color: Colors.white,size: 18,align: TextAlign.center),
                                      )
                                    ],
                                  ),

                                  FlutterSwitch(
                                    width: 50.0,
                                    height: 20.0,
                                    valueFontSize: 10.0,
                                    toggleSize: 15.0,
                                    value: savedQuestions.contains(widget.listQuestionsReview![widget.questionIndex].id),
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
                                      });
                                      insertSaveTestQuestion(widget.listQuestionsReview![widget.questionIndex].id!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            AdeoHtmlTex(
                              widget.user,
                              widget.listQuestionsReview![widget.questionIndex].text!.replaceAll("https", "http"),
                              useLocalImage: true,
                              imageSize: Size(10, 10),
                            ),
                          ],
                        ),
                      ),
                      // choose the right
                      Container(
                        color: Colors.grey,
                        width: appWidth(context),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
                        child: sText("Choose the right answer for the question",color: Colors.white,size: 16,align: TextAlign.center,weight: FontWeight.bold),
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
                      for(int index = 0; index < widget.listQuestionsReview![widget.questionIndex].answers!.length; index++)
                        widget.listQuestionsReview![widget.questionIndex].answers![index].value == 1 ?
                        Container(
                          color: reviewSelectedColor,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: appWidth(context),
                                  margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  child: AdeoHtmlTex(
                                    widget.user,
                                    widget.listQuestionsReview![widget.questionIndex].answers![index].text!.replaceAll("https", "http"),
                                    useLocalImage: false,
                                  ),
                                  // sText("${widget.listQuestionsReview![widget.questionIndex].answers![index].text}",weight: FontWeight.bold,color:  Colors.green ,size:  25,align: TextAlign.center),
                                  decoration: BoxDecoration(
                                      color: Colors.black26 ,
                                      border: Border.all(color: Colors.white,width: 1),
                                      borderRadius: BorderRadius.circular( 10 )
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 40,
                                bottom: 15,
                                child: Image.asset("assets/images/correct.png"),
                              )
                            ],
                          ),
                        ) :
                        Container(
                          color: reviewSelectedColor,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: appWidth(context),
                                  margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  child:  AdeoHtmlTex(
                                    widget.user,
                                    widget.listQuestionsReview![widget.questionIndex].answers![index].text!.replaceAll("https", "http"),
                                    useLocalImage: false,
                                  ),
                                  // sText("${widget.listQuestionsReview![widget.questionIndex].answers![index].text}",weight: FontWeight.bold,color: widget.listQuestionsReview![widget.questionIndex].answers![index].value == 1 ? Colors.green : Colors.white,size: widget.listQuestionsReview![widget.questionIndex].answers![index].value == 1 ? 25 : 16,align: TextAlign.center),
                                  decoration: BoxDecoration(
                                      color:reviewSelectedColor,
                                      border: Border.all(color: Colors.transparent,width: 1),
                                      borderRadius: BorderRadius.circular(0)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: ()async{
                        if(widget.questionIndex == 0){
                          if(widget.reviewTestTaken == null){
                            ReviewTestTaken reviewTaken = ReviewTestTaken(
                              courseId: widget.course.id,
                              topicId: widget.topicId,
                              count: widget.questionIndex,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              testType: widget.testType.name,
                                category: widget.testCategory.toString(),

                                userId: widget.user.id
                            );
                            await saveReviewTestTaken(reviewTaken);
                          }
                          else{
                            ReviewTestTaken reviewTaken = ReviewTestTaken(
                                id: widget.reviewTestTaken!.id,
                                courseId: widget.course.id,
                                topicId: widget.reviewTestTaken!.topicId,
                                count: widget.questionIndex,
                                category: widget.testCategory.toString(),

                                createdAt: widget.reviewTestTaken!.createdAt,
                                updatedAt: DateTime.now(),
                                testType: widget.reviewTestTaken!.testType,
                                userId: widget.reviewTestTaken!.userId
                            );
                           await  updateReviewTestTaken(reviewTaken);
                          }

                        }else{
                          widget.questionIndex--;
                        }
                        await Future.delayed(Duration(milliseconds: 200));
                        setState(() {
                          pageController.previousPage(
                              duration: Duration(milliseconds: 1),
                              curve: Curves.ease);
                        });
                      },
                      child: Container(
                        padding: appPadding(20),

                        color: reviewBackgroundColors,
                        child: sText("Previous",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      ),
                    ),
                  ),
                 SizedBox(width: 2,),
                  widget.questionIndex != widget.listQuestionsReview!.length -1 ?
                  Expanded(
                    child: GestureDetector(
                      onTap: ()async{
                        if(widget.questionIndex == widget.listQuestionsReview!.length -1){
                          toastMessage("Done");
                          Navigator.pop(context,1);
                          // showDialogOk(message: "You've finished answering the questions, click on ok to view your scores",context: context,target: Dashboard(),status: true,replace: true,dismiss: false);
                        }else{
                          await Future.delayed(Duration(milliseconds: 200));

                          widget.questionIndex++;
                        }
                        setState(() {
                          pageController.nextPage(duration: Duration(milliseconds: 1), curve: Curves.ease);

                        });
                      },
                      child: Container(
                        padding: appPadding(20),

                        color: reviewBackgroundColors,

                        child: sText("Next",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      ),
                    ),
                  ) :
                  Expanded(
                    child: GestureDetector(
                      onTap: ()async{
                        print("widget.reviewTestTaken:${widget.reviewTestTaken}");
                        // return;
                        int completeCount;
                        if(widget.reviewTestTaken == null){
                          ReviewTestTaken reviewTaken = ReviewTestTaken(
                              courseId: widget.course.id,
                              topicId: widget.topicId,
                              completed: widget.listQuestionsReview!.length -1 == widget.questionIndex ?   1 : 0,
                              count: widget.questionIndex + 1,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              category: widget.testCategory.toString(),
                              testType: widget.testType.name,
                              userId: widget.user.id
                          );
                          await saveReviewTestTaken(reviewTaken);
                        }
                        else{
                          ReviewTestTaken reviewTaken = ReviewTestTaken(
                              id: widget.reviewTestTaken!.id,
                              courseId: widget.course.id,
                              topicId: widget.reviewTestTaken!.topicId,
                              count: widget.questionIndex +1,
                              completed: widget.listQuestionsReview!.length -1 == widget.questionIndex ?  widget.reviewTestTaken!.completed! + 1 : widget.reviewTestTaken!.completed!,
                              createdAt: widget.reviewTestTaken!.createdAt,
                              updatedAt: DateTime.now(),
                              category: widget.testCategory.toString(),

                              testType: widget.reviewTestTaken!.testType,
                              userId: widget.reviewTestTaken!.userId
                          );
                          await updateReviewTestTaken(reviewTaken);
                        }
                      },
                      child: Container(
                        padding: appPadding(20),

                        color: reviewBackgroundColors,

                        child: sText("Completed",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  instructionWidget() {
    if(widget.listQuestionsReview![widget.questionIndex].instructions!.isNotEmpty){
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
              child: AdeoHtmlTex(
                widget.user,
                widget.listQuestionsReview![widget.questionIndex].instructions!.replaceAll("https", "http"),
                useLocalImage: true,
                imageSize: Size(10, 10),
              ),

              // sText("${widget.listQuestionsReview![widget.questionIndex].instructions}",
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
  resourceWidget() {
    if(widget.listQuestionsReview![widget.questionIndex].resource!.isNotEmpty){
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
              child: sText("${widget.listQuestionsReview![widget.questionIndex].resource}",
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
    for (int index = 0; index < widget.listQuestionsReview![widget.questionIndex].answers!.length; index++)
      if(widget.listQuestionsReview![widget.questionIndex].answers![index].solution!.isNotEmpty){
        return  Column(
          children: [
            Container(
              color: reviewDividerColor,
              height: 10,
            ),
            Container(
              child: sText("Solution",weight: FontWeight.bold,color: reviewDividerColor,size: 30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: reviewDividerColor)
                )
              ),
            ),
            Container(
                color: reviewSelectedColor,
                padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                width: appWidth(context),
                child: AdeoHtmlTex(
                  widget.user,
                  widget.listQuestionsReview![widget.questionIndex].answers![index].solution!.replaceAll("https", "http"),
                  useLocalImage: false,
                ),
                // sText("${widget.listQuestionsReview![widget.questionIndex].answers![index].solution!}",
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

}

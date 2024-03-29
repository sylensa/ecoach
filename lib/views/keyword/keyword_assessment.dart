import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/keyword/keyword_question_view.dart';
import 'package:ecoach/views/keyword/keyword_quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_essay_page.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:flutter/material.dart';

class KeywordAssessment extends StatefulWidget {
  const KeywordAssessment({
    Key? key,
    this.quizCover,
    this.questionView,
    this.questionCount = 0,
    this.user,
    this.course,
    this.test,
    this.questions,
    this.testCategory,
    this.name,
  }) : super(key: key);
  final User? user;
  final Course? course;
  final List<Question>? questions;
  final TestNameAndCount? test;
  final String? name;
  final TestCategory? testCategory;
  final KeywordQuizCover? quizCover;
  final KeywordQuestionView? questionView;
  final int questionCount;

  @override
  State<KeywordAssessment> createState() => _KeywordAssessmentState();
}

class _KeywordAssessmentState extends State<KeywordAssessment> {
  List numberQuestions = [
    05,
  ];
  List selectNumberQuestions = [];
  int _currentPage = 0;
  PageController pageControllerView = PageController();

  calculateQuestionsCount() async {
    if (widget.questionCount > 5) {
      if (numberQuestions[numberQuestions.length - 1] < widget.questionCount) {
        if ((numberQuestions[numberQuestions.length - 1] * 2) <
            widget.questionCount) {
          numberQuestions.add(numberQuestions[numberQuestions.length - 1] * 2);
        } else {
          numberQuestions.add(widget.questionCount);
        }
        setState(() {});
        await calculateQuestionsCount();
      }
    } else {
      numberQuestions.clear();
      numberQuestions.add(widget.questionCount);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    calculateQuestionsCount();
    if (widget.testCategory == TestCategory.MOCK) {
      selectNumberQuestions.add(40);
    }
    if (numberQuestions.length == 1) {
      selectNumberQuestions.add(numberQuestions.first);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: sText(
          "Assessment",
          color: Colors.black,
          size: 20,
          weight: FontWeight.w500,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sText("Select Number of Questions"),
            SizedBox(
              height: 20,
            ),
            if (widget.questionCount != 0)
              Column(
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: 80),
                    child: ListView.builder(
                        itemCount: numberQuestions.length,
                        controller: pageControllerView,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          bool isLastItem =
                              numberQuestions.lastIndexOf == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (index >= _currentPage) {
                                  pageControllerView.animateTo(
                                      appWidth(context) / 10,
                                      duration: new Duration(microseconds: 1),
                                      curve: Curves.easeIn);
                                } else {
                                  pageControllerView.jumpTo(0.0);
                                }
                                setState(() {
                                  _currentPage = index;
                                  selectNumberQuestions.clear();
                                  selectNumberQuestions
                                      .add(numberQuestions[index]);
                                });
                              });
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: 80,
                                minWidth: 75,
                              ),
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(
                                right: !isLastItem ? 12 : 0,
                              ),
                              child: Center(
                                child: sText(
                                  numberQuestions[index].toString(),
                                  size: 30,
                                  align: TextAlign.center,
                                  color: selectNumberQuestions
                                          .contains(numberQuestions[index])
                                      ? Colors.white
                                      : Colors.black12,
                                  weight: FontWeight.w600,
                                  lHeight: 1.6,
                                ),
                                // SizedBox(width: 30,)
                              ),
                              decoration: BoxDecoration(
                                color: selectNumberQuestions
                                        .contains(numberQuestions[index])
                                    ? kAdeoGreen4
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                border: selectNumberQuestions
                                        .contains(numberQuestions[index])
                                    ? Border.all(color: kAdeoGreen4)
                                    : Border.all(color: Colors.black12),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      sText("Test Instructions", color: kAdeoGray3),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 18,
                            right: 18,
                            child: Image.asset(
                              "assets/icons/courses/clock.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 48,
                              right: 16,
                              bottom: 16,
                              left: 24,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0XFF00C9B9),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/oval-pattern.png"),
                                fit: BoxFit.cover,
                                opacity: 0.08,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kAdeoGray3,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: appWidth(context) * 0.70,
                                      child: selectNumberQuestions.isEmpty
                                          ? sText(
                                              "Take a test on a topic",
                                              size: 12,
                                            )
                                          : sText(
                                              "Take a ${selectNumberQuestions.first} question test on a topic",
                                              size: 12,
                                            ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kAdeoGray3),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: appWidth(context) * 0.70,
                                      child: sText(
                                        "Score 70% or higher to progress to the next topic",
                                        size: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kAdeoGray3),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: appWidth(context) * 0.70,
                                      child: sText(
                                        "A score of less than 70% will open up the topic notes for revision",
                                        size: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kAdeoGray3),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: appWidth(context) * 0.70,
                                      child: sText(
                                          "Progress is saved all the time so you can continue where ever you left off",
                                          size: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kAdeoGray3,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: appWidth(context) * 0.72,
                                      child: sText(
                                          "Start a new revision round whenever you want to",
                                          size: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    MaterialButton(
                                      onPressed: () {
                                        var nextScreen;
                                        if (widget.questionCount != 0) {
                                          if (selectNumberQuestions
                                              .isNotEmpty) {
                                            goTo(
                                              context,
                                              widget.testCategory ==
                                                      TestCategory.ESSAY
                                                  ? QuizEssayView(
                                                      widget.user!,
                                                      widget.questions!,
                                                      name: widget.test != null
                                                          ? widget.test!.name
                                                          : widget.name!,
                                                      course: widget.course!,
                                                      timeInSec: widget
                                                              .questions!
                                                              .length *
                                                          60,
                                                      type: TestType.KNOWLEDGE,
                                                    )
                                                  : KeywordQuestionView(
                                                      controller:
                                                          QuizController(
                                                        widget.user!,
                                                        widget.course!,
                                                        questions:
                                                            widget.questions!,
                                                        name: widget.test !=
                                                                null
                                                            ? widget.test!.name
                                                            : widget.name!,
                                                        time: widget.questions!
                                                                .length *
                                                            60,
                                                        topicId: widget.test !=
                                                                null
                                                            ? widget.test!.id
                                                            : null,
                                                        type:
                                                            TestType.KNOWLEDGE,
                                                        challengeType: widget
                                                            .testCategory!,
                                                      ),
                                                      theme: QuizTheme.BLUE,
                                                      diagnostic: widget
                                                              .testCategory! ==
                                                          TestCategory.MOCK,
                                                      numberOfQuestionSelected:
                                                          selectNumberQuestions[
                                                              0],
                                                    ),
                                              replace: true,
                                            );
                                          } else {
                                            toastMessage(
                                                "Select number of questions");
                                          }
                                        } else {
                                          if (widget.quizCover != null)
                                            toastMessage(
                                                "No questions available for ${properCase(widget.quizCover!.name)} keyword");
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 14),
                                        child: sText(
                                          "Start",
                                          color: Colors.white,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0XFF00C9B9),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

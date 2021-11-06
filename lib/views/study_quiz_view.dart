import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/learn_image_screens.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learning_widget.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/views/study_notes_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudyQuizView extends StatefulWidget {
  const StudyQuizView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StudyController controller;

  @override
  _StudyQuizViewState createState() => _StudyQuizViewState();
}

class _StudyQuizViewState extends State<StudyQuizView> {
  late StudyController controller;
  late final PageController pageController;

  TestTaken? testTaken;
  TestTaken? testTakenSaved;
  bool showSubmit = false;
  bool answeredWrong = false;
  bool showNext = false;
  bool showComplete = false;

  @override
  void initState() {
    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);
    super.initState();
  }

  nextButton() {
    if (controller.currentQuestion == controller.questions.length - 1) {
      return;
    }
    setState(() {
      controller.currentQuestion++;
      showNext = false;
      controller.enabled = true;

      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);

      if (controller.type == StudyType.SPEED_ENHANCEMENT &&
          controller.enabled) {
        // resetTimer();
      }
    });
  }

  notesButton() async {
    Topic? topic = await TopicDB().getTopicById(controller.progress.topicId!);
    controller.saveTest(context, (test, success) async {
      if (topic!.notes != "") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return StudyNoteView(topic, controller: controller);
        }));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("This topic has no notes")));

        List<Question> questions =
            await QuestionDB().getTopicQuestions([topic.id!], 10);

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return LearningWidget(
              controller.user,
              controller.course,
              type: controller.type,
              progress: controller.progress,
              questions: questions,
            );
          },
        ), (predicate) {
          return false;
        });
      }
    });
  }

  completeQuiz() async {
    setState(() {
      controller.enabled = false;
    });
    showLoaderDialog(context, message: "Test Completed\nSaving results");

    await Future.delayed(Duration(seconds: 1));

    controller.saveTest(context, (test, success) {
      Navigator.pop(context);
      if (success) {
        setState(() {
          testTakenSaved = test;
          controller.savedTest = true;
          controller.enabled = false;
        });
        if (controller.type == StudyType.REVISION) {
          controller.updateProgress(test!);
          progressCompleteView();
        } else {
          viewResults();
        }
      }
    });
  }

  progressCompleteView() async {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    int pageIndex = 0;
    int nextLevel = controller.nextLevel;
    Topic? topic =
        await TopicDB().getLevelTopic(controller.course.id!, nextLevel);
    if (topic == null) pageIndex = 1;

    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => LearnImageScreens(
          studyController: controller,
          pageIndex: pageIndex,
        ),
      ),
    );
  }

  viewResults() {
    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ResultsView(
          controller.user,
          controller.course,
          test: testTakenSaved!,
          diagnostic: false,
        ),
      ),
    ).then((value) {
      setState(() {
        controller.currentQuestion = 0;
        controller.reviewMode = true;
        pageController.jumpToPage(controller.currentQuestion);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularPercentIndicator(
                  radius: 25,
                  lineWidth: 3,
                  progressColor: Color(0xFF707070),
                  backgroundColor: Colors.transparent,
                  percent: controller.percentageCompleted,
                  center: Text(
                    "${controller.currentQuestion + 1}",
                    style: TextStyle(fontSize: 14, color: Color(0xFF969696)),
                  ),
                ),
                Text(controller.name,
                    style: TextStyle(
                        color: Color(0xFF15CA70),
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        "Coming soon",
                      )));
                    },
                    child: Text("Exit"))
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < controller.questions.length; i++)
                    StudyQuestionWidget(
                      controller.questions[i],
                      position: i,
                      enabled: controller.questionEnabled(i),
                      // useTex: useTex,
                      callback: (Answer answer, correct) async {
                        setState(() {
                          showSubmit = true;
                          if (correct)
                            answeredWrong = false;
                          else
                            answeredWrong = true;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
          Container(
            child: IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (controller.currentQuestion > 0 &&
                        ((controller.type == StudyType.COURSE_COMPLETION &&
                                controller.enabled) ||
                            controller.reviewMode))
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            pageController.previousPage(
                                duration: Duration(milliseconds: 1),
                                curve: Curves.ease);
                            setState(() {
                              controller.currentQuestion--;
                            });
                          },
                          child: Text(
                            "Previous",
                            style: TextStyle(
                              color: Color(0xFFA2A2A2),
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                    if (showSubmit)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (showSubmit)
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              showSubmit = false;
                              showNext = true;
                              controller.enabled = false;

                              if (!controller.savedTest &&
                                      controller.currentQuestion ==
                                          controller.questions.length - 1 ||
                                  (controller.enabled &&
                                      controller.type ==
                                          StudyType.SPEED_ENHANCEMENT &&
                                      controller.currentQuestion ==
                                          controller.finalQuestion)) {
                                showComplete = true;
                                showNext = false;
                              }
                            });
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Color(0xFFA2A2A2),
                              fontSize: 21,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFF6F6F6))),
                        ),
                      ),
                    if (showNext || controller.reviewMode)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (showNext || controller.reviewMode)
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: answeredWrong ? notesButton : nextButton,
                          child: Text(
                            answeredWrong ? "Test" : "Next",
                            style: TextStyle(
                              color: Color(0xFFA2A2A2),
                              fontSize: 21,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFF6F6F6))),
                        ),
                      ),
                    if (!controller.savedTest &&
                        controller.currentQuestion ==
                            controller.questions.length - 1)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (showComplete)
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            completeQuiz();
                          },
                          child: Text(
                            "Complete",
                            style: TextStyle(
                              color: Color(0xFFA2A2A2),
                              fontSize: 21,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFF6F6F6))),
                        ),
                      ),
                    if (controller.savedTest)
                      VerticalDivider(width: 2, color: Colors.white),
                    if (controller.savedTest)
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
                                color: Color(0xFFA2A2A2),
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ]),
            ),
          ),
        ],
      ),
    ));
  }
}

class StudyQuestionWidget extends StatefulWidget {
  StudyQuestionWidget(this.question,
      {Key? key,
      this.position,
      this.useTex = false,
      this.enabled = true,
      this.callback})
      : super(key: key);

  final Question question;
  int? position;
  bool enabled;
  bool useTex;
  Function(Answer selectedAnswer, bool correct)? callback;

  @override
  _StudyQuestionWidgetState createState() => _StudyQuestionWidgetState();
}

class _StudyQuestionWidgetState extends State<StudyQuestionWidget> {
  Color textColor = Color(0xFFBABABA);
  Color textColor2 = Color(0xFFACACAC);
  Color textColor3 = Color(0xFFC3CCDE);
  Color textColor4 = Color(0xFFA2A2A2);

  late List<Answer>? answers;
  Answer? selectedAnswer;
  Answer? correctAnswer;
  bool isAnswered = false;

  @override
  void initState() {
    if (!widget.enabled) {
      isAnswered = true;
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
      child: Material(
          child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              margin: EdgeInsets.only(bottom: 2),
              color: Color(0xFFF6F6F6),
              child: Text(
                widget.question.instructions!,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              color: Color(0xFFF6F6F6),
              constraints: BoxConstraints(minHeight: 135),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Html(data: "${widget.question.text ?? ''}", style: {
                    // tables will have the below background color
                    "body": Style(
                        color: textColor,
                        fontSize: FontSize(18),
                        textAlign: TextAlign.center),
                  }),
                  if (widget.question.resource != null &&
                      widget.question.resource != "")
                    Container(
                      padding: EdgeInsets.fromLTRB(2, 12, 2, 4),
                      decoration: BoxDecoration(
                          color: Color(0xFF444444),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Text(
                            "Resource",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          Html(
                              data: "${widget.question.resource ?? ''}",
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                    color: Colors.white,
                                    fontSize: FontSize(23),
                                    textAlign: TextAlign.center),
                              }),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  for (int i = 0; i < answers!.length; i++)
                    SelectAnswerWidget(answers![i], Color(0xFF00C664), (
                      answerSelected,
                    ) {
                      widget.callback!(
                          answerSelected, answerSelected == correctAnswer);
                    }),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget SelectAnswerWidget(Answer answer, Color selectedColor,
      Function(Answer selectedAnswer)? callback) {
    return TextButton(
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(getWidgetSize(answer)),
          backgroundColor: MaterialStateProperty.all(
              getBackgroundColor(answer, selectedColor)),
          foregroundColor:
              MaterialStateProperty.all(getForegroundColor(answer))),
      onPressed: () {
        if (!widget.enabled) {
          return;
        }
        setState(() {
          selectedAnswer = widget.question.selectedAnswer = answer;
          callback!(answer);
        });
      },
      child: Html(data: "${answer.text!}", style: {
        // tables will have the below background color
        "body": Style(
            color: getForegroundColor(answer),
            fontSize: selectedAnswer == answer ? FontSize(25) : FontSize(20),
            textAlign: TextAlign.center),
      }),
    );
  }

  Size getWidgetSize(Answer answer) {
    if (widget.enabled) {
      if (selectedAnswer == answer) {
        return Size(310, 102);
      }
    } else {
      if (selectedAnswer == answer && answer == correctAnswer) {
        return Size(310, 102);
      } else if (answer == correctAnswer) {
        return Size(267, 88);
      }
    }
    return Size(267, 88);
  }

  Color getBackgroundColor(Answer answer, Color selectedColor) {
    if (widget.enabled && selectedAnswer == answer) {
      return selectedColor;
    } else if (!widget.enabled && answer == correctAnswer) {
      return selectedColor;
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Color(0xFFFB7B76);
    }
    return Color(0xFFFAFAFA);
  }

  Color getForegroundColor(Answer answer) {
    if (selectedAnswer == answer ||
        !widget.enabled && correctAnswer == answer) {
      return Colors.white;
    }
    return Color(0xFFBEC7DB);
  }
}

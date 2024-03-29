import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/notes/note_view.dart';
import 'package:ecoach/views/quiz/review_page.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/views/test/test_type.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicsTabPage extends StatefulWidget {
  const TopicsTabPage(
    this.testType, {
    required this.topics,
    required this.diagnostic,
    required this.user,
    required this.course,
    this.testTaken,
    this.history = false,
    Key? key,
  }) : super(key: key);

  final List topics;
  final diagnostic;
  final user;
  final course;
  final TestType testType;
  final bool history;
  final TestTaken? testTaken;

  @override
  _TopicsTabPageState createState() => _TopicsTabPageState();
}

class _TopicsTabPageState extends State<TopicsTabPage> {
  late bool showInPercentage;
  late dynamic selected;

  TextStyle rightWidgetStyle(bool isSelected) {
    return TextStyle(
      fontSize: 11,
      color: isSelected ? Colors.white : Color(0xFF2A9CEA),
    );
  }

  handleSelection(topic) async {
    setState(() {
      print("selected:$topic");
      selectAnsweredQuestions.clear();
      unSelectAnsweredQuestions.clear();
      if (selected == topic)
        selected = null;
      else
        selected = topic;
    });
    if (selected == null) {
      await getAll(null);
    } else {
      await getAll(selected["topicId"]);
    }
  }

  getAll(int? topicId) async {
    reviewQuestionsBack.clear();
    List<Question> questions = [];
    if (selected == null) {
      questions = await TestController()
          .getAllQuestions(widget.testTaken!, topicId: null);
    } else {
      questions = await TestController()
          .getAllQuestions(widget.testTaken!, topicId: topicId);
    }
    for (int i = 0; i < questions.length; i++) {
      print("hmm:${questions[i].selectedAnswer}");
      // await  QuestionDB().insertTestQuestion(questions[i]);
      reviewQuestionsBack.add(questions[i]);
    }

    setState(() {
      print("again savedQuestions:${reviewQuestionsBack.length}");
    });
  }

  @override
  void initState() {
    print("topics:${widget.topics}");
    selected = null;
    getAll(null);
    showInPercentage = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        PercentageSwitch(
          showInPercentage: showInPercentage,
          onChanged: (value) {
            setState(() {
              showInPercentage = value;
            });
          },
        ),
        SizedBox(height: 8),
        // widget.diagnostic && widget.topics.isNotEmpty ?
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
        //   child: MultiPurposeCourseCard(
        //       onTap: () {
        //         handleSelection(widget.topics[0]);
        //       },
        //       isActive: selected == widget.topics[0],
        //       title: widget.topics[0]['name'],
        //       subTitle: widget.topics[0]['rating'],
        //       rightWidget: showInPercentage
        //           ? PercentageSnippet(
        //         correctlyAnswered: widget.topics[0]
        //         ['correctly_answered'],
        //         totalQuestions: widget.topics[0]['total_questions'],
        //         isSelected: selected == widget.topics[0],
        //       )
        //           : FractionSnippet(
        //         correctlyAnswered: widget.topics[0]
        //         ['correctly_answered'],
        //         totalQuestions: widget.topics[0]['total_questions'],
        //         isSelected: selected == widget.topics[0],
        //       )),
        // ) :
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.topics.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: MultiPurposeCourseCard(
                    onTap: () {
                      handleSelection(widget.topics[i]);
                    },
                    isActive: selected == widget.topics[i],
                    title: widget.topics[i]['name'],
                    subTitle: widget.topics[i]['rating'],
                    rightWidget: showInPercentage
                        ? PercentageSnippet(
                            correctlyAnswered: widget.topics[i]
                                ['correctly_answered'],
                            totalQuestions: widget.topics[i]['total_questions'],
                            isSelected: selected == widget.topics[i],
                          )
                        : FractionSnippet(
                            correctlyAnswered: widget.topics[i]
                                ['correctly_answered'],
                            totalQuestions: widget.topics[i]['total_questions'],
                            isSelected: selected == widget.topics[i],
                          )),
              );
            },
          ),
        ),
        // widget.diagnostic ?
        // Expanded(
        //   child: GestureDetector(
        //     onTap: (){
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (context) {
        //             return MainHomePage(
        //               widget.user,
        //               index: 0,
        //             );
        //           }));
        //     },
        //     child: Center(child: sText(widget.diagnostic && context.read<DownloadUpdate>().plans.isNotEmpty ? "No review for diagnostic test" :"Purchase to get full access to quiz",color: Colors.black,weight: FontWeight.bold,size: 18),),
        //    ),
        // ) :
        // Expanded(child: Container()),

        Divider(
          thickness: 3.0,
          color: kPageBackgroundGray,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              if (selected != null || !widget.diagnostic)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'review',
                          onPressed: () async {
                            if (widget.history) {
                            } else {
                              // Navigator.pop(context,[0,0]);
                              if (widget.diagnostic) {
                                // toastMessage("No reviews for diagnostic test");
                                await goTo(
                                    context,
                                    QuizReviewPage(
                                      testTaken: widget.testTaken,
                                      user: widget.user,
                                      disgnostic: true,
                                    ));
                                setState(() {});
                              } else {
                                await goTo(
                                    context,
                                    QuizReviewPage(
                                      testTaken: widget.testTaken,
                                      user: widget.user,
                                    ));
                                setState(() {});
                              }
                            }
                          },
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
              if (!widget.diagnostic && selected != null)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'revise',
                          onPressed: () async {
                            if (widget.diagnostic) {
                              toastMessage("No revise for diagnostic test");
                            } else {
                              int topicId = selected['topicId']!;
                              Topic? topic =
                                  await TopicDB().getTopicById(topicId);

                              if (topic != null) {
                                // print(
                                //     "_______________________________________________________");
                                // print(topic.notes);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return NoteView(widget.user, topic);
                                    });
                              } else {
                                showFeedback(context, "No notes available");
                              }
                            }
                          },
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
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
                                course: widget.course,
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
                                widget.course,
                              );
                            }));
                          },
                        ),
                      ),
              if (widget.diagnostic &&
                  context.read<DownloadUpdate>().plans.isEmpty)
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

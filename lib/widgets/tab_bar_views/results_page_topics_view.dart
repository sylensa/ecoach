import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/lib/features/questions/view/screens/quiz_review_page.dart';
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

  handleSelection(topic) {
    setState(() {
      selectAnsweredQuestions.clear();
      if (selected == topic)
        selected = null;
      else
        selected = topic;
    });
  }


  getAll()async{
    reviewQuestionsBack.clear();
    List<Question> questions = await TestController().getAllQuestions(widget.testTaken!);
    for(int i = 0; i < questions.length; i++){
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

    getAll();
    showInPercentage = false;
    selected = null;
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
        Divider(
          thickness: 3.0,
          color: kPageBackgroundGray,
        ),
        Container(
          color: Colors.white,
          height: 48.0,
          child: Row(
            children: [
              if (selected != null &&  !widget.diagnostic)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'review',
                          onPressed: ()async {
                            if (widget.history) {
                            } else {
                              // Navigator.pop(context,[0,0]);
                                await goTo(context, QuizReviewPage(testTaken: widget.testTaken,user: widget.user,));
                              setState(() {

                              });

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
              if (widget.diagnostic)
                Expanded(
                  child: Button(
                    label: 'Purchase',
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return MainHomePage(
                          widget.user,
                          index: 1,
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

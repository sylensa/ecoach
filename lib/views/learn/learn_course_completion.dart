import 'package:ecoach/controllers/study_cc_controller.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/views/learn/learning_widget.dart';
import 'package:ecoach/views/study/study_notes_view.dart';
import 'package:flutter/material.dart';

import '../../new_ui_ben/screens/course_completion/course_completion.dart';

Color themeColor = Color(0xFF00ABE0);

class LearnCourseCompletion extends StatefulWidget {
  static const String routeName = '/learning/completion';
  const LearnCourseCompletion(this.user, this.course, this.progress, {Key? key})
      : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;

  @override
  _LearnCourseCompletionState createState() => _LearnCourseCompletionState();
}

class _LearnCourseCompletionState extends State<LearnCourseCompletion> {
  @override
  Widget build(BuildContext context) {
    bool showTopic = widget.progress.section! % 2 == 1 ? true : false;
    return showTopic
        ? TopicCover(widget.user, widget.course, widget.progress)
        : QuizCover(widget.user, widget.course, widget.progress);
  }
}

class TopicCover extends StatefulWidget {
  const TopicCover(this.user, this.course, this.progress, {Key? key})
      : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;

  @override
  _TopicCoverState createState() => _TopicCoverState();
}

class _TopicCoverState extends State<TopicCover> {
  @override
  Widget build(BuildContext context) {
    return CourseCompletion(
      proceed: () async {
        int topicId = widget.progress.topicId!;
        Topic? topic = await TopicDB().getTopicById(topicId);
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: LearnCourseCompletion.routeName),
            builder: (context) {
              return StudyNoteView(
                topic!,
                controller: CourseCompletionController(
                  widget.user,
                  widget.course,
                  name: topic.name!,
                  progress: widget.progress,
                ),
              );
            },
          ),
        );
      },
    );

    // SafeArea(
    //   child: Scaffold(
    //     body: SingleChildScrollView(
    //       child: Container(
    //         height: MediaQuery.of(context).size.height,
    //         color: Colors.white,
    //         child: Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: [
    //                 OutlinedButton(
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: Text(
    //                       "return",
    //                       style: TextStyle(color: Color(0xFF9C9C9C)),
    //                     )),
    //                 SizedBox(
    //                   width: 50,
    //                 )
    //               ],
    //             ),
    //             Expanded(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   SizedBox(
    //                     height: 30,
    //                   ),
    //                   Text(
    //                     "Course Completion",
    //                     style: TextStyle(
    //                         color: themeColor,
    //                         fontSize: 29,
    //                         fontWeight: FontWeight.w600),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   SizedBox(
    //                     width: 232,
    //                     child: Text(
    //                       "Let's help you complete this entire course ,\none topic at a time.\nRead notes and take tests to make steady progress.",
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: 12,
    //                           fontStyle: FontStyle.italic,
    //                           color: Color(0xFFA39A9A)),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 40,
    //                   ),
    //                   Image(
    //                     image: AssetImage('assets/images/cc_topic.png'),
    //                     width: 282,
    //                     height: 282,
    //                   ),
    //                   // Spacer(),
    //                 ],
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
    //               child: OutlinedButton(
    //                 onPressed: () async {
    //                   int topicId = widget.progress.topicId!;
    //                   Topic? topic = await TopicDB().getTopicById(topicId);
    //                   Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           settings: RouteSettings(
    //                               name: LearnCourseCompletion.routeName),
    //                           builder: (context) {
    //                             return StudyNoteView(
    //                               topic!,
    //                               controller: CourseCompletionController(
    //                                 widget.user,
    //                                 widget.course,
    //                                 name: topic.name!,
    //                                 progress: widget.progress,
    //                               ),
    //                             );
    //                           }));
    //                 },
    //                 child: Text("Enter"),
    //                 style: ButtonStyle(
    //                   fixedSize: MaterialStateProperty.all(Size(150, 44)),
    //                   foregroundColor: MaterialStateProperty.all(themeColor),
    //                   side: MaterialStateProperty.all(BorderSide(
    //                       color: themeColor,
    //                       width: 1,
    //                       style: BorderStyle.solid)),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  
  
  }
}

class QuizCover extends StatefulWidget {
  const QuizCover(this.user, this.course, this.progress, {Key? key})
      : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;

  @override
  _QuizCoverState createState() => _QuizCoverState();
}

class _QuizCoverState extends State<QuizCover> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "return",
                          style: TextStyle(color: Color(0xFF9C9C9C)),
                        )),
                    SizedBox(
                      width: 50,
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Quiz",
                        style: TextStyle(
                            color: themeColor,
                            fontSize: 29,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 232,
                        child: Text(
                          "Let's take a test on what we've just learned. \nGet 7 out 10 to progress to the next topic .",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFA39A9A)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "10 mins: 10 questions",
                            style: TextStyle(color: themeColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image(
                        image: AssetImage('assets/images/cc_quiz.png'),
                        width: 282,
                        height: 282,
                      ),
                      // Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: OutlinedButton(
                    onPressed: () async {
                      int topicId = widget.progress.topicId!;
                      List<Question> questions =
                          await QuestionDB().getTopicQuestions([topicId], 10);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(
                                  name: LearnCourseCompletion.routeName),
                              builder: (context) {
                                return LearningWidget(
                                  controller: CourseCompletionController(
                                    widget.user,
                                    widget.course,
                                    name: widget.progress.name!,
                                    questions: questions,
                                    progress: widget.progress,
                                  ),
                                );
                              }));
                    },
                    child: Text("Enter"),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(150, 44)),
                      foregroundColor: MaterialStateProperty.all(themeColor),
                      side: MaterialStateProperty.all(BorderSide(
                          color: themeColor,
                          width: 1,
                          style: BorderStyle.solid)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

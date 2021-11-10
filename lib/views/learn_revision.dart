import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learning_widget.dart';
import 'package:flutter/material.dart';

class LearnRevision extends StatefulWidget {
  static const String routeName = '/learning/revision';
  const LearnRevision(this.user, this.course, this.progress, {Key? key})
      : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;

  @override
  _LearnRevisionState createState() => _LearnRevisionState();
}

class _LearnRevisionState extends State<LearnRevision> {
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
                        "Revision Mode",
                        style: TextStyle(
                            color: Color(0xFF00C664),
                            fontSize: 29,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 232,
                        child: Text(
                          "We will take you through a series of questions. Whilst we do that we will help you revise topics you seem to struggle with.",
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
                      Image(
                        image:
                            AssetImage('assets/images/learning_revision.png'),
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
                          settings:
                              RouteSettings(name: LearnRevision.routeName),
                          builder: (context) {
                            return LearningWidget(
                              controller: StudyController(
                                  widget.user, widget.course,
                                  name: widget.progress.name ??
                                      widget.course.name!,
                                  questions: questions,
                                  type: StudyType.REVISION,
                                  progress: widget.progress),
                            );
                          },
                        ),
                      );
                    },
                    child: Text("Enter"),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(150, 44)),
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xFF00C664)),
                      side: MaterialStateProperty.all(BorderSide(
                          color: Color(0xFF00C664),
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

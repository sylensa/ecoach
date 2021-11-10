import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learning_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudyNoteView extends StatefulWidget {
  const StudyNoteView(this.topic, {Key? key, required this.controller})
      : super(key: key);
  final StudyController controller;
  final Topic topic;

  @override
  _StudyNoteViewState createState() => _StudyNoteViewState();
}

class _StudyNoteViewState extends State<StudyNoteView> {
  late StudyController controller;

  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(controller.name,
                    style: TextStyle(
                        color: Color(0xFF15CA70),
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                OutlinedButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(LearnMode.routeName));
                    },
                    child: Text("Exit"))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  color: Color(0xFFF6F6F6),
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Html(
                        data: widget.topic.notes,
                        style: {
                          // tables will have the below background color
                          "body": Style(
                            fontSize: FontSize(17),
                            color: Colors.black,
                            backgroundColor: Color(0xFFF6F6F6),
                            padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 25),
                          ),

                          'td': Style(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          'th': Style(backgroundColor: Colors.white),
                          'img': Style(
                              width: 200,
                              height: 200,
                              padding: EdgeInsets.all(10)),
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                int topicId = controller.progress.topicId!;
                                List<Question> questions = await QuestionDB()
                                    .getTopicQuestions([topicId], 10);

                                controller.questions = questions;
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LearningWidget(
                                    controller: controller,
                                  );
                                }));
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                    style: BorderStyle.solid)),
                              ),
                              child: Text(
                                "Take Test",
                                style: TextStyle(color: Colors.black),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

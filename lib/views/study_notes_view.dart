import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/views/learn_course_completion.dart';
import 'package:ecoach/views/learn_mastery_improvement.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learn_revision.dart';
import 'package:ecoach/views/learn_speed_enhancement.dart';
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
    return SafeArea(
      child: Scaffold(
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
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 10, 8, 25),
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
                                  if (controller.type ==
                                      StudyType.COURSE_COMPLETION) {
                                    await controller.updateProgessSection(2);
                                  }
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    switch (controller.type) {
                                      case StudyType.REVISION:
                                        return LearnRevision(
                                            controller.user,
                                            controller.course,
                                            controller.progress);
                                      case StudyType.COURSE_COMPLETION:
                                        return LearnCourseCompletion(
                                            controller.user,
                                            controller.course,
                                            controller.progress);
                                      case StudyType.SPEED_ENHANCEMENT:
                                        return LearnSpeed(
                                            controller.user, controller.course);
                                      case StudyType.MASTERY_IMPROVEMENT:
                                        return LearnMastery(
                                            controller.user, controller.course);
                                      case StudyType.NONE:
                                        return Container(
                                          child: Text("Study type is none"),
                                        );
                                    }
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
      ),
    );
  }
}

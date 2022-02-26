import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/controllers/study_revision_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/views/learn_course_completion.dart';
import 'package:ecoach/views/learn_mastery_improvement.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learn_revision.dart';
import 'package:ecoach/views/learn_speed_enhancement.dart';
import 'package:ecoach/views/learning_widget.dart';
import 'package:ecoach/views/study_quiz_cover.dart';
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
  bool notesExit = true;

  @override
  void initState() {
    controller = widget.controller;
    notesExit =
        widget.topic.notes != null && widget.topic.notes!.trim().length > 0;
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
                  Expanded(
                    child: Text(controller.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xFF15CA70),
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                  ),
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
                        notesExit
                            ? Html(data: widget.topic.notes, style: {
                                // tables will have the below background color
                                "body": Style(
                                  fontSize: FontSize(17),
                                  color: Colors.black,
                                  backgroundColor: Color(0xFFF6F6F6),
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 10, 8, 25),
                                ),

                                'td': Style(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                'th': Style(backgroundColor: Colors.white),
                                'img': Style(
                                    width: 200,
                                    height: 200,
                                    padding: EdgeInsets.all(10)),
                              }, customRenders: {
                                networkSourceMatcher(): CustomRender.widget(
                                    widget: (context, element) {
                                  String? link =
                                      context.tree.element!.attributes['src'];
                                  if (link != null) {
                                    String name = link
                                        .substring(link.lastIndexOf("/") + 1);
                                    print("Image: $name");

                                    return Image.file(
                                      controller.user.getImageFile(name),
                                    );
                                  }
                                  return Text("No link");
                                }),
                              })
                            : Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Center(
                                    child: Text(
                                  "No notes for this topic",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic),
                                )),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                                onPressed: () async {
                                  List<Question>? questions;
                                  if (controller.type == StudyType.REVISION) {
                                    questions = await QuestionDB()
                                        .getTopicQuestions(
                                            [controller.progress.topicId!], 10);
                                  }
                                  if (controller.type ==
                                      StudyType.COURSE_COMPLETION) {
                                    await controller.updateProgressSection(2);
                                  }
                                  if (controller.type ==
                                      StudyType.MASTERY_IMPROVEMENT) {
                                    await controller.updateProgressSection(2);
                                    questions = await QuestionDB()
                                        .getMasteryTopicQuestions(
                                            controller.progress.topicId!, 5);
                                  }
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    switch (controller.type) {
                                      case StudyType.REVISION:
                                        return StudyQuizCover(
                                          topicName: controller.progress.name!,
                                          controller: RevisionController(
                                              controller.user,
                                              controller.course,
                                              questions: questions!,
                                              name: controller.progress.name!,
                                              progress: controller.progress),
                                        );
                                      case StudyType.COURSE_COMPLETION:
                                        return LearnCourseCompletion(
                                            controller.user,
                                            controller.course,
                                            controller.progress);
                                      case StudyType.SPEED_ENHANCEMENT:
                                        return LearnSpeed(
                                            controller.user,
                                            controller.course,
                                            controller.progress);
                                      case StudyType.MASTERY_IMPROVEMENT:
                                        return StudyQuizCover(
                                            topicName:
                                                controller.progress.name!,
                                            controller: MasteryController(
                                                controller.user,
                                                controller.course,
                                                questions: questions!,
                                                name: controller.progress.name!,
                                                progress: controller.progress));
                                      case StudyType.NONE:
                                        return Container(
                                          child: Text("Study type is none"),
                                        );
                                    }
                                  }));
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors.black,
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

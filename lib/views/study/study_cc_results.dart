import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn/learn_completed.dart';
import 'package:ecoach/views/learn/learn_course_completion.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/views/study/study_notes_view.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new_learn_mode/providers/learn_mode_provider.dart';

class StudyCCResults extends StatefulWidget {
  const StudyCCResults({
    Key? key,
    required this.test,
    required this.controller,
  }) : super(key: key);

  final StudyController controller;
  final TestTaken test;

  @override
  _StudyCCResultsState createState() => _StudyCCResultsState();
}

class _StudyCCResultsState extends State<StudyCCResults> {
  late StudyController controller;
  static const TextStyle _topLabelStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFF969696),
  );
  static const TextStyle _topMainTextStyle = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    color: kAdeoGray2,
  );

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
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(LearnMode.routeName));
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircularProgressIndicatorWrapper(
                        subCenterText: 'avg. score',
                        progress: widget.test.score!,
                        progressColor: kAdeoGreen,
                        size: ProgressIndicatorSize.large,
                        resultType: true,
                      ),
                      SizedBox(height: 12.0),
                      Text('Score', style: _topLabelStyle)
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                          getDurationTime(
                              Duration(seconds: widget.test.usedTime ?? 0)),
                          style: _topMainTextStyle),
                      Text('Time Taken', style: _topLabelStyle)
                    ],
                  ),
                  Column(
                    children: [
                      Text("${widget.test.numberOfQuestions}",
                          style: _topMainTextStyle),
                      Text('Questions', style: _topLabelStyle)
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: controller.progress.passed!
                  ? resultImageText('assets/images/congrats.png',
                      'Congratulation', 'You did a great job in the test!')
                  : resultImageText("assets/images/aww.png", "Aww",
                      "You scored below the pass mark.\nLet's try one more time\nTogether we can"),
            ),
            Container(height: 6.0, color: Colors.white),
            Container(
              height: 52.0,
              color: Color(0xFFF6F6F6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Button(
                      label: 'review',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(width: 1.0, color: kNavigationTopBorderColor),
                  if (!controller.progress.passed!)
                    Expanded(
                      child: Button(
                        label: 'revise',
                        onPressed: () async {
                          Topic? topic = await TopicDB()
                              .getTopicById(controller.progress.topicId!);

                          if (topic != null) {
                            print(
                                "_______________________________________________________");
                            print(topic.notes);
                            await controller.updateProgressSection(1);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StudyNoteView(
                                    topic,
                                    controller: controller,
                                  );
                                });
                          } else {
                            showFeedback(context, "No notes available");
                          }
                        },
                      ),
                    ),
                  if (controller.progress.passed!)
                    Expanded(
                      child: Button(
                        label: 'Continue',
                        onPressed: () async {
                          int nextLevel = controller.nextLevel;
                          Topic? topic = await TopicDB()
                              .getLevelTopic(controller.course.id!, nextLevel);
                          if (topic != null) {
                            print("${topic.name}");
                            StudyProgress progress = StudyProgress(
                                id: topic.id,
                                studyId: controller.progress.studyId!,
                                level: nextLevel,
                                section: 1,
                                topicId: topic.id,
                                name: topic.name,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now());
                            await StudyDB().insertProgress(progress);

                            Course? course = Provider.of<LearnModeProvider>(
                                    context,
                                    listen: false)
                                .currentCourse;
                            //
                            // CourseCompletionStudyProgress?
                            //     completionStudyProgress = await StudyDB()
                            //         .getCurrentCourseCompletionProgressByCourse(
                            //             course!.id!);
                            //
                            // CourseCompletionStudyController()
                            //     .updateInsertProgress(completionStudyProgress!);

                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return LearnCourseCompletion(
                                  controller.user, controller.course, progress);
                            }), ModalRoute.withName(LearnMode.routeName));
                          } else {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return LearnCompleted(controller: controller);
                            }), ModalRoute.withName(LearnMode.routeName));
                          }
                        },
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget resultImageText(String imagePath, String text, String subText) {
    return Column(
      children: [
        Image(
          image: AssetImage(imagePath),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 30, color: Color(0xFF323232)),
        ),
        Text(
          subText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Color(0xFFA2A2A2)),
        )
      ],
    );
  }
}

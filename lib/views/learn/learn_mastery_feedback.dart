import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/database/mastery_course_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn/learn_completed.dart';
import 'package:ecoach/views/learn/learn_next_topic.dart';
import 'package:ecoach/views/study/study_notes_view.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new_learn_mode/providers/learn_mode_provider.dart';

class LearnMasteryFeedback extends StatelessWidget {
  const LearnMasteryFeedback(
      {required this.passed,
      required this.topic,
      required this.controller,
      required this.masteryCourseUpgrade,
      required this.topicId});

  final bool passed;
  final String topic;
  final int topicId;
  final MasteryCourseUpgrade masteryCourseUpgrade;
  final MasteryController controller;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                      progress: controller.score,
                      progressColor: passed ? kAdeoGreen : kAdeoCoral,
                      size: ProgressIndicatorSize.large,
                      resultType: true,
                    ),
                    SizedBox(height: 12.0),
                    Text('Score', style: _topLabelStyle)
                  ],
                ),
                Container(
                  height: 120.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 12.0),
                      Text(getDurationTime(controller.getTestDuration()),
                          style: _topMainTextStyle),
                      Text('Time Taken', style: _topLabelStyle)
                    ],
                  ),
                ),
                Container(
                  height: 120.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 12.0),
                      Text("${controller.questions.length}",
                          style: _topMainTextStyle),
                      Text('Questions', style: _topLabelStyle)
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 290.0,
                  child: Image.asset(
                    'assets/images/learn_module/${passed ? 'congrats' : 'aww'}.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  passed ? 'Congratulations' : 'Aww',
                  style: TextStyle(
                    color: kDefaultBlack,
                    fontSize: 32.0,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  passed
                      ? 'You have successfully mastered\n${masteryCourseUpgrade.topicName}'
                      : 'You scored below the pass mark.\nLet\'s try one more time\nTogether we can',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: kAdeoGray2,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
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
                Expanded(
                  child: Button(
                    label: passed ? 'continue' : 'revise',
                    onPressed: () async {
                      List<MasteryCourseUpgrade> masteryTopics =
                          await MasteryCourseDB().getMasteryTopicsUpgrade(
                              Provider.of<LearnModeProvider>(context,
                                      listen: false)
                                  .currentCourse!
                                  .id!);

                      if (passed) {
                        StudyProgress progress =
                            await controller.updateMasteryCourse();
                        masteryCourseUpgrade.passed = passed;
                        await MasteryCourseDB()
                            .updateMasteryCourseUpgrade(masteryCourseUpgrade);

                        controller.updateProgressSection(2);

                        masteryTopics = await MasteryCourseDB()
                            .getMasteryTopicsUpgrade(
                                Provider.of<LearnModeProvider>(context,
                                        listen: false)
                                    .currentCourse!
                                    .id!);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          if (masteryTopics.isNotEmpty) {
                            MasteryCourseUpgrade topic = masteryTopics[0];
                            return LearnNextTopic(
                              controller.user,
                              controller.course,
                              progress,
                              topic: topic,
                            );
                          } else {
                            return LearnCompleted(controller: controller);
                          }
                        }));
                      }
                      if (!passed) {
                        Topic? topic = await TopicDB()
                            .getTopicById(masteryCourseUpgrade.topicId!);
                        controller.updateProgressSection(1);
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return StudyNoteView(topic!, controller: controller);
                        }), (route) => false);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

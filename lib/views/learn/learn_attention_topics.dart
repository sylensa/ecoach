import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/database/mastery_course_db.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn/learn_mastery_feedback.dart';
import 'package:ecoach/views/learn/learn_mastery_topic.dart';
import 'package:ecoach/views/learn/learn_next_topic.dart';
import 'package:flutter/material.dart';

class LearnAttentionTopics extends StatelessWidget {
  TextStyle auxTextStyle = TextStyle(
    fontSize: 20.0,
    color: kAdeoGray3,
    fontWeight: FontWeight.w500,
  );

  TextStyle listStyle = TextStyle(
    fontSize: 15.0,
    color: kDefaultBlack,
    height: 3.0,
  );

  LearnAttentionTopics({required this.topics, required this.controller});
  final List<Topic> topics;
  final MasteryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 56.0,
            padding: EdgeInsets.only(
              top: 32.0,
              left: 24.0,
              right: 24.0,
              bottom: 32.0,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Text(
                      "${topics.length}",
                      style: TextStyle(
                        color: kAdeoGray3,
                        fontSize: 100.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                      bottom: 32,
                      child: Container(
                        height: 1.5,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            double.infinity,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: darken(kAdeoGray2, 80),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'topics',
                  style: auxTextStyle,
                ),
                Text(
                  'need your attention',
                  style: auxTextStyle,
                ),
                SizedBox(
                  width: 222.0,
                  child: Divider(
                    color: kAdeoGray2,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < topics.length; i++)
                          Text(topics[i].name!, style: listStyle),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 222.0,
                  child: Divider(
                    color: kAdeoGray2,
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'click on the button below to improve\nyour performance in those topics',
                  style: auxTextStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              MasteryCourse? topic = await MasteryCourseDB()
                  .getCurrentTopic(controller.progress.studyId!);
              if (topic != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LearnNextTopic(
                    controller.user,
                    controller.course,
                    controller.progress,
                    topic: topic,
                  );
                }));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Mastery topic does not exist")));
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 56.0,
              width: double.infinity,
              color: kAdeoGreen,
              child: Text(
                'let\'s go',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

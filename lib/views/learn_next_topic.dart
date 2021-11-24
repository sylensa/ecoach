import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn_mastery_improvement.dart';
import 'package:ecoach/views/study_notes_view.dart';
import 'package:ecoach/widgets/layouts/learn_peripheral_layout.dart';
import 'package:flutter/material.dart';

class LearnNextTopic extends StatelessWidget {
  static const String routeName = '/learning/mastery/next';
  const LearnNextTopic(
    this.user,
    this.course,
    this.progress, {
    Key? key,
    required this.topic,
  }) : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;
  final MasteryCourse topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LearnPeripheralWidget(
        heroText: 'Next Topic',
        subText: topic.topicName!,
        heroImageURL: 'assets/images/learn_module/next_topic.png',
        topActionLabel: 'exit',
        topActionOnPressed: () {},
        topActionColor: kAdeoCoral,
        mainActionLabel: 'let\'s go',
        mainActionColor: kAdeoCoral,
        mainActionOnPressed: () async {
          int topicId = topic.topicId!;
          Topic? currentTopic = await TopicDB().getTopicById(topicId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: LearnNextTopic.routeName),
                  builder: (context) {
                    return StudyNoteView(
                      currentTopic!,
                      controller: MasteryController(
                        user,
                        course,
                        name: currentTopic.name!,
                        progress: progress,
                      ),
                    );
                  }));
        },
      ),
    );
  }
}

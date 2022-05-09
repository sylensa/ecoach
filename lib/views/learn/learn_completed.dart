import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/widgets/layouts/speed_enhancement_introit.dart';
import 'package:flutter/material.dart';

class LearnCompleted extends StatefulWidget {
  const LearnCompleted({Key? key, required this.controller}) : super(key: key);
  final StudyController controller;

  @override
  _LearnCompletedState createState() => _LearnCompletedState();
}

class _LearnCompletedState extends State<LearnCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpeedEnhancementIntroit(
        heroText: getTypeString(widget.controller.type),
        subText:
            'Congratulation! You have completed this ${getTypeString(widget.controller.type)} for ${widget.controller.course.name}',
        heroImageURL: 'assets/images/learn_module/mission_accomplished.png',
        topActionOnPressed: () {
          Navigator.popUntil(context, ModalRoute.withName(LearnMode.routeName));
        },
        mainActionLabel: 'Done',
        color: kAdeoTaupe,
        mainActionOnPressed: () async {
          Navigator.popUntil(context, ModalRoute.withName(LearnMode.routeName));
        },
      ),
    );
  }

  String getTypeString(StudyType type) {
    switch (type) {
      case StudyType.REVISION:
        return "Revision";
      case StudyType.COURSE_COMPLETION:
        return "Course Completion";
      case StudyType.SPEED_ENHANCEMENT:
        return "Speed Enhancement";
      case StudyType.MASTERY_IMPROVEMENT:
        return "Mastery Improvement";
      case StudyType.NONE:
        return "None";
    }
  }
}

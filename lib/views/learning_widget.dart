import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/study_quiz_view.dart';
import 'package:flutter/material.dart';

class LearningWidget extends StatefulWidget {
  const LearningWidget(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearningWidgetState createState() => _LearningWidgetState();
}

class _LearningWidgetState extends State<LearningWidget> {
  late StudyController controller;
  @override
  void initState() {
    controller = StudyController(widget.user, [], name: widget.course.name!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StudyQuizView(
      controller: controller,
    ));
  }
}

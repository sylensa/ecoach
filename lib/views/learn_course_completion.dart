import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class LearnCourseCompletion extends StatefulWidget {
  const LearnCourseCompletion(this.user, this.course, {Key? key})
      : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnCourseCompletionState createState() => _LearnCourseCompletionState();
}

class _LearnCourseCompletionState extends State<LearnCourseCompletion> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

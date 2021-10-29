import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class LearnRevision extends StatefulWidget {
  const LearnRevision(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnRevisionState createState() => _LearnRevisionState();
}

class _LearnRevisionState extends State<LearnRevision> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class LearnSpeed extends StatefulWidget {
  const LearnSpeed(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnSpeedState createState() => _LearnSpeedState();
}

class _LearnSpeedState extends State<LearnSpeed> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

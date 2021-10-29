import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class LearnMastery extends StatefulWidget {
  const LearnMastery(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnMasteryState createState() => _LearnMasteryState();
}

class _LearnMasteryState extends State<LearnMastery> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

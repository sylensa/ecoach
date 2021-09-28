import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class MockListView extends StatefulWidget {
  const MockListView(this.user, this.quizzes, {Key? key}) : super(key: key);

  final User user;
  final List<Quiz> quizzes;

  @override
  _MockListViewState createState() => _MockListViewState();
}

class _MockListViewState extends State<MockListView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

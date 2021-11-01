import 'dart:convert';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:flutter/cupertino.dart';

class StudyController {
  StudyController(
    this.user,
    this.questions, {
    this.course,
    required this.name,
    this.type = StudyType.NONE,
  });

  final User user;
  final Course? course;
  final List<Question> questions;
  final String name;
  final StudyType type;

  bool enabled = true;
  bool savedTest = false;

  int currentQuestion = 0;
  int finalQuestion = 0;

  DateTime startTime = DateTime.now();
  late Duration duration, resetDuration, startingDuration;

  double get score {
    int totalQuestions = questions.length;
    int correctAnswers = correct;
    return correctAnswers / totalQuestions * 100;
  }

  int get correct {
    int score = 0;
    questions.forEach((question) {
      if (question.isCorrect) score++;
    });
    return score;
  }

  int get wrong {
    int wrong = 0;
    questions.forEach((question) {
      if (question.isWrong) wrong++;
    });
    return wrong;
  }

  int get unattempted {
    int unattempted = 0;
    questions.forEach((question) {
      if (question.unattempted) unattempted++;
    });
    return unattempted;
  }

  String get responses {
    Map<String, dynamic> responses = Map();
    int i = 1;
    questions.forEach((question) {
      print(question.topicName);
      Map<String, dynamic> answer = {
        "question_id": question.id,
        "topic_id": question.topicId,
        "topic_name": question.topicName,
        "selected_answer_id": question.selectedAnswer != null
            ? question.selectedAnswer!.id
            : null,
        "status": question.isCorrect
            ? "correct"
            : question.isWrong
                ? "wrong"
                : "unattempted",
      };

      responses["$i"] = answer;
      i++;
    });
    return jsonEncode(responses);
  }

  saveTest(
      BuildContext context, Function(TestTaken? test, bool success) callback) {
    TestTaken testTaken = TestTaken(
        userId: user.id,
        datetime: startTime,
        totalQuestions: questions.length,
        courseId: course!.id,
        testname: name,
        testType: type.toString(),
        testTime: duration.inSeconds,
        usedTime: DateTime.now().difference(startTime).inSeconds,
        responses: responses,
        score: score,
        correct: correct,
        wrong: wrong,
        unattempted: unattempted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    ApiCall<TestTaken>(AppUrl.testTaken,
        user: user, isList: false, params: testTaken.toJson(), create: (json) {
      return TestTaken.fromJson(json);
    }, onError: (err) {
      callback(null, false);
    }, onCallback: (data) {
      print('onCallback');
      print(data);
      TestController().saveTestTaken(data!);
      callback(data, true);
    }).post(context);
  }
}

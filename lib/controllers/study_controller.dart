import 'dart:convert';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/mastery_course_db.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class StudyController {
  StudyController(this.user, this.course,
      {this.questions = const [],
      required this.name,
      this.type = StudyType.NONE,
      required this.progress}) {
    if (type == StudyType.COURSE_COMPLETION) {
      duration = Duration(minutes: 10);
    }
  }

  final User user;
  final Course course;
  List<Question> questions;
  final String name;
  StudyType type;
  final StudyProgress progress;

  bool enabled = true;
  bool reviewMode = false;
  bool savedTest = false;
  Map<int, bool> saveQuestion = new Map();

  int currentQuestion = 0;
  int finalQuestion = 0;

  DateTime? startTime;
  Duration? duration, resetDuration, startingDuration;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  TimerController? timerController;
  int countdownInSeconds = 0;

  startTest() {
    startTime = DateTime.now();
  }

  int get nextLevel {
    return progress.level! + 1;
  }

  bool get lastQuestion {
    return currentQuestion == questions.length - 1;
  }

  double get percentageCompleted {
    if (questions.length < 1) return 0;
    return (currentQuestion + 1) / questions.length;
  }

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

      responses["Q$i"] = answer;
      i++;
    });
    return jsonEncode(responses);
  }

  saveTest(BuildContext context,
      Function(TestTaken? test, bool success) callback) async {
    TestTaken testTaken = TestTaken(
        userId: user.id,
        datetime: startTime,
        totalQuestions: questions.length,
        courseId: course.id,
        testname: name,
        testType: type.toString(),
        testTime: duration == null ? -1 : duration!.inSeconds,
        usedTime: DateTime.now().difference(startTime!).inSeconds,
        responses: responses,
        score: score,
        correct: correct,
        wrong: wrong,
        unattempted: unattempted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    print("testing connection");
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      print("not connected");
      await OfflineSaveController(context, user).saveTestTaken(testTaken);
      callback(testTaken, true);
    } else {
      ApiCall<TestTaken>(AppUrl.testTaken,
          user: user,
          isList: false,
          params: testTaken.toJson(), create: (json) {
        return TestTaken.fromJson(json);
      }, onError: (err) {
        OfflineSaveController(context, user).saveTestTaken(testTaken);
        callback(null, false);
      }, onCallback: (data) {
        print('onCallback');
        print(data);
        TestController().saveTestTaken(data!);
        callback(data, true);
      }).post(context);
    }
  }

  updateProgress(TestTaken test) async {
    progress.testId = test.id;
    progress.score = score;
    progress.passed = score >= 70 ? true : false;
    progress.updatedAt = DateTime.now();

    print("progress after complete ${progress.toJson()}");

    await StudyDB().updateProgress(progress);

    return progress;
  }

  updateProgressSection(int section) async {
    progress.section = section;
    await StudyDB().updateProgress(progress);

    return progress;
  }

  saveAnswer() {}

  enableQuestion(bool state) {
    saveQuestion[currentQuestion] = state;
  }

  questionEnabled(int i) {
    if (i > saveQuestion.length - 1) return enabled;
    return saveQuestion[i];
  }

  pauseTimer() {}
}

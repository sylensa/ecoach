import 'dart:convert';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:flutter/cupertino.dart';

class MarathonController {
  MarathonController(
    this.user,
    this.course, {
    this.name,
    this.marathon,
  }) {}

  final User user;
  final Course course;
  String? name;
  Marathon? marathon;

  List<MarathonProgress> questions = [];

  bool enabled = true;
  bool reviewMode = false;
  bool savedTest = false;
  Map<int, bool> saveQuestion = new Map();

  int currentQuestion = 0;
  int finalQuestion = 0;

  DateTime? startTime;
  Duration? duration, resetDuration, startingDuration;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  CustomTimerController? timerController;
  int countdownInSeconds = 0;

  startTest() {
    startTime = DateTime.now();
  }

  int get nextLevel {
    return 0; // progress.level! + 1;
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
    if (totalQuestions == 0) {
      return 0;
    }
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

  double get avgScore {
    print("avg scoring current question= $currentQuestion");
    int totalQuestions = currentQuestion + 1;

    int correctAnswers = correct;
    if (totalQuestions == 0) {
      return 0;
    }
    return correctAnswers / totalQuestions * 100;
  }

  double get avgTime {
    double time = 0;
    questions.forEach((question) {
      if (question.time != null) {
        time += question.time!;
      }
    });
    return time;
  }

  double getAvgScore() {
    if (marathon == null) return 0;
    return marathon!.avgScore ?? 0;
  }

  double getAvgTime() {
    if (marathon == null) return 0;
    return marathon!.avgTime ?? 0;
  }

  int getTotalCorrect() {
    if (marathon == null) return 0;
    return marathon!.totalCorrect ?? 0;
  }

  int getTotalWrong() {
    if (marathon == null) return 0;
    return marathon!.totalWrong ?? 0;
  }

  String get responses {
    Map<String, dynamic> responses = Map();
    int i = 1;
    questions.forEach((question) {
      print(question.topicName);
      Map<String, dynamic> answer = {
        "question_id": question.questionId,
        "topic_id": question.topicId,
        "topic_name": question.topicName,
        "selected_answer_id":
            question.selectedAnswer != null ? question.selectedAnswerId : null,
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

  TestTaken getTest() {
    TestTaken testTaken = TestTaken(
        userId: user.id,
        datetime: startTime,
        totalQuestions: questions.length,
        courseId: course.id,
        testname: name,
        testTime: duration == null ? -1 : duration!.inSeconds,
        usedTime: DateTime.now().difference(startTime!).inSeconds,
        responses: responses,
        score: score,
        correct: correct,
        wrong: wrong,
        unattempted: unattempted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    return testTaken;
  }

  saveTest(
      BuildContext context, Function(TestTaken? test, bool success) callback) {
    TestTaken testTaken = TestTaken(
        userId: user.id,
        datetime: startTime,
        totalQuestions: questions.length,
        courseId: course.id,
        testname: name,
        // testType: type.toString(),
        testTime: duration == null ? -1 : duration!.inSeconds,
        usedTime: DateTime.now().difference(startTime!).inSeconds,
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

  scoreCurrentQuestion() async {
    MarathonProgress mp = questions[currentQuestion];
    Question question = mp.question!;
    if (question.unattempted) {
      return;
    }

    mp.selectedAnswerId = question.selectedAnswer!.id;
    print(mp.toJson());
    if (question.isCorrect) {
      mp.status = "correct";
    } else if (question.isWrong) {
      mp.status = "wrong";
    }
    marathon!.avgScore = avgScore;
    marathon!.avgTime = avgTime;
    marathon!.totalTime = 0;
    marathon!.totalCorrect = correct;
    marathon!.totalWrong = wrong;
    marathon!.totalQuestions = marathon!.totalCorrect! + marathon!.totalWrong!;
    marathon!.status = MarathonStatus.IN_PROGRESS.toString();

    print(mp.toJson());
    print(marathon!.toJson());
    await MarathonDB().update(marathon!);
    await MarathonDB().updateProgress(mp);

    if (mp.status == "wrong") {
      MarathonProgress newMp = mp.clone();
      newMp.id = null;
      newMp.status = null;
      newMp.questionId = mp.questionId;
      newMp.question = await QuestionDB().getQuestionById(mp.questionId!);
      newMp.selectedAnswerId = null;
      questions.add(newMp);
      int? progressId = await MarathonDB().insertProgress(newMp);
      if (progressId != null) newMp.id = progressId;
    }
  }

  enableQuestion(bool state) {
    saveQuestion[currentQuestion] = state;
  }

  questionEnabled(int i) {
    if (i > saveQuestion.length - 1) return enabled;
    return saveQuestion[i];
  }

  pauseTimer() {}

  stopTimer() {}

  createMarathon() async {
    marathon = Marathon(
      title: name,
      type: MarathonType.FULL.toString(),
      courseId: course.id,
      status: MarathonStatus.NEW.toString(),
      userId: user.id,
      startTime: DateTime.now(),
      avgScore: 0,
      avgTime: 0,
      totalCorrect: 0,
      totalWrong: 0,
    );

    int marathonId = await MarathonDB().insert(marathon!);
    marathon!.id = marathonId;
    List<Question> quesList =
        await QuestionDB().getMarathonQuestions(course.id!);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      MarathonProgress mp = MarathonProgress(
        courseId: course.id,
        marathonId: marathonId,
        questionId: quesList[i].id,
        topicId: quesList[i].topicId,
        topicName: quesList[i].topicName,
        userId: user.id,
      );
      mp.question = quesList[i];
      if (mp.question != null) {
        questions.add(mp);
      }
    }

    await MarathonDB().insertAllProgress(questions);
    questions = await MarathonDB().getProgresses(marathonId);
  }

  createTopicMarathon(int topicId) async {
    marathon = Marathon(
      title: name,
      type: MarathonType.TOPIC.toString(),
      topicId: topicId,
      courseId: course.id,
      status: MarathonStatus.NEW.toString(),
      userId: user.id,
      startTime: DateTime.now(),
    );

    int marathonId = await MarathonDB().insert(marathon!);
    marathon!.id = marathonId;
    List<Question> quesList =
        await QuestionDB().getMarathonTopicQuestions(topicId);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      MarathonProgress mp = MarathonProgress(
        courseId: course.id,
        marathonId: marathonId,
        questionId: quesList[i].id,
        topicId: quesList[i].topicId,
        topicName: quesList[i].topicName,
        userId: user.id,
      );
      mp.question = quesList[i];
      if (mp.question != null) {
        questions.add(mp);
      }
    }

    await MarathonDB().insertAllProgress(questions);
    questions = await MarathonDB().getProgresses(marathonId);
  }

  Future<bool> loadMarathon() async {
    marathon = await MarathonDB().getCurrentMarathon(course);

    if (marathon != null) {
      print(marathon!.toJson());
      questions = await MarathonDB().getProgresses(marathon!.id!);
      int index = 0;
      for (int i = 0; i < questions.length; i++) {
        if (questions[i].status == null) {
          print(questions[i].toJson());
          currentQuestion = index;
          break;
        }
        index++;
      }
      return true;
    }

    return false;
  }

  endMarathon() async {
    marathon!.status = MarathonStatus.COMPLETED.toString();
    marathon!.endTime = DateTime.now();
    MarathonDB().update(marathon!);
  }

  deleteMarathon() async {
    marathon = await MarathonDB().getCurrentMarathon(course);
    if (marathon != null) {
      questions = await MarathonDB().getProgresses(marathon!.id!);
      await MarathonDB().delete(marathon!.id!);
      for (int i = 0; i < questions.length; i++) {
        await MarathonDB().deleteProgress(questions[i].id!);
      }
      return true;
    }

    return false;
  }

  restartMarathon() async {
    marathon = await MarathonDB().getCurrentMarathon(course);

    if (marathon != null) {
      int? topicId = marathon!.topicId;
      await deleteMarathon();
      if (topicId == null) {
        await createMarathon();
      } else {
        await createTopicMarathon(topicId);
      }
    }
  }
}

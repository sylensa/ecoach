import 'dart:convert';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/database/autopilot_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AutopilotController {
  AutopilotController(
    this.user,
    this.course, {
    this.name,
    this.autopilot,
    this.topics = const [],
    this.topicId,
  }) {
    timerController = CustomTimerController();
  }

  final User user;
  final Course course;
  String? name;
  Autopilot? autopilot;
  List<TestNameAndCount> topics;
  List<AutopilotProgress> questions = [];
  int? topicId;

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
  DateTime questionTimer = DateTime.now();

  startTest() {
    startTime = DateTime.now();
    timerController!.start();
    questionTimer = DateTime.now();
  }

  pauseTimer() {
    timerController!.pause();
  }

  resumeTimer() {
    timerController!.start();
  }

  nextQuestion() {
    currentQuestion++;
    questionTimer = DateTime.now();
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
      if (question.isWrong && question.status != null) wrong++;
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
    int length = 0;
    questions.forEach((question) {
      if (question.time != null && question.time! > 0) {
        time += question.time!;
        length++;
      }
    });
    print("Length=$length, time=$time");
    if (length == 0) length = 1;
    return time / length;
  }

  double getAvgScore() {
    if (autopilot == null) return 0;
    return autopilot!.avgScore ?? 0;
  }

  double getAvgTime() {
    if (autopilot == null) return 0;
    return autopilot!.avgTime ?? 0;
  }

  int getTotalCorrect() {
    if (autopilot == null) return 0;
    return autopilot!.totalCorrect ?? 0;
  }

  int getTotalWrong() {
    if (autopilot == null) return 0;
    return autopilot!.totalWrong ?? 0;
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

  saveTest(BuildContext context,
      Function(TestTaken? test, bool success) callback) async {
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

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
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

  Future<bool> scoreCurrentQuestion() async {
    print("scoring...");
    AutopilotProgress ap = questions[currentQuestion];
    Question question = ap.question!;
    if (question.unattempted) {
      return true;
    }

    ap.selectedAnswerId = question.selectedAnswer!.id;
    ap.time = DateTime.now().difference(questionTimer).inSeconds;
    print("time=${ap.time}");
    print(ap.toJson());
    if (question.isCorrect) {
      ap.status = "correct";
    } else if (question.isWrong) {
      ap.status = "wrong";
    }
    autopilot!.avgScore = avgScore;
    autopilot!.avgTime = avgTime;
    autopilot!.totalTime = duration!.inSeconds;
    autopilot!.totalCorrect = correct;
    autopilot!.totalWrong = wrong;
    autopilot!.totalQuestions =
        autopilot!.totalCorrect! + autopilot!.totalWrong!;
    autopilot!.status = AutopilotStatus.IN_PROGRESS.toString();

    await AutopilotDB().update(autopilot!);
    await AutopilotDB().updateProgress(ap);

    return true;
  }

  enableQuestion(bool state) {
    saveQuestion[currentQuestion] = state;
  }

  questionEnabled(int i) {
    if (i > saveQuestion.length - 1) return enabled;
    return saveQuestion[i];
  }

  stopTimer() {}

  createAutopilot() async {
    autopilot = Autopilot(
      title: name,
      type: AutopilotType.FULL.toString(),
      courseId: course.id,
      status: AutopilotStatus.NEW.toString(),
      userId: user.id,
      startTime: DateTime.now(),
      avgScore: 0,
      avgTime: 0,
      totalCorrect: 0,
      totalWrong: 0,
    );

    int autopilotId = await AutopilotDB().insert(autopilot!);
    autopilot!.id = autopilotId;
    List<Question> quesList =
        await QuestionDB().getAutopilotTopicQuestions(course.id!);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      AutopilotProgress ap = AutopilotProgress(
        courseId: course.id,
        autopilotId: autopilotId,
        questionId: quesList[i].id,
        topicId: quesList[i].topicId,
        topicName: quesList[i].topicName,
        userId: user.id,
      );
      ap.question = quesList[i];
      if (ap.question != null) {
        questions.add(ap);
      }
    }

    await AutopilotDB().insertAllProgress(questions);
    questions = await AutopilotDB().getProgresses(autopilotId);
  }

  createTopicAutopilot(int topicId) async {
    autopilot = Autopilot(
      title: name,
      type: AutopilotType.TOPIC.toString(),
      topicId: topicId,
      courseId: course.id,
      status: AutopilotStatus.NEW.toString(),
      userId: user.id,
      startTime: DateTime.now(),
    );

    int autopilotId = await AutopilotDB().insert(autopilot!);
    autopilot!.id = autopilotId;
    List<Question> quesList =
        await QuestionDB().getAutopilotTopicQuestions(topicId);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      AutopilotProgress ap = AutopilotProgress(
        courseId: course.id,
        autopilotId: autopilotId,
        questionId: quesList[i].id,
        topicId: quesList[i].topicId,
        topicName: quesList[i].topicName,
        userId: user.id,
      );
      ap.question = quesList[i];
      if (ap.question != null) {
        questions.add(ap);
      }
    }

    await AutopilotDB().insertAllProgress(questions);
    questions = await AutopilotDB().getProgresses(autopilotId);
  }

  Future<bool> loadAutopilot() async {
    autopilot = await AutopilotDB().getCurrentAutopilot(course);

    if (autopilot != null) {
      print(autopilot!.toJson());
      int? topicId = autopilot!.topicId;
      if (topicId != null) {
        Topic? topic = await TopicDB().getTopicById(topicId);
        if (topic != null) name = topic.name;
      }
      questions = await AutopilotDB().getProgresses(autopilot!.id!);
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

  endAutopilot() async {
    autopilot!.status = AutopilotStatus.COMPLETED.toString();
    autopilot!.endTime = DateTime.now();
    AutopilotDB().update(autopilot!);
  }

  deleteAutopilot() async {
    autopilot = await AutopilotDB().getCurrentAutopilot(course);
    if (autopilot != null) {
      questions = await AutopilotDB().getProgresses(autopilot!.id!);
      await AutopilotDB().delete(autopilot!.id!);
      for (int i = 0; i < questions.length; i++) {
        await AutopilotDB().deleteProgress(questions[i].id!);
      }
      return true;
    }

    return false;
  }

  restartAutopilot() async {
    autopilot = await AutopilotDB().getCurrentAutopilot(course);

    if (autopilot != null) {
      int? topicId = autopilot!.topicId;
      await deleteAutopilot();
      if (topicId == null) {
        await createAutopilot();
      } else {
        await createTopicAutopilot(topicId);
      }
    }
  }
}

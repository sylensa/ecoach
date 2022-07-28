import 'dart:convert';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/database/treadmill_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class TreadmillController {
  TreadmillController(
    this.user,
    this.course, {
    this.name,
    this.type = TestType.NONE,
    this.treadmill,
    this.time = 30,
  }) {
    speedDuration = Duration(seconds: time);
    speedResetDuration = Duration(seconds: time);
    startingDuration = duration;
    timerController = CustomTimerController();
    speedtimerController = TimerController();
    speedTest = type == TestType.SPEED ? true : false;
  }

  final User user;
  final Course course;
  String? name;
  Treadmill? treadmill;
  TestType type;
  bool speedTest = false;
  int time;

  List<TreadmillProgress> questions = [];

  bool enabled = true;
  bool reviewMode = false;
  bool savedTest = false;
  Map<int, bool> saveQuestion = new Map();

  int currentQuestion = 0;
  int finalQuestion = 0;

  DateTime? startTime;
  Duration? duration, resetDuration, startingDuration;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Duration? speedDuration, speedResetDuration, speedStartingDuration;
  int speedEndTime = 0;
  CustomTimerController? timerController;
  TimerController? speedtimerController;
  int countdownInSeconds = 0;
  DateTime questionTimer = DateTime.now();
  String? topicName;
  Topic? topicData;
  dynamic topicid;
  int timeQ = 0;
  int timePerQuestion = 0;
  int countQuestions = 0;
  String? min_1;
  String? min_2;
  String? sec_1;
  String? sec_2;
  String? s1;
  String? s2;
  String? m1;
  String? m2;
  String? minutes;
  String? seconds;
  int? countdown_sec;
  int? countdown_min;
  int countdown = 0;
  int correctAnswer = 0;
  int wrongAnswer = 0;
  double count = 0.0;

  startTest() {
    speedtimerController!.start();
    startTime = DateTime.now();
    speedEndTime = DateTime.now().millisecondsSinceEpoch + 1000 * time;
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
    if (treadmill == null) return 0;
    return treadmill!.avgScore ?? 0;
  }

  double getAvgTime() {
    if (treadmill == null) return 0;
    return treadmill!.avgTime ?? 0;
  }

  int getTotalCorrect() {
    if (treadmill == null) return 0;
    return treadmill!.totalCorrect ?? 0;
  }

  int getTotalWrong() {
    if (treadmill == null) return 0;
    return treadmill!.totalWrong ?? 0;
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
    print('save');
    TestTaken testTaken = TestTaken(
      userId: user.id,
      datetime: startTime,
      totalQuestions: questions.length,
      courseId: course.id,
      testname: name,
      testType: type.toString(),
      testTime: !speedTest
          ? duration == null
              ? -1
              : duration!.inSeconds
          : speedDuration == null
              ? -1
              : speedDuration!.inSeconds,
      usedTime: DateTime.now().difference(startTime!).inSeconds,
      responses: responses,
      score: score,
      correct: correct,
      wrong: wrong,
      unattempted: unattempted,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

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
    TreadmillProgress mp = questions[currentQuestion];
    Question question = mp.question!;
    if (question.unattempted) {
      return true;
    }

    mp.selectedAnswerId = question.selectedAnswer!.id;
    mp.time = DateTime.now().difference(questionTimer).inSeconds;
    print("time=${mp.time}");
    print(mp.toJson());
    if (question.isCorrect) {
      mp.status = "correct";
    } else if (question.isWrong) {
      mp.status = "wrong";
    }
    treadmill!.avgScore = avgScore;
    treadmill!.avgTime = avgTime;
    treadmill!.totalTime = 50; //duration!.inSeconds;
    treadmill!.totalCorrect = correct;
    treadmill!.totalWrong = wrong;
    treadmill!.totalQuestions =
        treadmill!.totalCorrect! + treadmill!.totalWrong!;
    treadmill!.status = TreadmillStatus.IN_PROGRESS.toString();

    await TreadmillDB().update(treadmill!);
    await TreadmillDB().updateProgress(mp);

    if (mp.status == "wrong") {
      TreadmillProgress newMp = TreadmillProgress();
      newMp.userId = mp.userId;
      newMp.courseId = mp.courseId;
      newMp.treadmillId = mp.treadmillId;
      newMp.topicId = mp.topicId;
      newMp.topicName = mp.topicName;
      newMp.questionId = mp.questionId;
      newMp.question = await QuestionDB().getQuestionById(mp.questionId!);

      int? progressId = await TreadmillDB().insertProgress(newMp);
      if (progressId != null) newMp.id = progressId;
      print("++++++++++++++++++");
      questions.add(newMp);
      print(newMp.toJson());
      return false;
    }
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

  createTreadmill() async {
    treadmill = Treadmill(
      title: name,
      type: TreadmillType.MOCK.toString(),
      courseId: course.id,
      status: TreadmillStatus.NEW.toString(),
      userId: user.id,
      startTime: DateTime.now(),
      avgScore: 0,
      avgTime: 0,
      totalCorrect: 0,
      totalWrong: 0,
    );

    int treadmillId = await TreadmillDB().insert(treadmill!);
    treadmill!.id = treadmillId;
    List<Question> quesList =
        await QuestionDB().getTreadmillQuestions(course.id!);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      TreadmillProgress mp = TreadmillProgress(
        courseId: course.id,
        treadmillId: treadmillId,
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

    await TreadmillDB().insertAllProgress(questions);
    questions = await TreadmillDB().getProgresses(treadmillId);
  }

  createTopicTreadmill(int topicId) async {
    treadmill = Treadmill(
      title: name,
      type: TreadmillType.TOPIC.toString(),
      topicId: topicId,
      courseId: course.id,
      status: TreadmillStatus.NEW.toString(),
      userId: user.id,
      startTime: DateTime.now(),
    );

    int treadmillId = await TreadmillDB().insert(treadmill!);
    treadmill!.id = treadmillId;
    List<Question> quesList =
        await QuestionDB().getTreadmillTopicQuestions(topicId);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      TreadmillProgress mp = TreadmillProgress(
        courseId: course.id,
        treadmillId: treadmillId,
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

    await TreadmillDB().insertAllProgress(questions);
    questions = await TreadmillDB().getProgresses(treadmillId);
  }

  createBankTreadmill(int bankId) async {
    treadmill = Treadmill(
      title: name,
      type: TreadmillType.TOPIC.toString(),
      bankId: bankId,
      courseId: course.id,
      status: TreadmillStatus.NEW.toString(),
      userId: user.id,
      startTime: DateTime.now(),
    );

    int treadmillId = await TreadmillDB().insert(treadmill!);
    treadmill!.id = treadmillId;
    List<Question> quesList =
        await QuestionDB().getTreadmillBankQuestions(bankId);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      TreadmillProgress mp = TreadmillProgress(
        courseId: course.id,
        treadmillId: treadmillId,
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

    await TreadmillDB().insertAllProgress(questions);
    questions = await TreadmillDB().getProgresses(treadmillId);
  }

  Future<bool> loadTreadmill() async {
    treadmill = await TreadmillDB().getCurrentTreadmill(course);

    if (treadmill != null) {
      print(treadmill!.toJson());
      int? topicId = treadmill!.topicId;
      if (topicId != null) {
        Topic? topic = await TopicDB().getTopicById(topicId);
        if (topic != null) name = topic.name;
      }
      questions = await TreadmillDB().getProgresses(treadmill!.id!);
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

  endTreadmill() async {
    treadmill!.status = TreadmillStatus.COMPLETED.toString();
    treadmill!.endTime = DateTime.now();
    TreadmillDB().update(treadmill!);
  }

  deleteTreadmill() async {
    treadmill = await TreadmillDB().getCurrentTreadmill(course);
    if (treadmill != null) {
      questions = await TreadmillDB().getProgresses(treadmill!.id!);
      print('deleted ${treadmill!.id!}');
      await TreadmillDB().delete(treadmill!.id!);
      for (int i = 0; i < questions.length; i++) {
        await TreadmillDB().deleteProgress(questions[i].id!);
      }
      return true;
    }

    return false;
  }

  restartTreadmill() async {
    treadmill = await TreadmillDB().getCurrentTreadmill(course);

    if (treadmill != null) {
      int? topicId = treadmill!.topicId;
      await deleteTreadmill();
      if (topicId == null) {
        await createTreadmill();
      } else {
        await createTopicTreadmill(topicId);
      }
    }
  }
}

import 'dart:convert';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/conquest_model.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConquestController {
  ConquestController(
      this.user,
      this.course, {
        this.name,
        this.type = TestType.NONE,
        this.conquestModel,
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
  ConquestModel? conquestModel;
  TestType type;
  bool speedTest = false;
  int time;

  List<Question> questions = [];

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
  int totalTime = 0;
  DateTime questionTimer = DateTime.now();

  startTest() {
    speedtimerController!.start();
    startTime = DateTime.now();
    speedEndTime = DateTime.now().millisecondsSinceEpoch + 1000 * time;
    timerController!.start();
    questionTimer = DateTime.now();
  }

  pauseTimer() {
    timerController!.pause();
    int time = DateTime.now().difference(questionTimer).inSeconds;
    questions[currentQuestion].time = time;
  }

  resumeTimer() {
    timerController!.start();
    questionTimer = DateTime.now();
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
      print("correct___________________________");
      print(question.toJson());
      if (question.isCorrect) score++;
    });
    return score;
  }

  int get wrong {
    int wrong = 0;
    questions.forEach((question) {
      print("wrong___________________________");
      print(question.toJson());
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
    int length = 0;
     totalTime = 0;
    questions.forEach((question) {
      if (question.time != null && question.time! > 0) {
        time += question.time!;
        totalTime += question.time!;
        length++;
      }
    });
    print("Length=$length, time=$time");
    print("totalTime=$totalTime, time=$time");
    if (length == 0) length = 1;
    return time / length;
  }

  int get avgToTalTime {
    int length = 0;
    totalTime = 0;
    questions.forEach((question) {
      if (question.time != null && question.time! > 0) {
        totalTime += question.time!;
        length++;
      }
    });
    print("totalTime=$totalTime");
    if (length == 0) length = 1;
    return totalTime;
  }

  double getAvgScore() {
    int totalQuestions = correct + wrong;

    int correctAnswers = correct;
    if (totalQuestions == 0) {
      return 0;
    }
    return double.parse(((correctAnswers / totalQuestions) * 100).toInt().toString());
  }

  double getAvgTime() {
    if (conquestModel == null) return 0;
    return conquestModel!.avgTime ?? 0;
  }

  int getTotalCorrect() {
    int score = 0;
   questions.forEach((question) {
      if (question.isCorrect) score++;
    });
    return score;
  }

  int getTotalWrong() {
    int wrong = 0;
    questions.forEach((question) {
      if (question.isWrong) wrong++;
    });
    return wrong;
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
        "selected_answer_id": question.selectedAnswer != null ? question.selectedAnswer!.id : null,
        "status": question.isCorrect
            ? "correct"
            : question.isWrong
            ? "wrong"
            : "unattempted" ,
      };
      print("answer:${answer}");
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
        updatedAt: DateTime.now());
    await TestController().saveConquestTestTaken(testTaken);
    await TestController().saveTestTaken(testTaken);
    callback(testTaken, true);
  }

  Future<bool> scoreCurrentQuestion() async {
    print("scoring...");
    // Question mp = questions[currentQuestion];
    Question question = questions[currentQuestion];
    if (question.unattempted) {
      question.confirmed = 0;
      print("questions[currentQuestion]:${question.unattempted}");
      Question? questions = await QuestionDB().getConquestQuestionById(question.id!);
      if(questions == null){
        await QuestionDB().insertConquestQuestion(question);
      }else{
        await QuestionDB().updateConquest(question);
      }
      return true;
    }

    int time = DateTime.now().difference(questionTimer).inSeconds;
    question.time = time;
    print(question.toJson());
    // conquestModel!.avgScore = avgScore;
    // conquestModel!.avgTime = avgTime;
    // conquestModel!.totalTime = duration!.inSeconds;
    // conquestModel!.totalCorrect = correct;
    // conquestModel!.totalWrong = wrong;
    // conquestModel!.totalQuestions = conquestModel!.totalCorrect! + conquestModel!.totalWrong!;


    if (question.isWrong) {
      print("selected answer:${question.selectedAnswer}");
      question.confirmed = 1;
      Question? questions = await QuestionDB().getConquestQuestionById(question.id!);
      if(questions == null){
       await QuestionDB().insertConquestQuestion(question);
      }else{
        await QuestionDB().updateConquest(question);
      }
      return false;
    }

    if (question.isCorrect) {
      question.confirmed = 2;
      Question? questions = await QuestionDB().getConquestQuestionById(question.id!);
      if(questions == null){
        await QuestionDB().insertConquestQuestion(question);
      }else{
        await QuestionDB().updateConquest(question);
      }
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

  endMarathon() async {
    endTime = DateTime.now().second;
  }


}

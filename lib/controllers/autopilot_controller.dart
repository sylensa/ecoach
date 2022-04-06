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
  AutopilotTopic? currentTopic;
  List<TestNameAndCount> topics;
  List<AutopilotTopic> autoTopics = [];
  List<AutopilotQuestion> questions = [];
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

  int get numberOfTopics {
    return topics.length;
  }

  Future<bool> nextTopic() async {
    AutopilotTopic? nextTopic;
    bool currentFound = false;
    autoTopics.forEach((element) {
      if (currentFound == true) {
        nextTopic = element;
        currentFound = false;
      }

      if (element.topicId == autopilot!.topicId) {
        currentFound = true;
      }
    });
    if (nextTopic != null) {
      autopilot!.topicId = nextTopic!.topicId;
      await AutopilotDB().update(autopilot!);

      print("next topic found. topic Id=${autopilot!.topicId}");
      return true;
    } else {
      return false;
    }
  }

  AutopilotTopic? get _currentTopic {
    for (int i = 0; i < autoTopics.length; i++) {
      if (autoTopics[i].topicId == autopilot!.topicId!) {
        return autoTopics[i];
      }
    }

    return autoTopics.length > 0 ? autoTopics[0] : null;
  }

  int get currentTopicNumber {
    for (int i = 0; i < autoTopics.length; i++) {
      if (autoTopics[i].topicId == autopilot!.topicId!) {
        return i + 1;
      }
    }

    return 1;
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
    if (currentTopic == null) return 0;
    return currentTopic!.avgScore ?? 0;
  }

  double getAvgTime() {
    if (currentTopic == null) return 0;
    return currentTopic!.avgTime ?? 0;
  }

  int getTotalCorrect() {
    if (currentTopic == null) return 0;
    return currentTopic!.correct ?? 0;
  }

  Future<int> getTopicTotalCorrect(topicId) async {
    List<AutopilotQuestion> list =
        await AutopilotDB().getTopicProgresses(topicId);
    int count = 0;
    list.forEach((element) {
      if (element.status == 'correct') {
        count = count + 1;
      }
    });
    return count;
  }

  Future<bool> isTopicDone(topicId) async {
    List<AutopilotQuestion> list =
        await AutopilotDB().getTopicProgresses(topicId);
    int count = 0;
    list.forEach((element) {
      if (element.status != null) {
        count = count + 1;
      }
    });
    return count > 0;
  }

  int getTotalWrong() {
    if (currentTopic == null) return 0;
    return currentTopic!.wrong ?? 0;
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
    AutopilotQuestion ap = questions[currentQuestion];
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
    currentTopic!.avgScore = avgScore;
    currentTopic!.avgTime = avgTime;
    currentTopic!.time = duration!.inSeconds;
    currentTopic!.correct = correct;
    currentTopic!.wrong = wrong;
    currentTopic!.totalQuestions =
        currentTopic!.correct! + currentTopic!.wrong!;
    currentTopic!.status = AutopilotStatus.IN_PROGRESS.toString();

    await AutopilotDB().updateTopic(currentTopic!);
    await AutopilotDB().updateProgress(ap);

    if (ap.status == 'wrong') {
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

  createAutopilot() async {
    autopilot = Autopilot(
      title: name ?? course.name,
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

    List<TestNameAndCount> topics = await TestController().getTopics(course);
    print("topics =${topics.length}");

    autopilot!.topicId = topics[0].id;
    int autopilotId = await AutopilotDB().insert(autopilot!);
    autopilot!.id = autopilotId;

    for (int i = 0; i < topics.length; i++) {
      AutopilotTopic ap = AutopilotTopic(
        autopilotId: autopilotId,
        topicId: topics[i].id,
        topicName: topics[i].name,
        correct: 0,
        totalQuestions: topics[i].totalCount,
        startTime: autopilot!.startTime,
      );

      ap.topic = await TopicDB().getTopicById(topics[i].id!);
      if (ap.topic != null) {
        int? id = await AutopilotDB().insertAutopilotTopic(ap);
        ap.id = id;
        autoTopics.add(ap);
      }
    }
    currentTopic = _currentTopic;
    name = currentTopic!.topicName;
  }

  createTopicQuestions(AutopilotTopic topic) async {
    List<Question> quesList =
        await QuestionDB().getAutopilotTopicQuestions(topic.topicId!);
    print("question=${quesList.length}");
    for (int i = 0; i < quesList.length; i++) {
      AutopilotQuestion ap = AutopilotQuestion(
        courseId: course.id,
        autopilotId: topic.autopilotId,
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
    questions = await AutopilotDB().getProgresses(topic.topicId!);
  }

  Future<bool> loadAutopilot() async {
    autopilot = await AutopilotDB().getCurrentAutopilot(course);

    if (autopilot != null) {
      print(autopilot!.toJson());
      autoTopics = await AutopilotDB().getAutoPilotTopics(autopilot!.id!);

      int? topicId = autopilot!.topicId;
      if (topicId != null) {
        Topic? topic = await TopicDB().getTopicById(topicId);
        if (topic != null) name = topic.name;
      } else {
        autopilot!.topicId = autoTopics[0].topicId;
        name = autoTopics[0].topicName;
      }
      currentTopic = _currentTopic;

      questions = await AutopilotDB().getProgresses(autopilot!.topicId!);
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

    endCurrentTopic();
  }

  endCurrentTopic() async {
    currentTopic!.status = AutopilotStatus.COMPLETED.toString();
    currentTopic!.endTime = DateTime.now();
    AutopilotDB().updateTopic(currentTopic!);
    bool next = await nextTopic();
    if (!next) {
      endAutopilot();
    }
  }

  deleteAutopilot() async {
    autopilot = await AutopilotDB().getCurrentAutopilot(course);
    if (autopilot != null) {
      questions = await AutopilotDB().getProgresses(autopilot!.topicId!);
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
        await loadAutopilot();
      }
    }
  }
}

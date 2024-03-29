import 'dart:convert';

import 'package:intl/intl.dart';

class TestTaken {
  TestTaken({
    this.id,
    required this.userId,
    this.datetime,
    this.courseId,
    this.testname,
    this.testType,
    this.challengeType,
    this.topicId,
    this.testId,
    this.testTime,
    this.usedTime,
    this.pauseduration,
    required this.totalQuestions,
    this.score,
    this.correct,
    this.wrong,
    this.unattempted,
    required this.responses,
    this.comment,
    this.userRank,
    this.totalRank,
    this.createdAt,
    this.updatedAt,
    this.groupId,
    this.total_test_taken,
    this.scoreDiff,
  });

  int? id;
  int? userId;
  int? total_test_taken;
  int? groupId;
  DateTime? datetime;
  int? courseId;
  String? courseName;
  String? testname;
  String? testType;
  String? challengeType;
  int? topicId;
  int? testId;
  int? testTime;
  int? usedTime;
  int? pauseduration;
  int totalQuestions;
  double? score;
  int? scoreDiff;
  int? correct;
  int? wrong;
  int? unattempted;
  String responses;
  String? comment;
  int? userRank;
  int? totalRank;
  DateTime? createdAt;
  DateTime? updatedAt;

  get usedTimeText {
    num min = Duration(seconds: usedTime!).inMinutes;
    num sec = (Duration(seconds: usedTime!).inSeconds % 60);
    return "${NumberFormat('00').format(min)}m:${NumberFormat('00').format(sec)}s";
  }

  get jsonResponses {
    return jsonDecode(responses);
  }

  get numberOfQuestions {
    Map respones = jsonResponses;
    return respones.length;
  }

  List<int> getTopicIds() {
    List<int> ids = [];
    Map responses = jsonResponses;
    responses.forEach((key, answer) {
      if (!ids.contains(answer['topic_id'])) ids.add(answer['topic_id']);
    });
    return ids;
  }

  double get performace {
    if (totalQuestions == 0) return 0;
    double performace = correct! / totalQuestions;
    return double.parse(performace.toStringAsFixed(2));
  }

  factory TestTaken.fromJson(Map<String, dynamic> json) => TestTaken(
        id: json["id"],
        userId: json["user_id"],
        groupId: json["group_id"],
        datetime: DateTime.parse(json["date_time"]),
        courseId: json["course_id"],
        topicId: json["topic_id"],
        testname: json["test_name"],
        testType: json["test_type"],
        challengeType: json['challenge_type'],
        testId: json["test_id"],
        testTime: json["test_time"],
        usedTime: json["used_time"],
        pauseduration: json["pause_duration"],
        totalQuestions: json["total_questions"],
        score: json["score"] != null ? double.parse("${json['score']}") : 0,
        correct: json["correct"],
        total_test_taken:
            json["total_test_taken"] == null ? 0 : json["total_test_taken"],
        scoreDiff: json["scoreDiff"] == null ? 0 : json["scoreDiff"],
        wrong: json["wrong"],
        unattempted: json["unattempted"],
        responses: json["responses"],
        comment: json["comment"],
        userRank: json['rank'] != null ? json['rank']['rank'] : null,
        totalRank: json['rank'] != null ? json['rank']['total'] : null,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json['created_at'] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "group_id": groupId,
        "date_time": datetime!.toIso8601String(),
        "course_id": courseId,
        "test_name": testname,
        "test_type": testType,
        "challenge_type": challengeType,
        "topic_id": topicId,
        "test_id": testId,
        "test_time": testTime,
        "used_time": usedTime,
        "pause_duration": pauseduration,
        "total_questions": totalQuestions,
        "score": score,
        "correct": correct,
        "wrong": wrong,
        "unattempted": unattempted,
        "responses": responses,
        "comment": comment,
        "user_rank": userRank,
        "total_rank": totalRank,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
  Map<String, dynamic> toJsonKeyword() => {
        "user_id": userId,
        "group_id": groupId,
        "date_time": datetime!.toIso8601String(),
        "course_id": courseId,
        "test_name": testname,
        "test_type": testType,
        "challenge_type": challengeType,
        "topic_id": topicId,
        "test_id": testId,
        "test_time": testTime,
        "used_time": usedTime,
        "pause_duration": pauseduration,
        "total_questions": totalQuestions,
        "score": score,
        "correct": correct,
        "wrong": wrong,
        "unattempted": unattempted,
        "responses": responses,
        "comment": comment,
        "user_rank": userRank,
        "total_rank": totalRank,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class TestAnswer {
  TestAnswer({
    this.questionId,
    this.topicId,
    this.topicName,
    this.selectedAnswerId,
    this.status,
  });

  int? questionId;
  int? topicId;
  String? topicName;
  int? selectedAnswerId;
  String? status;

  bool get isCorrect {
    return status == "correct";
  }

  bool get isWrong {
    return status == "wrong";
  }

  bool get unattempted {
    return status == "unattempted";
  }

  factory TestAnswer.fromJson(Map<String, dynamic> json) => TestAnswer(
        questionId: json["question_id"],
        topicId: json["topic_id"],
        topicName: json["topic_name"],
        selectedAnswerId: json["selected_answer_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "topic_id": topicId,
        "topic_name": topicName,
        "selected_answer_id": selectedAnswerId,
        "status": status,
      };
}

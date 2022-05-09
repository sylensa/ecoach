import 'dart:convert';

import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';

Autopilot autopilotFromJson(String str) => Autopilot.fromJson(json.decode(str));

String autopilotToJson(Autopilot data) => json.encode(data.toJson());

enum AutopilotStatus { NEW, IN_PROGRESS, PAUSED, COMPLETED }
enum AutopilotType { FULL, TOPIC }

class Autopilot {
  Autopilot({
    this.id,
    this.courseId,
    this.userId,
    this.title,
    this.type,
    this.topicId,
    this.avgScore = 0,
    this.avgTime = 0,
    this.totalCorrect,
    this.totalWrong,
    this.totalQuestions,
    this.totalTime,
    this.startTime,
    this.endTime,
    this.status,
  });

  int? id;
  int? courseId;
  int? userId;
  String? title;
  String? type;
  int? topicId;
  double? avgScore;
  double? avgTime;
  int? totalCorrect;
  int? totalWrong;
  int? totalQuestions;
  int? totalTime;
  DateTime? startTime;
  DateTime? endTime;
  String? status;

  String get date {
    if (endTime == null) return "";

    return '${endTime!.day} ${endTime!.month} ${endTime!.year}';
  }

  String get time {
    if (endTime == null) return "";

    return '${endTime!.hour}:${endTime!.minute}:${endTime!.second}';
  }

  Duration get duration {
    if (startTime == null || endTime == null) return Duration();

    return startTime!.difference(endTime!);
  }

  factory Autopilot.fromJson(Map<String, dynamic> json) => Autopilot(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        title: json["title"],
        type: json["type"],
        topicId: json["topic_id"],
        // avgScore: json["avg_score"],
        // avgTime: json["avg_time"],
        // totalCorrect: json["total_correct"],
        // totalWrong: json["total_wrong"],
        // totalQuestions: json["total_questions"],
        // totalTime: json["total_time"],
        startTime: DateTime.parse(json['start_time']),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "user_id": userId,
        "title": title,
        "type": type,
        "topic_id": topicId,
        // "avg_score": avgScore,
        // "avg_time": avgTime,
        // "total_correct": totalCorrect,
        // "total_wrong": totalWrong,
        // "total_questions": totalQuestions,
        // "total_time": totalTime,
        "start_time": startTime!.toIso8601String(),
        "end_time": endTime == null ? null : endTime!.toIso8601String(),
        "status": status,
      };
}

class AutopilotTopic {
  int? id;
  int? autopilotId;
  int? topicId;
  String? topicName;
  double? avgScore;
  double? avgTime;
  int? correct;
  int? wrong;
  int? totalQuestions;
  int? time;
  DateTime? startTime;
  DateTime? endTime;
  String? status;
  Topic? topic;

  AutopilotTopic({
    this.id,
    this.autopilotId,
    this.topicId,
    this.topicName,
    this.avgScore,
    this.avgTime = 0,
    this.correct,
    this.wrong,
    this.totalQuestions,
    this.time,
    this.startTime,
    this.endTime,
    this.status,
  });

  factory AutopilotTopic.fromJson(Map<String, dynamic> json) => AutopilotTopic(
        id: json["id"],
        autopilotId: json["autopilot_id"],
        topicId: json["topic_id"],
        topicName: json["topic_name"],
        avgScore: json["avg_score"],
        correct: json["correct"],
        avgTime: json["avg_time"],
        wrong: json["wrong"],
        totalQuestions: json["total_questions"],
        time: json["time"],
        startTime: DateTime.parse(json['start_time']),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "autopilot_id": autopilotId,
        "topic_id": topicId,
        "topic_name": topicName,
        "avg_score": avgScore,
        "avg_time": avgTime,
        "correct": correct,
        "wrong": wrong,
        "total_questions": totalQuestions,
        "time": time,
        "start_time": startTime!.toIso8601String(),
        "end_time": endTime == null ? null : endTime!.toIso8601String(),
        "status": status,
      };
}

AutopilotQuestion autopilotProgressFromJson(String str) =>
    AutopilotQuestion.fromJson(json.decode(str));

String autopilotProgressToJson(AutopilotQuestion data) =>
    json.encode(data.toJson());

class AutopilotQuestion {
  AutopilotQuestion({
    this.id,
    this.courseId,
    this.userId,
    this.autopilotId,
    this.questionId,
    this.selectedAnswerId,
    this.topicId,
    this.topicName,
    this.time = 0,
    this.status,
  });

  int? id;
  int? courseId;
  int? userId;
  int? autopilotId;
  int? questionId;
  int? selectedAnswerId;
  int? topicId;
  String? topicName;
  int? time;
  String? status;
  Question? question;

  get isCorrect {
    if (question == null) return false;

    return question!.isCorrect;
  }

  get isWrong {
    if (question == null) return false;

    return question!.isWrong;
  }

  get unattempted {
    if (question == null) return false;

    return question!.unattempted;
  }

  get selectedAnswer {
    if (question == null) return null;

    return question!.selectedAnswer;
  }

  factory AutopilotQuestion.fromJson(Map<String, dynamic> json) =>
      AutopilotQuestion(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        autopilotId: json["autopilot_id"],
        questionId: json["question_id"],
        selectedAnswerId: json["selected_answer_id"],
        topicId: json["topic_id"],
        topicName: json["topic_name"],
        time: json["time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "user_id": userId,
        "autopilot_id": autopilotId,
        "question_id": questionId,
        "selected_answer_id": selectedAnswerId,
        "topic_id": topicId,
        "topic_name": topicName,
        "time": time,
        "status": status,
      };

  AutopilotQuestion clone() {
    return AutopilotQuestion.fromJson(toJson());
  }
}

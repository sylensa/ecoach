import 'dart:convert';

import 'package:ecoach/models/question.dart';

ConquestModel conquestModelFromJson(String str) => ConquestModel.fromJson(json.decode(str));

String conquestModelToJson(ConquestModel data) => json.encode(data.toJson());


class ConquestModel {
  ConquestModel({
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

  factory ConquestModel.fromJson(Map<String, dynamic> json) => ConquestModel(
    id: json["id"],
    courseId: json["course_id"],
    userId: json["user_id"],
    title: json["title"],
    type: json["type"],
    topicId: json["type_id"],
    avgScore: json["avg_score"],
    avgTime: json["avg_time"],
    totalCorrect: json["total_correct"],
    totalWrong: json["total_wrong"],
    totalQuestions: json["total_questions"],
    totalTime: json["total_time"],
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
    "avg_score": avgScore,
    "avg_time": avgTime,
    "total_correct": totalCorrect,
    "total_wrong": totalWrong,
    "total_questions": totalQuestions,
    "total_time": totalTime,
    "start_time": startTime!.toIso8601String(),
    "end_time": endTime == null ? null : endTime!.toIso8601String(),
    "status": status,
  };
}





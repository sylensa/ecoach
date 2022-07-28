import 'dart:convert';
import 'package:ecoach/models/question.dart';

Treadmill treadmillFromJson(String str) => Treadmill.fromJson(json.decode(str));
String treadmillToJson(Treadmill data) => json.encode(data.toJson());

enum TreadmillStatus { NEW, IN_PROGRESS, PAUSED, COMPLETED }

enum TreadmillType { TOPIC, MOCK, BANK }

class Treadmill {
  Treadmill({
    this.id,
    this.courseId,
    this.userId,
    this.title,
    this.type,
    this.topicId,
    this.bankId,
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
  int? bankId;
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

  factory Treadmill.fromJson(Map<String, dynamic> json) => Treadmill(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        title: json["title"],
        type: json["type"],
        topicId: json["type_id"],
        bankId: json["bank_id"],
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
        "bank_id": bankId,
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

TreadmillProgress treadmillProgressFromJson(String str) =>
    TreadmillProgress.fromJson(json.decode(str));

String treadmillProgressToJson(TreadmillProgress data) =>
    json.encode(data.toJson());

class TreadmillProgress {
  TreadmillProgress({
    this.id,
    this.courseId,
    this.userId,
    this.treadmillId,
    this.questionId,
    this.selectedAnswerId,
    this.topicId,
    this.bankId,
    this.topicName,
    this.time = 0,
    this.status,
  });

  int? id;
  int? courseId;
  int? userId;
  int? treadmillId;
  int? questionId;
  int? selectedAnswerId;
  int? topicId;
  int? bankId;
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

  factory TreadmillProgress.fromJson(Map<String, dynamic> json) =>
      TreadmillProgress(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        treadmillId: json["treadmill_id"],
        questionId: json["question_id"],
        selectedAnswerId: json["selected_answer_id"],
        topicId: json["topic_id"],
        topicName: json["topic_name"],
        bankId: json["bank_id"],
        time: json["time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "user_id": userId,
        "treadmill_id": treadmillId,
        "question_id": questionId,
        "selected_answer_id": selectedAnswerId,
        "topic_id": topicId,
        "topic_name": topicName,
        "bank_id": bankId,
        "time": time,
        "status": status,
      };

  TreadmillProgress clone() {
    return TreadmillProgress.fromJson(toJson());
  }
}

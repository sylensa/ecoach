import 'dart:convert';

import 'package:intl/intl.dart';

class ReviewTestTaken {
  ReviewTestTaken({
    this.id,
    this.courseId,
    this.topicId,
    this.testType,
    this.count,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.completed,
    this.category,
  });

  int? id;
  int? userId;
  int? courseId;
  int? count;
  int? completed;
  String? topicId;
  String? category;
  String? testType;
  DateTime? createdAt;
  DateTime? updatedAt;


  factory ReviewTestTaken.fromJson(Map<String, dynamic> json) => ReviewTestTaken(
    id: json["id"],
    userId: json["user_id"],
    courseId: json["course_id"],
    completed: json["completed"],
    count: json["count"],
    category: json["category"],
    topicId: json["topic_id"],
    testType: json["test_type"],
    createdAt: json['created_at'] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json['created_at'] != null ? DateTime.parse(json["updated_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "course_id": courseId,
    "count": count,
    "category": category,
    "completed": completed,
    "test_type": testType,
    "topic_id": topicId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}



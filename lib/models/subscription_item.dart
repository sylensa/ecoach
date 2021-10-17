import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/subscription_item_db.dart';
import 'package:flutter/material.dart';

class SubscriptionItem {
  SubscriptionItem(
      {this.id,
      this.tag,
      this.planId,
      this.name,
      this.description,
      this.value,
      this.resettablePeriod,
      this.resettableInterval,
      this.sortOrder,
      this.createdAt,
      this.updatedAt,
      this.course,
      this.quizzes,
      this.quizCount,
      this.questionCount});

  int? id;
  String? tag;
  int? planId;
  String? name;
  String? description;
  String? value;
  int? resettablePeriod;
  String? resettableInterval;
  int? sortOrder;
  DateTime? createdAt;
  DateTime? updatedAt;
  Course? course;
  List<Quiz>? quizzes;
  int? quizCount;
  int? questionCount;

  get dateOnly {
    return "${createdAt!.day}/${createdAt!.month}/${createdAt!.year}";
  }

  get timeOnly {
    return "${createdAt!.hour}:${createdAt!.minute}";
  }

  get downloadStatus {
    return course != null ? "downloaded" : "not download";
  }

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) =>
      SubscriptionItem(
        id: json["id"],
        tag: json["tag"],
        planId: json["plan_id"],
        name: json["name"],
        description: json["description"],
        value: json["value"],
        resettablePeriod: json["resettable_period"],
        resettableInterval: json["resettable_interval"],
        sortOrder: json["sort_order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        course: json['course'] != null ? Course.fromJson(json['course']) : null,
        quizzes: json["quizzes"] == null
            ? []
            : List<Quiz>.from(json["quizzes"].map((x) => Quiz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "plan_id": planId,
        "name": name,
        "description": description,
        "value": value,
        "resettable_period": resettablePeriod,
        "resettable_interval": resettableInterval,
        "sort_order": sortOrder,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

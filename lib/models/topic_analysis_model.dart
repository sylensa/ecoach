// To parse this JSON data, do
//
//     final TopicAnalysisList = groupTestListFromJson(jsonString);

import 'dart:convert';

import 'package:ecoach/models/topic_analysis.dart';

TopicAnalysisList groupTestListFromJson(String? str) => TopicAnalysisList.fromJson(json.decode(str!));

String? groupTestListToJson(TopicAnalysisList data) => json.encode(data.toJson());

class TopicAnalysisList {
  TopicAnalysisList({
    this.topicId,
    this.name,
    this.totalQuestions,
    this.correctlyAnswered,
    this.testId,
    this.testName,
    this.testScore,
  });

  String? topicId;
  String? name;
  int? totalQuestions;
  double? correctlyAnswered;
  String? testId;
  String? testName;
  double? testScore;

  factory TopicAnalysisList.fromJson(Map<String, dynamic> json) => TopicAnalysisList(
    topicId: json["topic_id"] == null ? null : json["topic_id"],
    name: json["name"] == null ? null : json["name"],
    totalQuestions: json["total_questions"] == null ? null : json["total_questions"],
    correctlyAnswered: json["correctly_answered"] == null ? null : json["correctly_answered"],
    testId: json["test_id"] == null ? null : json["test_id"],
    testName: json["test_name"] == null ? null : json["test_name"],
    testScore: json["test_score"] == null ? null : json["test_score"],
  );

  Map<String, dynamic> toJson() => {
    "topic_id": topicId == null ? null : topicId,
    "name": name == null ? null : name,
    "total_questions": totalQuestions == null ? null : totalQuestions,
    "correctly_answered": correctlyAnswered == null ? null : correctlyAnswered,
    "test_id": testId == null ? null : testId,
    "test_name": testName == null ? null : testName,
    "test_score": testScore == null ? null : testScore,
  };
}

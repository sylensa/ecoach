// To parse this JSON data, do
//
//     final flagQuestion = flagQuestionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FlagQuestion flagQuestionFromJson(String str) => FlagQuestion.fromJson(json.decode(str));

String flagQuestionToJson(FlagQuestion data) => json.encode(data.toJson());

class FlagQuestion {
  FlagQuestion({
    required this.code,
    required this.message,
    required this.data,
  });

  String code;
  String message;
  FlagData data;

  factory FlagQuestion.fromJson(Map<String, dynamic> json) => FlagQuestion(
    code: json["code"],
    message: json["message"],
    data: FlagData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class FlagData {
  FlagData({
    required this.reason,
    required this.type,
     this.questionId,
     this.userId,
     this.updatedAt,
     this.createdAt,
     this.id,
  });

  String reason;
  String type;
  int? questionId;
  int ?userId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory FlagData.fromJson(Map<String, dynamic> json) => FlagData(
    reason: json["reason"],
    type: json["type"] ?? "",
    questionId: json["question_id"] ?? 0,
    userId: json["user_id"] ?? 0,
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
    createdAt: DateTime.parse(json["created_at"]?? DateTime.now().toString()),
    id: json["id"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "reason": reason,
    "type": type ,
    "question_id": questionId ,
  };
}

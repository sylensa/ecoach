import 'package:ecoach/models/question.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/utf_fix.dart';

class Quiz {
  Quiz(
      {this.id,
      this.courseId,
      this.topicId,
      this.testId,
      this.type,
      this.name,
      this.author,
      this.time,
      this.description,
      this.category,
      this.instructions,
      this.startTime,
      this.endTime,
      this.createdAt,
      this.updatedAt,
      this.confirmed,
      this.questions});

  int? key;
  int? id;
  int? courseId;
  int? topicId;
  String? testId;
  String? type;
  String? name;
  String? author;
  int? time;
  String? description;
  String? category;
  String? instructions;
  String? startTime;
  String? endTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? confirmed;
  List<Question>? questions;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json["id"],
        courseId: json["course_id"],
        topicId: json["topic_id"],
        testId: json["testID"],
        type: json["type"],
        name: json["name"],
        author: json["author"],
        time: json["time"],
        description: json["description"],
        category: json["category"],
        instructions: json["instructions"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        confirmed: json["confirmed"],
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "topic_id": topicId,
        "testID": testId,
        "type": type,
        "name": getUtfFixed(name),
        "author": author,
        "time": time,
        "description": getUtfFixed(description),
        "category": category,
        "instructions": instructions,
        "start_time": startTime,
        "end_time": endTime,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "confirmed": confirmed,
      };
}

class TestNameAndCount {
  String name;
  int? id;
  int count;
  int totalCount;
  TestCategory? category;
  double? averageScore;
  bool status;

  TestNameAndCount(this.name, this.count, this.totalCount,
      {this.averageScore, this.id, this.category, this.status = false});

  double get progress {
    return count / totalCount;
  }
}

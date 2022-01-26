import 'package:ecoach/models/course_analysis.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/utils/utf_fix.dart';

import 'level.dart';

class Course {
  Course({
    this.id,
    this.packageCode,
    this.courseId,
    this.name,
    this.description,
    this.category,
    this.author,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.confirmed,
    this.public,
    this.n,
    this.p,
    this.editors,
    this.levels,
    this.questions,
  });

  int? key;
  int? id;
  String? packageCode;
  String? courseId;
  String? name;
  String? description;
  String? category;
  String? author;
  int? time;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? confirmed;
  int? public;
  int? n;
  int? p;
  String? editors;
  List<Level>? levels;
  CourseAnalytic? analytic;
  List<Question>? questions;
  double? averageScore;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        packageCode: json["package_code"],
        courseId: json["courseID"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        author: json["author"],
        time: json["time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        confirmed: json["confirmed"],
        public: json["public"],
        n: json["N"],
        p: json["p"],
        editors: json["editors"],
        levels: json["levels"] == null
            ? []
            : List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_code": packageCode,
        "courseID": courseId,
        "name": getUtfFixed(name),
        "description": getUtfFixed(description),
        "category": category,
        "author": author,
        "time": time,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "confirmed": confirmed,
        "public": public,
        "N": n,
        "p": p,
        "editors": editors,
      };
}

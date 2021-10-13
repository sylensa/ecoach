import 'package:ecoach/utils/utf_fix.dart';

class NotesRead {
  NotesRead({
    this.id,
    this.courseId,
    this.topicId,
    this.name,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? courseId;
  int? topicId;
  String? name;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NotesRead.fromJson(Map<String, dynamic> json) => NotesRead(
        id: json["id"],
        courseId: json["course_id"],
        topicId: json["topic_id"],
        name: json["name"],
        notes: json["notes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "course_id": courseId,
        "topic_id": topicId,
        "notes": notes,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

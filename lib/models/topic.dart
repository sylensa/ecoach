import 'package:ecoach/utils/utf_fix.dart';

class Topic {
  Topic(
      {this.id,
      this.courseId,
      this.topicId,
      this.name,
      this.imageURL,
      this.notes});

  int? key;
  int? id;
  int? courseId;
  String? topicId;
  String? name;
  String? imageURL;
  String? notes;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        courseId: json["course_id"],
        topicId: json["topicID"],
        name: json["name"],
        imageURL: json["image_url"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "course_id": courseId,
        "topicID": topicId,
        "notes": getUtfFixed(notes),
        "image_url": imageURL,
      };
}

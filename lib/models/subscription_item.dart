import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/image.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';

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
      this.topics,
      this.images,
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
  List<Topic>? topics;
  List<ImageFile>? images;
  int? quizCount;
  int? questionCount;

  bool isDownloading = false;

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
        topics: json["topics"] == null
            ? []
            : List<Topic>.from(json["topics"].map((x) => Topic.fromJson(x))),
        images: json["images"] == null
            ? []
            : List<ImageFile>.from(json["images"].map((x) => ImageFile.fromJson(x))),
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

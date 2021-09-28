import 'package:ecoach/models/course.dart';

class SubscriptionItem {
  SubscriptionItem({
    this.id,
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
  });

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

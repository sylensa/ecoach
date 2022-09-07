// To parse this JSON data, do
//
//     final groupRating = groupRatingFromJson(jsonString);

import 'dart:convert';

GroupRating groupRatingFromJson(String? str) => GroupRating.fromJson(json.decode(str!));

String? groupRatingToJson(GroupRating data) => json.encode(data.toJson());

class GroupRating {
  GroupRating({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  bool? status;
  String? code;
  String? message;
  GroupRatingData? data;

  factory GroupRating.fromJson(Map<String, dynamic> json) => GroupRating(
    status: json["status"] == null ? null : json["status"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : GroupRatingData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class GroupRatingData {
  GroupRatingData({
    this.groupId,
    this.memberId,
    this.rating,
    this.review,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? groupId;
  int? memberId;
  String? rating;
  String? review;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory GroupRatingData.fromJson(Map<String, dynamic> json) => GroupRatingData(
    groupId: json["group_id"] == null ? null : json["group_id"],
    memberId: json["member_id"] == null ? null : json["member_id"],
    rating: json["rating"] == null ? null : json["rating"],
    review: json["review"] == null ? null : json["review"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId == null ? null : groupId,
    "member_id": memberId == null ? null : memberId,
    "rating": rating == null ? null : rating,
    "review": review == null ? null : review,
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "id": id == null ? null : id,
  };
}

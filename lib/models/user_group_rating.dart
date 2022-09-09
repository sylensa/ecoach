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
   this.member
  });

  String? groupId;
  int? memberId;
  String? rating;
  String? review;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  Member? member;

  factory GroupRatingData.fromJson(Map<String, dynamic> json) => GroupRatingData(
    groupId: json["group_id"] == null ? null : json["group_id"],
    memberId: json["member_id"] == null ? null : json["member_id"],
    rating: json["rating"] == null ? null : json["rating"],
    review: json["review"] == null ? null : json["review"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
    member: json["member"] == null ? null : Member.fromJson(json["member"]),

  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId == null ? null : groupId,
    "member_id": memberId == null ? null : memberId,
    "rating": rating == null ? null : rating,
    "review": review == null ? null : review,
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "id": id == null ? null : id,
    "member": member == null ? null : member!.toJson(),

  };
}

class Member {
  Member({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.isAgent,
    this.isGroupCreator,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  bool? isAgent;
  bool? isGroupCreator;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    isAgent: json["is_agent"] == null ? null : json["is_agent"],
    isGroupCreator: json["is_group_creator"] == null ? null : json["is_group_creator"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "is_agent": isAgent == null ? null : isAgent,
    "is_group_creator": isGroupCreator == null ? null : isGroupCreator,
  };
}

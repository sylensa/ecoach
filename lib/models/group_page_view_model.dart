// To parse this JSON data, do
//
//     final groupPageViewModel = groupPageViewModelFromJson(jsonString);

import 'dart:convert';

GroupPageViewModel groupPageViewModelFromJson(String? str) => GroupPageViewModel.fromJson(json.decode(str!));

String? groupPageViewModelToJson(GroupPageViewModel data) => json.encode(data.toJson());

class GroupPageViewModel {
  GroupPageViewModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  bool? status;
  String? code;
  String? message;
  GroupViewData? data;

  factory GroupPageViewModel.fromJson(Map<String, dynamic> json) => GroupPageViewModel(
    status: json["status"] == null ? null : json["status"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : GroupViewData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class GroupViewData {
  GroupViewData({
    this.id,
    this.uid,
    this.ownerId,
    this.name,
    this.description,
    this.type,
    this.dateCreated,
    this.status,
    this.editorId,
    this.deletedAt,
    this.discoverability,
    this.admins,
    this.members,
    this.pendingInvites,
  });

  int? id;
  String? uid;
  int? ownerId;
  String? name;
  String? description;
  String? type;
  DateTime? dateCreated;
  String? status;
  dynamic editorId;
  dynamic deletedAt;
  bool? discoverability;
  List<Admin>? admins;
  List<Member>? members;
  List<PendingInvite>? pendingInvites;

  factory GroupViewData.fromJson(Map<String, dynamic> json) => GroupViewData(
    id: json["id"] == null ? null : json["id"],
    uid: json["uid"] == null ? null : json["uid"],
    ownerId: json["owner_id"] == null ? null : json["owner_id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    status: json["status"] == null ? null : json["status"],
    editorId: json["editor_id"],
    deletedAt: json["deleted_at"],
    discoverability: json["discoverability"] == null ? null : json["discoverability"],
    admins: json["admins"] == null ? [] : List<Admin>.from(json["admins"].map((x) => Admin.fromJson(x))),
    members: json["members"] == null ? [] : List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
    pendingInvites: json["pending_invites"] == null ? [] : List<PendingInvite>.from(json["pending_invites"].map((x) => PendingInvite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "uid": uid == null ? null : uid,
    "owner_id": ownerId == null ? null : ownerId,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "type": type == null ? null : type,
    "date_created": dateCreated == null ? null : dateCreated!.toIso8601String(),
    "status": status == null ? null : status,
    "editor_id": editorId,
    "deleted_at": deletedAt,
    "discoverability": discoverability == null ? null : discoverability,
    "admins": admins == null ? null : List<dynamic>.from(admins!.map((x) => x.toJson())),
    "members": members == null ? null : List<dynamic>.from(members!.map((x) => x.toJson())),
    "pending_invites": pendingInvites == null ? null : List<dynamic>.from(pendingInvites!.map((x) => x.toJson())),
  };
}

class Admin {
  Admin({
    this.id,
    this.name,
    this.avatar,
    this.isAgent,
    this.isGroupCreator,
    this.pivot,
  });

  int? id;
  String? name;
  dynamic avatar;
  bool? isAgent;
  bool? isGroupCreator;
  Pivot? pivot;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    avatar: json["avatar"],
    isAgent: json["is_agent"] == null ? null : json["is_agent"],
    isGroupCreator: json["is_group_creator"] == null ? null : json["is_group_creator"],
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "avatar": avatar,
    "is_agent": isAgent == null ? null : isAgent,
    "is_group_creator": isGroupCreator == null ? null : isGroupCreator,
    "pivot": pivot == null ? null : pivot!.toJson(),
  };
}

class Pivot {
  Pivot({
    this.groupId,
    this.memberId,
  });

  int? groupId;
  int? memberId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    groupId: json["group_id"] == null ? null : json["group_id"],
    memberId: json["member_id"] == null ? null : json["member_id"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId == null ? null : groupId,
    "member_id": memberId == null ? null : memberId,
  };
}

class Member {
  Member({
    this.id,
    this.name,
    this.avatar,
    this.testCount,
    this.testGrade,
    this.testPercent,
    this.isAgent,
    this.isGroupCreator,
    this.pivot,
  });

  int? id;
  String? name;
  dynamic avatar;
  int? testCount;
  dynamic testGrade;
  String? testPercent;
  bool? isAgent;
  bool? isGroupCreator;
  Pivot? pivot;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    avatar: json["avatar"],
    testCount: json["test_count"] == null ? null : json["test_count"],
    testGrade: json["test_grade"],
    testPercent: json["test_percent"] == null ? null : json["test_percent"],
    isAgent: json["is_agent"] == null ? null : json["is_agent"],
    isGroupCreator: json["is_group_creator"] == null ? null : json["is_group_creator"],
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "avatar": avatar,
    "test_count": testCount == null ? null : testCount,
    "test_grade": testGrade,
    "test_percent": testPercent == null ? null : testPercent,
    "is_agent": isAgent == null ? null : isAgent,
    "is_group_creator": isGroupCreator == null ? null : isGroupCreator,
    "pivot": pivot == null ? null : pivot!.toJson(),
  };
}

class PendingInvite {
  PendingInvite({
    this.id,
    this.name,
    this.email,
  });

  int? id;
  dynamic name;
  String? email;

  factory PendingInvite.fromJson(Map<String, dynamic> json) => PendingInvite(
    id: json["id"] == null ? null : json["id"],
    name: json["name"],
    email: json["email"] == null ? null : json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name,
    "email": email == null ? null : email,
  };
}

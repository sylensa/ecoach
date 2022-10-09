// To parse this JSON data, do
//
//     final groupNotificationModel = groupNotificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_test_model.dart';

GroupNotificationModel groupNotificationModelFromJson(String? str) => GroupNotificationModel.fromJson(json.decode(str!));

String? groupNotificationModelToJson(GroupNotificationModel data) => json.encode(data.toJson());

class GroupNotificationModel {
  GroupNotificationModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  bool? status;
  String? code;
  String? message;
  GroupNotificationResponse? data;

  factory GroupNotificationModel.fromJson(Map<String, dynamic> json) => GroupNotificationModel(
    status: json["status"] == null ? null : json["status"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : GroupNotificationResponse.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class GroupNotificationResponse {
  GroupNotificationResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<GroupNotificationData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory GroupNotificationResponse.fromJson(Map<String, dynamic> json) => GroupNotificationResponse(
    currentPage: json["current_page"] == null ? null : json["current_page"],
    data: json["data"] == null ? null : List<GroupNotificationData>.from(json["data"].map((x) => GroupNotificationData.fromJson(x))),
    firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
    from: json["from"] == null ? null : json["from"],
    lastPage: json["last_page"] == null ? null : json["last_page"],
    lastPageUrl: json["last_page_url"] == null ? null : json["last_page_url"],
    links: json["links"] == null ? null : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"] == null ? null : json["path"],
    perPage: json["per_page"] == null ? null : json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"] == null ? null : json["to"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage == null ? null : currentPage,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl == null ? null : firstPageUrl,
    "from": from == null ? null : from,
    "last_page": lastPage == null ? null : lastPage,
    "last_page_url": lastPageUrl == null ? null : lastPageUrl,
    "links": links == null ? null : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path == null ? null : path,
    "per_page": perPage == null ? null : perPage,
    "prev_page_url": prevPageUrl,
    "to": to == null ? null : to,
    "total": total == null ? null : total,
  };
}

class GroupNotificationData {
  GroupNotificationData({
    this.id,
    this.message,
    this.notificationtableId,
    this.notificationtableType,
    this.groupId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.notificationtable,
    this.group,
    this.viewed,

  });

  int? id;
  String? message;
  int? notificationtableId;
  String? notificationtableType;
  int? groupId;
  int? userId;
  bool? viewed;
  DateTime? createdAt;
  DateTime? updatedAt;
  Notificationtable? notificationtable;
  GroupListData? group;

  factory GroupNotificationData.fromJson(Map<String, dynamic> json) => GroupNotificationData(
    id: json["id"] == null ? null : json["id"],
    message: json["message"] == null ? null : json["message"],
    notificationtableId: json["notificationtable_id"] == null ? null : json["notificationtable_id"],
    notificationtableType: json["notificationtable_type"] == null ? null : json["notificationtable_type"],
    groupId: json["group_id"] == null ? null : json["group_id"],
    viewed: json["viewed"] == null ? true : json["viewed"],
    userId: json["user_id"] == null ? 0 : json["user_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    notificationtable: json["notificationtable"] == null ? null : Notificationtable.fromJson(json["notificationtable"]),
    group: json["group"] == null ? null : GroupListData.fromJson(json["group"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "message": message == null ? null : message,
    "notificationtable_id": notificationtableId == null ? null : notificationtableId,
    "notificationtable_type": notificationtableType == null ? null : notificationtableType,
    "group_id": groupId == null ? null : groupId,
    "user_id": userId == null ? 0 : userId,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "notificationtable": notificationtable == null ? null : notificationtable!.toJson(),
    "group": group == null ? null : group!.toJson(),

  };
}

class Notificationtable {
  Notificationtable({
    this.id,
    this.userId,
    this.groupId,
    this.title,
    this.description,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.instructions,
    this.configurations,
  });

  int? id;
  int? userId;
  int? groupId;
  String? title;
  String? description;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? instructions;
  ConfigurationsClass? configurations;

  factory Notificationtable.fromJson(Map<String, dynamic> json) => Notificationtable(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    groupId: json["group_id"] == null ? null : json["group_id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    status: json["status"] == null ? null : json["status"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    name: json["name"] == null ? null : json["name"],
    instructions: json["instructions"] == null ? null : json["instructions"],
    configurations: json["configurations"] == null ? null : ConfigurationsClass.fromJson(json["configurations"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "group_id": groupId == null ? null : groupId,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "status": status == null ? null : status,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "name": name == null ? null : name,
    "instructions": instructions == null ? null : instructions,
    "configurations": configurations == null ? null : configurations!.toJson(),
  };
}


class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"] == null ? null : json["label"],
    active: json["active"] == null ? null : json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label == null ? null : label,
    "active": active == null ? null : active,
  };
}

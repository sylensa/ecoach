// To parse this JSON data, do
//
//     final groupTestList = groupTestListFromJson(jsonString);

import 'dart:convert';

GroupTestList groupTestListFromJson(String? str) => GroupTestList.fromJson(json.decode(str!));

String? groupTestListToJson(GroupTestList data) => json.encode(data.toJson());

class GroupTestList {
  GroupTestList({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  bool? status;
  String? code;
  String? message;
  GroupTestListResponse? data;

  factory GroupTestList.fromJson(Map<String, dynamic> json) => GroupTestList(
    status: json["status"] == null ? null : json["status"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : GroupTestListResponse.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class GroupTestListResponse {
  GroupTestListResponse({
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
  List<GroupTestData>? data;
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

  factory GroupTestListResponse.fromJson(Map<String, dynamic> json) => GroupTestListResponse(
    currentPage: json["current_page"] == null ? null : json["current_page"],
    data: json["data"] == null ? null : List<GroupTestData>.from(json["data"].map((x) => GroupTestData.fromJson(x))),
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

class GroupTestData {
  GroupTestData({
    this.id,
    this.name,
    this.instructions,
    this.configurations,
    this.status,
    this.userId,
    this.groupId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? name;
  String? instructions;
  ConfigurationsClass? configurations;
  String? status;
  int? userId;
  int? groupId;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserOwner? user;

  factory GroupTestData.fromJson(Map<String, dynamic> json) => GroupTestData(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    instructions: json["instructions"] == null ? null : json["instructions"],
    configurations:  json["configurations"] == null ? null : ConfigurationsClass.fromJson(json["configurations"]),
    status: json["status"] == null ? null : json["status"],
    userId: json["user_id"] == null ? null : json["user_id"],
    groupId: json["group_id"] == null ? null : json["group_id"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : UserOwner.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "instructions": instructions == null ? null : instructions,
    "configurations":configurations == null ? null : configurations!.toJson(),
    "status": status == null ? null : status,
    "user_id": userId == null ? null : userId,
    "group_id": groupId == null ? null : groupId,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "user": user == null ? null : user!.toJson(),
  };
}

class ConfigurationsClass {
  ConfigurationsClass({
    this.bundle,
    this.course,
    this.timing,
    this.testId,
    this.testType,
    this.countDown,
    this.showReview,
    this.testSource,
    this.dueDateTime,
    this.showPassMark,
    this.startDatetime,
    this.showInstantResult,
    this.type,
  });

  String? bundle;
  String? course;
  String? timing;
  String? testId;
  String? testType;
  int? countDown;
  bool? showReview;
  String? testSource;
  DateTime? dueDateTime;
  bool? showPassMark;
  DateTime? startDatetime;
  bool? showInstantResult;
  String? type;

  factory ConfigurationsClass.fromJson(Map<String, dynamic> json) => ConfigurationsClass(
    bundle: json["bundle"] == null ? null : json["bundle"],
    course: json["course"] == null ? null : json["course"],
    timing: json["timing"] == null ? null : json["timing"],
    testId: json["test_id"] == null ? null : json["test_id"],
    testType: json["test_type"] == null ? null : json["test_type"],
    countDown: json["count_down"] == null ? null : json["count_down"],
    showReview: json["show_review"] == null ? null : json["show_review"],
    testSource: json["test_source"] == null ? null : json["test_source"],
    dueDateTime: json["due_dateTime"] == null ? null :json["due_dateTime"].toString() == "null" ? null :  DateTime.parse(json["due_dateTime"]),
    showPassMark: json["show_pass_mark"] == null ? null : json["show_pass_mark"],
    startDatetime: json["start_datetime"] == null ? null :json["start_datetime"].toString() == "null" ? null :  DateTime.parse(json["start_datetime"]),
    showInstantResult: json["show_instant_result"] == null ? null : json["show_instant_result"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "bundle": bundle == null ? null : bundle,
    "course": course == null ? null : course,
    "timing": timing == null ? null : timing,
    "test_id": testId == null ? null : testId,
    "test_type": testType == null ? null : testType,
    "count_down": countDown == null ? null : countDown,
    "show_review": showReview == null ? null : showReview,
    "test_source": testSource == null ? null : testSource,
    "due_dateTime": dueDateTime == null ? null : dueDateTime!.toIso8601String(),
    "show_pass_mark": showPassMark == null ? null : showPassMark,
    "start_datetime": startDatetime == null ? null : startDatetime!.toIso8601String(),
    "show_instant_result": showInstantResult == null ? null : showInstantResult,
    "type": type == null ? null : type,
  };
}

class UserOwner {
  UserOwner({
    this.id,
    this.name,
    this.role,
    this.isAgent,
    this.isGroupCreator,
  });

  int? id;
  String? name;
  String? role;
  bool? isAgent;
  bool? isGroupCreator;

  factory UserOwner.fromJson(Map<String, dynamic> json) => UserOwner(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    role: json["role"] == null ? null : json["role"],
    isAgent: json["is_agent"] == null ? null : json["is_agent"],
    isGroupCreator: json["is_group_creator"] == null ? null : json["is_group_creator"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "role": role == null ? null : role,
    "is_agent": isAgent == null ? null : isAgent,
    "is_group_creator": isGroupCreator == null ? null : isGroupCreator,
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

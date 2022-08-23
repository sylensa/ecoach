// To parse this JSON data, do
//
//     final groupListModel = groupListModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoach/models/group_grades_model.dart';

GroupListModel groupListModelFromJson(String? str) => GroupListModel.fromJson(json.decode(str!));

String? groupListModelToJson(GroupListModel data) => json.encode(data.toJson());

class GroupListModel {
  GroupListModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  bool? status;
  String? code;
  String? message;
  GroupListResponse? data;

  factory GroupListModel.fromJson(Map<String, dynamic> json) => GroupListModel(
    status: json["status"] == null ? null : json["status"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : GroupListResponse.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class GroupListResponse {
  GroupListResponse({
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
  List<GroupListData>? data;
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

  factory GroupListResponse.fromJson(Map<String, dynamic> json) => GroupListResponse(
    currentPage: json["current_page"] == null ? null : json["current_page"],
    data: json["data"] == null ? null : List<GroupListData>.from(json["data"].map((x) => GroupListData.fromJson(x))),
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

class GroupListData {
  GroupListData({
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
    this.membersCount,
    this.category,
    this.settings,
  });

  int? id;
  String? uid;
  int? ownerId;
  String? name;
  String? description;
  String? type;
  DateTime? dateCreated;
  String? status;
  String? category;
  dynamic editorId;
  dynamic deletedAt;
  bool? discoverability;
  int? membersCount;
  DataSettings? settings;

  factory GroupListData.fromJson(Map<String, dynamic> json) => GroupListData(
    id: json["id"] == null ? null : json["id"],
    uid: json["uid"] == null ? null : json["uid"],
    ownerId: json["owner_id"] == null ? null : json["owner_id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    status: json["status"] == null ? null : json["status"],
    editorId: json["editor_id"],
    deletedAt: json["deleted_at"] ?? "",
    category: json["category"] ?? "",
    discoverability: json["discoverability"] == null ? null : json["discoverability"],
    membersCount: json["members_count"] == null ? 0 : json["members_count"],
    settings: json["settings"] == null ? null : DataSettings.fromJson(json["settings"]),

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
    "category": category,
    "discoverability": discoverability == null ? null : discoverability,
    "members_count": membersCount == null ? null : membersCount,
    "settings": settings == null ? null : settings!.toJson(),

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

class DataSettings {
  DataSettings({
    this.settings,
  });

  SettingsSettings? settings;

  factory DataSettings.fromJson(Map<String, dynamic> json) => DataSettings(
    settings: json["settings"] == null ? null : SettingsSettings.fromJson(json["settings"]),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings == null ? null : settings!.toJson(),
  };
}

class SettingsSettings {
  SettingsSettings({
    this.access,
    this.amount,
    this.grading,
    this.currency,
    this.features,
    this.subscriptions,
    this.countryCode,
  });

  String?access;
  String?amount;
  Grading? grading;
  String? currency;
  String? countryCode;
  Features? features;
  Subscriptions? subscriptions;

  factory SettingsSettings.fromJson(Map<String, dynamic> json) => SettingsSettings(
    access: json["access"] == null ? "" : json["access"],
    amount: json["amount"] == null ? "" : json["amount"],
    grading: json["grading"] == null ? null : Grading.fromJson(json["grading"]),
    currency: json["currency"] == null ? "" : json["currency"],
    countryCode: json["country_code"] == null ? "+233" : json["country_code"],
    features: json["features"] == null ? null : Features.fromJson(json["features"]),
    subscriptions: json["subscriptions"] == null ? null : Subscriptions.fromJson(json["subscriptions"]),
  );

  Map<String, dynamic> toJson() => {
    "access": access == null ? null : access,
    "amount": amount == null ? null : amount,
    "grading": grading == null ? null : grading!.toJson(),
    "currency": currency == null ? null : currency,
    "country_code": countryCode == null ? "" : countryCode,
    "features": features == null ? null : features!.toJson(),
    "subscriptions": subscriptions == null ? null : subscriptions!.toJson(),
  };
}

class Features {
  Features({
    this.speed,
    this.review,
    this.mastery,
    this.passMark,
    this.summaries,
    this.totalScore,
    this.averageScore,
    this.instantResult,
    this.overallOutlook,
    this.improvementRate,
  });

  bool? speed;
  bool? review;
  bool? mastery;
  bool? passMark;
  bool? summaries;
  bool? totalScore;
  bool? averageScore;
  bool? instantResult;
  bool? overallOutlook;
  bool? improvementRate;

  factory Features.fromJson(Map<String, dynamic> json) => Features(
    speed: json["speed"] == null ? null : json["speed"],
    review: json["review"] == null ? null : json["review"],
    mastery: json["mastery"] == null ? null : json["mastery"],
    passMark: json["pass_mark"] == null ? null : json["pass_mark"],
    summaries: json["summaries"] == null ? null : json["summaries"],
    totalScore: json["total_score"] == null ? null : json["total_score"],
    averageScore: json["average_score"] == null ? null : json["average_score"],
    instantResult: json["instant_result"] == null ? null : json["instant_result"],
    overallOutlook: json["overall_outlook"] == null ? null : json["overall_outlook"],
    improvementRate: json["improvement_rate"] == null ? null : json["improvement_rate"],
  );

  Map<String, dynamic> toJson() => {
    "speed": speed == null ? null : speed,
    "review": review == null ? null : review,
    "mastery": mastery == null ? null : mastery,
    "pass_mark": passMark == null ? null : passMark,
    "summaries": summaries == null ? null : summaries,
    "total_score": totalScore == null ? null : totalScore,
    "average_score": averageScore == null ? null : averageScore,
    "instant_result": instantResult == null ? null : instantResult,
    "overall_outlook": overallOutlook == null ? null : overallOutlook,
    "improvement_rate": improvementRate == null ? null : improvementRate,
  };
}

class Grading {
  Grading({
    this.id,
    this.name,
    this.grades,
    this.passMark,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String?name;
  List<Grade>? grades;
  int? passMark;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Grading.fromJson(Map<String, dynamic> json) => Grading(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    grades: json["grades"] == null ? null : List<Grade>.from(json["grades"].map((x) => Grade.fromJson(x))),
    passMark: json["pass_mark"] == null ? null : json["pass_mark"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "grades": grades == null ? null : List<dynamic>.from(grades!.map((x) => x.toJson())),
    "pass_mark": passMark == null ? null : passMark,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}



class Subscriptions {
  Subscriptions({
    this.yearly,
    this.monthly,
  });

  bool? yearly;
  bool? monthly;

  factory Subscriptions.fromJson(Map<String, dynamic> json) => Subscriptions(
    yearly: json["yearly"] == null ? null : json["yearly"],
    monthly: json["monthly"] == null ? null : json["monthly"],
  );

  Map<String, dynamic> toJson() => {
    "yearly": yearly == null ? null : yearly,
    "monthly": monthly == null ? null : monthly,
  };
}

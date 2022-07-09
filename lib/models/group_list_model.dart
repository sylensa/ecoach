// To parse this JSON data, do
//
//     final groupListModel = groupListModelFromJson(jsonString);

import 'dart:convert';

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
  int? membersCount;

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
    discoverability: json["discoverability"] == null ? null : json["discoverability"],
    membersCount: json["members_count"] == null ? 0 : json["members_count"],
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
    "members_count": membersCount == null ? null : membersCount,
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

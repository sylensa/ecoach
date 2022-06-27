// To parse this JSON data, do
//
//     final getAgentCodes = getAgentCodesFromJson(jsonString);

import 'dart:convert';

GetAgentCodes getAgentCodesFromJson(String? str) => GetAgentCodes.fromJson(json.decode(str!));

String? getAgentCodesToJson(GetAgentCodes data) => json.encode(data.toJson());

class GetAgentCodes {
  GetAgentCodes({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  AgentData? data;

  factory GetAgentCodes.fromJson(Map<String, dynamic> json) => GetAgentCodes(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : AgentData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class AgentData {
  AgentData({
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
  List<DataCodes>? data;
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

  factory AgentData.fromJson(Map<String, dynamic> json) => AgentData(
    currentPage: json["current_page"] == null ? null : json["current_page"],
    data: json["data"] == null ? null : List<DataCodes>.from(json["data"].map((x) => DataCodes.fromJson(x))),
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

class DataCodes {
  DataCodes({
    this.id,
    this.agentId,
    this.code,
    this.isDefault,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? agentId;
  String? code;
  int? isDefault;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DataCodes.fromJson(Map<String, dynamic> json) => DataCodes(
    id: json["id"] == null ? null : json["id"],
    agentId: json["agent_id"] == null ? null : json["agent_id"],
    code: json["code"] == null ? null : json["code"],
    isDefault: json["is_default"] == null ? null : json["is_default"] == true ? 1 : 0,
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "agent_id": agentId == null ? null : agentId,
    "code": code == null ? null : code,
    "is_default": isDefault == null ? null : isDefault,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
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

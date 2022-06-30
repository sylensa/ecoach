// To parse this JSON data, do
//
//     final agentTransactions = agentTransactionsFromJson(jsonString);

import 'dart:convert';

AgentTransactions agentTransactionsFromJson(String? str) => AgentTransactions.fromJson(json.decode(str!));

String? agentTransactionsToJson(AgentTransactions data) => json.encode(data.toJson());

class AgentTransactions {
  AgentTransactions({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  AgentTransactionResponse? data;

  factory AgentTransactions.fromJson(Map<String, dynamic> json) => AgentTransactions(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : AgentTransactionResponse.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class AgentTransactionResponse {
  AgentTransactionResponse({
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
  List<TransactionData>? data;
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

  factory AgentTransactionResponse.fromJson(Map<String, dynamic> json) => AgentTransactionResponse(
    currentPage: json["current_page"] == null ? null : json["current_page"],
    data: json["data"] == null ? null : List<TransactionData>.from(json["data"].map((x) => TransactionData.fromJson(x))),
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

class TransactionData {
  TransactionData({
    this.createdAt,
    this.activity,
    this.promoCode,
    this.amount,
  });

  DateTime? createdAt;
  String? activity;
  String? promoCode;
  int? amount;

  factory TransactionData.fromJson(Map<String, dynamic> json) => TransactionData(
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    activity: json["activity"] == null ? null : json["activity"],
    promoCode: json["promo_code"] == null ? null : json["promo_code"],
    amount: json["amount"] == null ? null : json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "activity": activity == null ? null : activity,
    "promo_code": promoCode == null ? null : promoCode,
    "amount": amount == null ? null : amount,
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

// To parse this JSON data, do
//
//     final activePackageModel = activePackageModelFromJson(jsonString);

import 'dart:convert';

ActivePackageModel activePackageModelFromJson(String? str) => ActivePackageModel.fromJson(json.decode(str!));

String? activePackageModelToJson(ActivePackageModel data) => json.encode(data.toJson());

class ActivePackageModel {
  ActivePackageModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  bool? status;
  String? code;
  String? message;
  ActivePackageData? data;

  factory ActivePackageModel.fromJson(Map<String, dynamic> json) => ActivePackageModel(
    status: json["status"] == null ? null : json["status"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : ActivePackageData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class ActivePackageData {
  ActivePackageData({
    this.id,
    this.groupPackageId,
    this.subscriberId,
    this.name,
    this.description,
    this.price,
    this.invoicePeriod,
    this.invoiceInterval,
    this.maxGroups,
    this.maxParticipants,
    this.maxTests,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
    this.validity,
  });

  int? id;
  int? groupPackageId;
  int? subscriberId;
  String? name;
  String? description;
  int? price;
  int? invoicePeriod;
  String? invoiceInterval;
  int? maxGroups;
  int? maxParticipants;
  int? maxTests;
  DateTime? startAt;
  dynamic endAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? validity;

  factory ActivePackageData.fromJson(Map<String, dynamic> json) => ActivePackageData(
    id: json["id"] == null ? null : json["id"],
    groupPackageId: json["group_package_id"] == null ? null : json["group_package_id"],
    subscriberId: json["subscriber_id"] == null ? null : json["subscriber_id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"],
    invoicePeriod: json["invoice_period"] == null ? null : json["invoice_period"],
    invoiceInterval: json["invoice_interval"] == null ? null : json["invoice_interval"],
    maxGroups: json["max_groups"] == null ? null : json["max_groups"],
    maxParticipants: json["max_participants"] == null ? null : json["max_participants"],
    maxTests: json["max_tests"] == null ? null : json["max_tests"],
    startAt: json["start_at"] == null ? null : DateTime.parse(json["start_at"]),
    endAt: json["end_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    validity: json["validity"] == null ? null : json["validity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "group_package_id": groupPackageId == null ? null : groupPackageId,
    "subscriber_id": subscriberId == null ? null : subscriberId,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "price": price == null ? null : price,
    "invoice_period": invoicePeriod == null ? null : invoicePeriod,
    "invoice_interval": invoiceInterval == null ? null : invoiceInterval,
    "max_groups": maxGroups == null ? null : maxGroups,
    "max_participants": maxParticipants == null ? null : maxParticipants,
    "max_tests": maxTests == null ? null : maxTests,
    "start_at": startAt == null ? null : startAt!.toIso8601String(),
    "end_at": endAt,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "validity": validity == null ? null : validity,
  };
}

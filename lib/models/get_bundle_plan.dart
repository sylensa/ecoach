// To parse this JSON data, do
//
//     final getBundleByPlan = getBundleByPlanFromJson(jsonString);

import 'package:ecoach/models/subscription_item.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

GetBundleByPlan getBundleByPlanFromJson(String str) => GetBundleByPlan.fromJson(json.decode(str));

String getBundleByPlanToJson(GetBundleByPlan data) => json.encode(data.toJson());

class GetBundleByPlan {
  GetBundleByPlan({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  BundleByPlanData data;

  factory GetBundleByPlan.fromJson(Map<String, dynamic> json) => GetBundleByPlan(
    status: json["status"],
    message: json["message"],
    data: BundleByPlanData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class BundleByPlanData {
  BundleByPlanData({
    required this.id,
    required this.tag,
    required this.name,
    required this.bundleCode,
    required this.description,
    required this.isActive,
    required this.price,
    required this.signupFee,
    required this.currency,
    required this.trialPeriod,
    required this.trialInterval,
    required this.invoicePeriod,
    required this.invoiceInterval,
    required this.tier,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.editorId,
    required this.userSubscribed,
    required this.features,
  });

  int id;
  String tag;
  String name;
  String bundleCode;
  String description;
  bool isActive;
  int price;
  int signupFee;
  String currency;
  int trialPeriod;
  String trialInterval;
  int invoicePeriod;
  String invoiceInterval;
  int tier;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int editorId;
  bool userSubscribed;
  List<SubscriptionItem> features;

  factory BundleByPlanData.fromJson(Map<String, dynamic> json) => BundleByPlanData(
    id: json["id"],
    tag: json["tag"],
    name: json["name"],
    bundleCode: json["bundle_code"] ?? "",
    description: json["description"],
    isActive: json["is_active"],
    price: json["price"],
    signupFee: json["signup_fee"],
    currency: json["currency"],
    trialPeriod: json["trial_period"],
    trialInterval: json["trial_interval"],
    invoicePeriod: json["invoice_period"],
    invoiceInterval: json["invoice_interval"],
    tier: json["tier"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    editorId: json["editor_id"] ?? 0,
    userSubscribed: json["user_subscribed"],
    features: List<SubscriptionItem>.from(json["features"].map((x) => SubscriptionItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag": tag,
    "name": name,
    "bundle_code": bundleCode,
    "description": description,
    "is_active": isActive,
    "price": price,
    "signup_fee": signupFee,
    "currency": currency,
    "trial_period": trialPeriod,
    "trial_interval": trialInterval,
    "invoice_period": invoicePeriod,
    "invoice_interval": invoiceInterval,
    "tier": tier,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "editor_id": editorId,
    "user_subscribed": userSubscribed,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
  };
}


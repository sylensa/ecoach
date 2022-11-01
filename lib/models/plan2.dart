class PlanFilter {
  PlanFilter({
    this.filters,
    this.bundles,
  });

  final List<String>? filters;
  final List<Plan>? bundles;

  factory PlanFilter.fromJson(Map<String, dynamic> json) => PlanFilter(
        filters: List<String>.from(json["filters"].map((x) => x)),
        bundles: List<Plan>.from(json["bundles"].map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filters": List<dynamic>.from(filters!.map((x) => x)),
        "bundles": List<dynamic>.from(bundles!.map((x) => x.toJson())),
      };
}

class Plan {
  Plan({
    this.id,
    this.tag,
    this.name,
    this.description,
    this.isActive,
    this.price,
    this.signupFee,
    this.currency,
    this.trialPeriod,
    this.trialInterval,
    this.invoicePeriod,
    this.invoiceInterval,
    this.tier,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.editorId,
    this.userSubscribed,
    this.features,
  });

  int? id;
  String? tag;
  String? name;
  String? description;
  bool? isActive;
  double? price;
  double? signupFee;
  String? currency;
  int? trialPeriod;
  String? trialInterval;
  int? invoicePeriod;
  String? invoiceInterval;
  int? tier;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? editorId;
  bool? userSubscribed;
  List<Feature>? features;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        tag: json["tag"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
        price: double.parse("${json["price"]}"),
        signupFee: double.parse("${json["signup_fee"]}"),
        currency: json["currency"],
        trialPeriod: json["trial_period"],
        trialInterval: json["trial_interval"],
        invoicePeriod: json["invoice_period"],
        invoiceInterval: json["invoice_interval"],
        tier: json["tier"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        editorId: json["editor_id"] == null ? null : json["editor_id"],
        userSubscribed: json["user_subscribed"],
        features: json["features"] == null
            ? null
            : List<Feature>.from(
                json["features"].map(
                  (x) => Feature.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "name": name,
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
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "editor_id": editorId == null ? null : editorId,
        "user_subscribed": userSubscribed,
        "features": List<dynamic>.from(features!.map((x) => x.toJson())),
      };
}

class Feature {
  Feature({
    this.id,
    this.tag,
    this.planId,
    this.name,
    this.description,
    this.value,
    this.resettablePeriod,
    this.resettableInterval,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? tag;
  final int? planId;
  final String? name;
  final String? description;
  final String? value;
  final int? resettablePeriod;
  final String? resettableInterval;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        tag: json["tag"],
        planId: json["plan_id"],
        name: json["name"],
        description: json["description"] == null ? null : json["description"],
        value: json["value"],
        resettablePeriod: json["resettable_period"],
        resettableInterval: json["resettable_interval"],
        sortOrder: json["sort_order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "plan_id": planId,
        "name": name,
        "description": description == null ? null : description,
        "value": value,
        "resettable_period": resettablePeriod,
        "resettable_interval": resettableInterval,
        "sort_order": sortOrder,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

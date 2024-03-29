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
    this.subscribed,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? tag;
  String? name;
  String? description;
  bool? isActive;
  bool? subscribed;
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

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        tag: json["tag"],
        name: json["name"],
        subscribed: json["user_subscribed"] == null ? false : json["user_subscribed"] == 1 ? true : json["user_subscribed"] == 0 ? false :  json["user_subscribed"],
        description: json["description"],
        isActive: json["is_active"] == 1 ? true : json["is_active"] == 0 ? false :  json["is_active"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "name": name,
        "description": description,
        "is_active": isActive,
        "price": price,
        "signup_fee": signupFee,
        "user_subscribed": subscribed ?? false,
        "currency": currency,
        "trial_period": trialPeriod,
        "trial_interval": trialInterval,
        "invoice_period": invoicePeriod,
        "invoice_interval": invoiceInterval,
        "tier": tier,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

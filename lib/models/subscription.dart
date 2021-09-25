class Subscription {
  Subscription({
    this.id,
    this.tag,
    this.subscriberType,
    this.subscriberId,
    this.planId,
    this.name,
    this.description,
    this.price,
    this.currency,
    this.invoicePeriod,
    this.invoiceInterval,
    this.tier,
    this.trialEndsAt,
    this.startsAt,
    this.endsAt,
    this.cancelsAt,
    this.canceledAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? tag;
  String? subscriberType;
  int? subscriberId;
  int? planId;
  String? name;
  String? description;
  int? price;
  String? currency;
  int? invoicePeriod;
  String? invoiceInterval;
  int? tier;
  DateTime? trialEndsAt;
  DateTime? startsAt;
  DateTime? endsAt;
  String? cancelsAt;
  String? canceledAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        tag: json["tag"],
        subscriberType: json["subscriber_type"],
        subscriberId: json["subscriber_id"],
        planId: json["plan_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        currency: json["currency"],
        invoicePeriod: json["invoice_period"],
        invoiceInterval: json["invoice_interval"],
        tier: json["tier"],
        trialEndsAt: DateTime.parse(json["trial_ends_at"]),
        startsAt: DateTime.parse(json["starts_at"]),
        endsAt: DateTime.parse(json["ends_at"]),
        cancelsAt: json["cancels_at"],
        canceledAt: json["canceled_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "subscriber_type": subscriberType,
        "subscriber_id": subscriberId,
        "plan_id": planId,
        "name": name,
        "description": description,
        "price": price,
        "currency": currency,
        "invoice_period": invoicePeriod,
        "invoice_interval": invoiceInterval,
        "tier": tier,
        "trial_ends_at": trialEndsAt!.toIso8601String(),
        "starts_at": startsAt!.toIso8601String(),
        "ends_at": endsAt!.toIso8601String(),
        "cancels_at": cancelsAt,
        "canceled_at": canceledAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

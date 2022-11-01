import 'dart:convert';

import 'package:ecoach/models/plan.dart';



StoreSearch storeSearchFromJson(String str) => StoreSearch.fromJson(json.decode(str));

String storeSearchToJson(StoreSearch data) => json.encode(data.toJson());

class StoreSearch {
    StoreSearch({
        this.bundles,
        this.groups,
    });

    final List<Plan>? bundles;
    final List<dynamic>? groups;

    factory StoreSearch.fromJson(Map<String, dynamic> json) => StoreSearch(
        bundles: List<Plan>.from(json["bundles"].map((x) => Plan.fromJson(x))),
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "bundles": List<dynamic>.from(bundles!.map((x) => x.toJson())),
        "groups": List<dynamic>.from(groups!.map((x) => x)),
    };
}

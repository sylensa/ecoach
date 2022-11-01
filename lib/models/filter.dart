import 'dart:convert';

BundleFilter bundleFilterFromJson(String str) =>
    BundleFilter.fromJson(json.decode(str));

String bundleFilterToJson(BundleFilter data) => json.encode(data.toJson());

class BundleFilter {
  BundleFilter({
    this.filters,
  });

  final List<String>? filters;

  factory BundleFilter.fromJson(Map<String, dynamic> json) => BundleFilter(
        filters: List<String>.from(json["filters"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "filters": List<dynamic>.from(filters!.map((x) => x)),
      };
}

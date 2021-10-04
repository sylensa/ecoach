import 'dart:convert';

class ApiResponse<T> {
  ApiResponse({
    this.status,
    this.message,
    this.data,
    this.meta,
  });

  bool? status;
  String? message;
  List<T>? data;
  Meta? meta;

  factory ApiResponse.fromJson(
          String str, Function(Map<String, dynamic>) create) =>
      ApiResponse.fromMap(json.decode(str), create);

  // String toJson() => json.encode(toMap());

  factory ApiResponse.fromMap(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    // bool isList = json['data'] is List;
    List<T> data = [];
    json['data'].forEach((v) {
      data.add(create(v));
    });
    print("checking data");
    print(data);
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      data: data,
      // meta: Meta.fromMap(json["meta"]),
    );
  }
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}

class Meta {
  Meta({
    this.total,
    this.skipped,
    this.perPage,
    this.page,
    this.pageCount,
  });

  int? total;
  int? skipped;
  int? perPage;
  int? page;
  int? pageCount;

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        total: json["total"],
        skipped: json["skipped"],
        perPage: json["perPage"],
        page: json["page"],
        pageCount: json["pageCount"],
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "skipped": skipped,
        "perPage": perPage,
        "page": page,
        "pageCount": pageCount,
      };
}

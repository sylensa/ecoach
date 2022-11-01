// To parse this JSON data, do
//
//     final planResponse = planResponseFromMap(jsonString);

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
  dynamic data;
  // List<T>? data;
  Meta? meta;

  factory ApiResponse.fromJson(
          String str, Function(Map<String, dynamic>) create,
          {bool isList = true}) =>
      ApiResponse.fromMap(json.decode(str), create, isList: isList);

  // String toJson() => json.encode(toMap());

  factory ApiResponse.fromMap(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create,
      {bool isList = true}) {
    dynamic finalData;
    if (isList) {
      List<T> data = [];
      json['data'].forEach((v) {
        data.add(create(v));
      });
      print("checking data");
      print(data);
      finalData = data;
    } else {
      T data;
      data = create(json['data']);
      finalData = data;
    }
    return ApiResponse(
      status: json["status"],
      message: json["message"],
      data: finalData,
      // meta: Meta.fromMap(json["meta"]),
    );
  }

  // Map<String, dynamic> toMap() => {
  //   "status": status,
  //   "message": message,
  //   "data": this.data.toJson(),
  //   "meta": meta.toMap(),
  // };
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

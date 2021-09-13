import 'dart:convert';

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';

NewUserData registerDataFromJson(String str) =>
    NewUserData.fromJson(json.decode(str));

String registerDataToJson(NewUserData data) => json.encode(data.toJson());

class NewUserData {
  NewUserData({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory NewUserData.fromJson(Map<String, dynamic> json) => NewUserData(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.levels,
    this.courses,
  });

  List<Level>? levels;
  List<Course>? courses;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        levels: List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
        courses:
            List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "levels": List<dynamic>.from(levels!.map((x) => x.toJson())),
        "courses": List<dynamic>.from(courses!.map((x) => x.toJson())),
      };
}

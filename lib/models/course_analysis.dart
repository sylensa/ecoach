import 'package:ecoach/models/course.dart';

import 'user.dart';
import 'dart:convert';

CourseAnalytic analysisFromJson(String str) =>
    CourseAnalytic.fromJson(json.decode(str));

String analysisToJson(CourseAnalytic data) => json.encode(data.toJson());

class CourseAnalytic {
  int? id;
  int? userRank, lastUserRank;
  int? totalRank;
  double? coursePoint, lastCoursePoint;
  double? mastery, lastMastery;
  int? usedSpeed, lastSpeed, totalSpeed;
  User? user;
  Course? course;

  CourseAnalytic(
      {this.id,
      this.userRank,
      this.lastUserRank,
      this.totalRank,
      this.coursePoint,
      this.lastCoursePoint,
      this.mastery,
      this.lastMastery,
      this.usedSpeed,
      this.lastSpeed,
      this.totalSpeed,
      this.user,
      this.course});

  factory CourseAnalytic.fromJson(Map<String, dynamic> json) => CourseAnalytic(
        id: json['id'] is String ? int.parse(json['id']) : json['id'],
        userRank: json['rank'] != null ? json['rank']['rank'] : null,
        lastUserRank:
            json['rank'] != null ? json['rank']['last_rank'] ?? null : null,
        totalRank: json['rank'] != null ? json['rank']['total'] : null,
        mastery: json["mastery"].toDouble(),
        lastMastery: json["last_mastery"] != null
            ? json["last_mastery"].toDouble()
            : null,
        coursePoint: json["points"] != null ? json["points"].toDouble() : null,
        lastCoursePoint:
            json["last_points"] != null ? json["last_points"].toDouble() : null,
        usedSpeed: json['speed'] != null ? json['speed']['used'] : null,
        lastSpeed: json['speed'] != null ? json['speed']['last_used'] : null,
        totalSpeed: json['speed'] != null ? json['speed']['total'] : null,
      );

  factory CourseAnalytic.fromDB(Map<String, dynamic> json) => CourseAnalytic(
        id: json['id'] is String ? int.parse(json['id']) : json['id'],
        userRank: json['user_rank'],
        lastUserRank: json['last_rank'],
        totalRank: json['total_rank'],
        mastery: json["mastery"].toDouble(),
        lastMastery: json["last_mastery"] != null
            ? json["last_mastery"].toDouble()
            : null,
        coursePoint: json["point"] != null ? json["point"].toDouble() : null,
        lastCoursePoint:
            json["last_point"] != null ? json["last_point"].toDouble() : null,
        usedSpeed: json['used_speed'],
        lastSpeed: json['last_speed'],
        totalSpeed: json['total_speed'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_rank": userRank,
        "last_rank": lastUserRank,
        "total_rank": totalRank,
        "mastery": mastery,
        "point": coursePoint,
        "last_point": lastCoursePoint,
        "used_speed": usedSpeed,
        "last_speed": lastSpeed,
        "total_speed": totalSpeed
      };
}

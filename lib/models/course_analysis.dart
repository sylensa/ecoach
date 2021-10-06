import 'package:ecoach/models/course.dart';

import 'user.dart';
import 'dart:convert';

CourseAnalytic analysisFromJson(String str) =>
    CourseAnalytic.fromJson(json.decode(str));

String analysisToJson(CourseAnalytic data) => json.encode(data.toJson());

class CourseAnalytic {
  int? userRank, lastUserRank;
  int? totalRank;
  int? coursePoint, lastCoursePoint;
  double? mastery, lastMastery;
  int? usedSpeed, lastSpeed, totalSpeed;
  User? user;
  Course? course;

  CourseAnalytic(
      {this.userRank,
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
        userRank: json['rank'] != null ? json['rank']['rank'] : null,
        lastUserRank: json['rank'] != null ? json['rank']['last_rank'] : null,
        totalRank: json['rank'] != null ? json['rank']['total'] : null,
        mastery: json["mastery"].toDouble(),
        lastMastery: json["last_mastery"] != null
            ? json["last_mastery"].toDouble()
            : null,
        coursePoint: json["points"],
        lastCoursePoint: json["last_points"],
        usedSpeed: json['speed'] != null ? json['speed']['used'] : null,
        lastSpeed: json['speed'] != null ? json['speed']['last_used'] : null,
        totalSpeed: json['speed'] != null ? json['speed']['total'] : null,
      );

  Map<String, dynamic> toJson() => {
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

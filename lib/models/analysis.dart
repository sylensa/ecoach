// To parse this JSON data, do
//
//     final analysis = analysisFromJson(jsonString);

import 'dart:convert';

Analysis analysisFromJson(String str) => Analysis.fromJson(json.decode(str));

String analysisToJson(Analysis data) => json.encode(data.toJson());

class Analysis {
  Analysis(
      {this.userRank,
      this.totalRank,
      this.mastery,
      this.points,
      this.usedSpeed,
      this.totalSpeed});

  int? userRank;
  int? totalRank;
  double? mastery;
  int? points;

  int? usedSpeed;
  int? totalSpeed;

  factory Analysis.fromJson(Map<String, dynamic> json) => Analysis(
        userRank: json['rank'] != null ? json['rank']['rank'] : null,
        totalRank: json['rank'] != null ? json['rank']['total'] : null,
        mastery: json["mastery"].toDouble(),
        points: json["points"],
        usedSpeed: json['speed'] != null ? json['speed']['used'] : null,
        totalSpeed: json['speed'] != null ? json['speed']['total'] : null,
      );

  Map<String, dynamic> toJson() => {
        "user_rank": userRank,
        "total_rank": totalRank,
        "mastery": mastery,
        "points": points,
        "used_speed": usedSpeed,
        "total_speed": totalSpeed
      };
}

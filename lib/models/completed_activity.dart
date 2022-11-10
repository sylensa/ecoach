import 'dart:convert';

import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/treadmill.dart';

enum CompletedActivityType { MARATHON, AUTOPILOT, TREADMILL, LEARN }

CompletedActivityList completedActivityListFromJson(String str) =>
    CompletedActivityList.fromJson(json.decode(str));

class CompletedActivityList {
  CompletedActivityList({
    this.marathons,
    // this.treadmills,
    // this.autopilot,
  });

  List<Marathon>? marathons;
  // Treadmill? treadmills;
  // Autopilot? autopilot;

  factory CompletedActivityList.fromJson(Map<String, dynamic> json) =>
      CompletedActivityList(
        marathons: json["marathons"] == null ? [] : json["marathons"],
        // autopilot: json["autopilot"] == null ? null : json["autopilot"],
        // treadmill: json["treadmill"] == null ? null : json["treadmill"],
      );
}

class CompletedActivity {
  CompletedActivity({
    this.activityType,
    this.activityStartTime,
    this.marathon,
    this.treadmill,
    // this.autopilot,
  });

  String? activityType;
  DateTime? activityStartTime;
  Marathon? marathon;
  Treadmill? treadmill;
  // Autopilot? autopilot;

  factory CompletedActivity.fromJson(Map<String, dynamic> json) =>
      CompletedActivity(
        activityType: json["activityType"] == null
            ? CompletedActivityType.MARATHON.name
            : json["activityType"],
        activityStartTime: json["start_time"] == null
            ? null
            : DateTime.parse(json['start_time']),
        marathon: json["marathon"] == null ? null : json["marathon"],
        // autopilot: json["autopilot"] == null ? null : json["autopilot"],
        // treadmill: json["treadmill"] == null ? null : json["treadmill"],
      );
}

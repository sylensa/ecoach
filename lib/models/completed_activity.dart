import 'dart:convert';

import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';

enum CompletedActivityType { MARATHON, AUTOPILOT, TREADMILL, LEARN }

CompletedActivityList completedActivityListFromJson(String str) =>
    CompletedActivityList.fromJson(json.decode(str));

class CompletedActivityList {
  CompletedActivityList({
    this.marathons,
    this.treadmills,
    // this.autopilot,
  });

  List<Marathon>? marathons;
  List<TestTaken>? treadmills;
  // Autopilot? autopilot;

  factory CompletedActivityList.fromJson(Map<String, dynamic> json) =>
      CompletedActivityList(
        marathons: json["marathons"] == null ? [] : json["marathons"],
        treadmills: json["treadmills"] == null ? [] : json["treadmills"],
        // autopilot: json["autopilot"] == null ? null : json["autopilot"],
      );
}

class CompletedActivity {
  CompletedActivity({
    this.activityType,
    this.courseId,
    this.activityStartTime,
    this.marathon,
    this.topic,
    this.treadmill,
    // this.autopilot,
  });

  String? activityType;
  int? courseId;
  DateTime? activityStartTime;
  Marathon? marathon;
  TestTaken? treadmill;
  Topic? topic;
  // Autopilot? autopilot;

  factory CompletedActivity.fromJson(Map<String, dynamic> json) =>
      CompletedActivity(
        activityType: json["activityType"] == null
            ? CompletedActivityType.MARATHON.name
            : json["activityType"],
        courseId: json["courseId"] == null ? null : json["courseId"],
        activityStartTime: json["start_time"] == null
            ? null
            : DateTime.parse(json['start_time']),
        marathon: json["marathon"] == null ? null : json["marathon"],
        treadmill: json["treadmill"] == null ? null : json["treadmill"],
        topic: json["topic"],
        // autopilot: json["autopilot"] == null ? null : json["autopilot"],
      );

  Map<String, dynamic> toJson(activity) {
    return {
      'activityType': activityType,
      'courseId': courseId,
      'start_time': activityStartTime,
      'marathon': activity,
      'treadmill': treadmill,
      'topic': topic,
    };
  }
}

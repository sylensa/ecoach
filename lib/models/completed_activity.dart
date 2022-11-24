import 'dart:convert';

import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/treadmill.dart';

enum TestActivityType { MARATHON, AUTOPILOT, TREADMILL, LEARN }

TestActivityList completedActivityListFromJson(String str) =>
    TestActivityList.fromJson(json.decode(str));

class TestActivityList {
  TestActivityList({
    this.marathons,
    this.treadmills,
    this.autopilots,
    this.ongoingTreadmills,
  });

  List<Marathon>? marathons;
  List<TestTaken>? treadmills;
  List<Treadmill>? ongoingTreadmills;
  List<Autopilot>? autopilots;

  factory TestActivityList.fromJson(Map<String, dynamic> json) =>
      TestActivityList(
        marathons: json["marathons"] == null ? [] : json["marathons"],
        treadmills: json["treadmills"] == null ? [] : json["treadmills"],
        ongoingTreadmills: json["ongoing_treadmills"] == null
            ? []
            : json["ongoing_treadmills"],
        autopilots: json["autopilots"] == null ? [] : json["autopilots"],
      );
}

class TestActivity {
  TestActivity({
    this.activityType,
    this.courseId,
    this.activityStartTime,
    this.marathon,
    this.topic,
    this.treadmill,
    this.ongoingTreadmill,
    this.autopilot,
  });

  TestActivityType? activityType;
  int? courseId;
  DateTime? activityStartTime;
  Marathon? marathon;
  TestTaken? treadmill;
  Treadmill? ongoingTreadmill;
  Topic? topic;
  Autopilot? autopilot;

  factory TestActivity.fromJson(Map<String, dynamic> json) => TestActivity(
        activityType: json["activityType"] == null
            ? TestActivityType.MARATHON
            : json["activityType"],
        courseId: json["courseId"] == null ? null : json["courseId"],
        activityStartTime: json["start_time"] == null
            ? null
            : DateTime.parse(json['start_time']),
        marathon: json["marathon"] == null ? null : json["marathon"],
        treadmill: json["treadmill"] == null ? null : json["treadmill"],
        ongoingTreadmill: json["ongoing_treadmill"] == null
            ? null
            : json["ongoing_treadmill"],
        topic: json["topic"],
        autopilot: json["autopilot"] == null ? null : json["autopilot"],
      );

  Map<String, dynamic> toJson(activity) {
    return {
      'activityType': activityType,
      'courseId': courseId,
      'start_time': activityStartTime,
      'topic': topic,
      'marathon': activity,
      'treadmill': treadmill,
      'ongoing_treadmill': ongoingTreadmill,
      'autopilot': autopilot,
    };
  }
}

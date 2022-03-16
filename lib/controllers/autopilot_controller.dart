import 'dart:convert';

import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/autopilot_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:ecoach/models/autopilot.dart';

class AutopilotController {
  AutopilotController(
    this.user,
    this.course, {
      this.name,
      this.autopilot,
    }
  ){
    timerController = CustomTimerController();
  }

    final User user;
    final Course course;
    String? name;
    Autopilot? autopilot;
    CustomTimerController? timerController;

    List<AutopilotProgress> questions = [];
  }

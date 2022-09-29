import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/new_ui_ben/providers/welcome_screen_provider.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SpeedController extends StudyController {
  SpeedController(this.user, this.course,
      {this.questions = const [], required this.name, required this.progress})
      : super(user, course, name: name, progress: progress) {
    type = StudyType.SPEED_ENHANCEMENT;
    int seconds = 120;
    WelcomeScreenProvider welcome = Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);
    switch (welcome.currentSpeedStudyProgress!.level!) {
      case 1:
        seconds = 120;
        break;
      case 2:
        seconds = 90;
        break;
      case 3:
        seconds = 60;
        break;
      case 4:
        seconds = 30;
        break;
      case 5:
        seconds = 15;
        break;
      case 6:
        seconds = 10;
        break;
    }
    duration = Duration(seconds: seconds);
    resetDuration = Duration(seconds: seconds);
    startingDuration = duration;

    timerController = TimerController();
  }
  final User user;
  final Course course;
  final StudyProgress progress;
  final String name;
  List<Question> questions;

  startTest() {
    super.startTest();
    timerController!.start();
  }

  pauseTimer() {
    timerController!.pause();
  }

  resetTimer() {
    duration = resetDuration;
  }
}

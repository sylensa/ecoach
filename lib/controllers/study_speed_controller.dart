import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/new_learn_mode/providers/learn_mode_provider.dart';
import 'package:ecoach/new_learn_mode/providers/speed_enhancement_provider.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SpeedController extends StudyController {
  SpeedController(this.user, this.course,
      {this.questions = const [], required this.name, required this.progress})
      : super(user, course, name: name, progress: progress) {
    type = StudyType.SPEED_ENHANCEMENT;
    int seconds = 120;
    LearnModeProvider welcome =
        Provider.of<LearnModeProvider>(Get.context!, listen: false);

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

    Provider.of<SpeedEnhancementProvider>(Get.context!, listen: false)
        .setQuizDuration(duration!);

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
    timerController!.reset();
    duration = resetDuration;
    print(duration!.inSeconds);
    Provider.of<SpeedEnhancementProvider>(Get.context!, listen: false)
        .setQuizDuration(duration!);
  }
}

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../database/study_db.dart';
import '../models/speed_enhancement_progress_model.dart';
import '../new_ui_ben/providers/welcome_screen_provider.dart';

class SpeedStudyProgressController {
  createInitialCourseSpeed(SpeedStudyProgress revision) async {
    print("create revision called");
    SpeedStudyProgress? speedStudyProgress = await StudyDB()
        .getCurrentSpeedProgressLevelByCourse(revision.courseId!);

    if (speedStudyProgress == null) {
      await StudyDB().insertSpeedProgressLevel(revision);
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentSpeedProgress(revision);
      print("created revision: ${speedStudyProgress!.toMap()}");
    } else {
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentSpeedProgress(speedStudyProgress);
      print("saved revision: ${speedStudyProgress.toMap()}");
    }
  }

  updateCCLevel(bool moveUp) async {
    WelcomeScreenProvider welcome =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);

    SpeedStudyProgress? speed = await StudyDB()
        .getCurrentSpeedProgressLevelByCourse(welcome.currentCourse!.id!);

    int nextLevel = moveUp ? speed!.level! + 1 : speed!.level! - 1;
    if (nextLevel < 1) {
      nextLevel = 1;
    }
    if (nextLevel == 6) {
      return 6;
    }
    // update level of current course speed
    speed.level = nextLevel;
    speed.updatedAt = DateTime.now();
    await StudyDB().updateSpeedProgressLevel(speed);

    // update the provider
    welcome.setCurrentSpeedProgress(speed);
  }

  restartCCLevel() async {
    WelcomeScreenProvider welcome =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);

    SpeedStudyProgress speed = SpeedStudyProgress(
      courseId: welcome.currentCourse!.id!,
      topicId: welcome.progress!.topicId,
      studyId: welcome.progress!.studyId,
      level: 1,
      fails: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await StudyDB().insertSpeedProgressLevel(speed);

    // update the provider
    welcome.setCurrentSpeedProgress(speed);
  }

  manageSpeedEnhancementLevels() async {
    WelcomeScreenProvider welcome =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);

    SpeedStudyProgress? speed = await StudyDB()
        .getCurrentSpeedProgressLevelByCourse(welcome.currentCourse!.id!);

    print(speed!.fails);

    if (speed.fails! >= 2) {
      speed.fails = 0;
      if (speed.level! > 1) {
        speed.level = speed.level! - 1;
      } else {
        speed.level = 1;
      }
    } else {
      speed.fails = speed.fails! + 1;
    }

    print(speed.toMap());

    //  update speed
    StudyDB().updateSpeedProgressLevel(speed);

    // update the provider
    welcome.setCurrentSpeedProgress(speed);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../database/study_db.dart';
import '../../models/speed_enhancement_progress_model.dart';
import '../providers/learn_mode_provider.dart';

class SpeedStudyProgressController {
  createInitialCourseSpeed(SpeedStudyProgress revision) async {
    print("create revision called");
    SpeedStudyProgress? speedStudyProgress = await StudyDB()
        .getCurrentSpeedProgressLevelByCourse(revision.courseId!);

    if (speedStudyProgress == null) {
      await StudyDB().insertSpeedProgressLevel(revision);
      Provider.of<LearnModeProvider>(Get.context!, listen: false)
          .setCurrentSpeedProgress(revision);
      print("created revision: ${speedStudyProgress!.toMap()}");
    } else {
      Provider.of<LearnModeProvider>(Get.context!, listen: false)
          .setCurrentSpeedProgress(speedStudyProgress);
      print("saved revision: ${speedStudyProgress.toMap()}");
    }
  }

  updateCCLevel(bool moveUp) async {
    LearnModeProvider welcome =
        Provider.of<LearnModeProvider>(Get.context!, listen: false);

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
    LearnModeProvider welcome =
        Provider.of<LearnModeProvider>(Get.context!, listen: false);

    SpeedStudyProgress speed = SpeedStudyProgress(
      courseId: welcome.currentCourse!.id!,
      topicId: welcome.progress!.topicId,
      studyId: welcome.progress!.studyId,
      level: 1,
      fails: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await StudyDB().insertSpeedProgressLevel(speed);

    // update the provider
    welcome.setCurrentSpeedProgress(speed);

    print("new speed ${speed.toMap()}");
  }

  manageSpeedEnhancementLevels() async {
    LearnModeProvider welcome =
        Provider.of<LearnModeProvider>(Get.context!, listen: false);

    SpeedStudyProgress? speed = await StudyDB()
        .getCurrentSpeedProgressLevelByCourse(welcome.currentCourse!.id!);

    print("speed fails ${speed!.fails}");

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

  showFailedDialog({required Function action, required bool isSuccess}) async {
    LearnModeProvider welcome =
        Provider.of<LearnModeProvider>(Get.context!, listen: false);

    SpeedStudyProgress? speed = await StudyDB()
        .getCurrentSpeedProgressLevelByCourse(welcome.currentCourse!.id!);

    Get.defaultDialog(
      title: isSuccess ? "Congratulations" : "Aww",
      barrierDismissible: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            isSuccess
                ? "assets/images/learn_mode2/happy_face.gif"
                : "assets/images/learn_mode2/sad_face2.gif",
            height: 100,
            width: 100,
          ),
          // Text("Aww"),
          SizedBox(
            height: 10,
          ),
          Text(
            isSuccess
                ? "You made it to next level"
                : "You couldn't make it to the next level ${speed!.fails == 2 && speed.level != 1 ? "\nYou have being demoted to the previous level" : ""}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              action();
            },
            child: Text(
              isSuccess ? "Let's go" : "Let's try again",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  showSuccessDialog(Function action) {
    Get.defaultDialog(
      content: Column(
        children: [
          Image.asset(
            "assets/images/learn_mode2/happy_face.gif",
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text("You made it to the next level"),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              action();
            },
            child: Text("Let's Go"),
          )
        ],
      ),
    );
  }
}

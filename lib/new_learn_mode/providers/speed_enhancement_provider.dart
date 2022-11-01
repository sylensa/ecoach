import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/study.dart';
import 'package:flutter/cupertino.dart';

class SpeedEnhancementProvider with ChangeNotifier {
// create a Course obj to hold current course
  Course? currentCourse;

  // create a var to hold the current level of the student
  // the default value is 1

  int level = 1;

  Duration quizDuration = Duration(seconds: 120);

  // set the currentCourse
  setCurrentCourse(Course course) {
    currentCourse = course;
    print("****************");
    print(currentCourse!.toJson());
    print("****************");
    getCurrentLevel();
    // notifyListeners();
  }

  // get current level of the student
  getCurrentLevel() async {
    /// get the current progress of the study and assign it to the {level} var
    StudyProgress? progress =
        await StudyDB().getCurrentProgress(currentCourse!.id!);

    print("****************");
    print("****************");
    print(currentCourse!.toJson());
    print("****************");
    print("****************");
    print("****************");
    print("****************");
    print(progress!.toJson());
    print("****************");
    print("****************");

    // debugPrint("this is the progress ${progress!.level}");

    if (progress == null) {
      level == 1;
    } else {
      level = progress.level ?? 1;
    }
    notifyListeners();
  }

  setQuizDuration(Duration duration) {
    quizDuration = duration;
    // notifyListeners();
  }
}

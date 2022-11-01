import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/course_completion_study_progress.dart';
import 'package:ecoach/models/speed_enhancement_progress_model.dart';
import 'package:ecoach/models/topic.dart';
import 'package:flutter/foundation.dart';

import '../../models/revision_study_progress.dart';
import '../../models/study.dart';
import '../../models/user.dart';

class LearnModeProvider with ChangeNotifier {
  // set initial value for total topics taken

  int totalRevision = 0;

  int totalCC = 0;

  int totalMastery = 0;

  int totalSpeed = 0;

  // set total number of topics

  int totalTopics = 0;

  // create study progress to monitor studies
  StudyProgress? progress;

  RevisionStudyProgress? currentRevisionStudyProgress;

  CourseCompletionStudyProgress? currentCourseCompletion;

  SpeedStudyProgress? currentSpeedStudyProgress;

  StudyType? currentStudyType;

  Course? currentCourse;

  int currentRevisionProgressLevel = 1;

  User? currentUser;

  StudyController? currentStudyController;

  setCurrentStudyController(StudyController controller) {
    currentStudyController = controller;
    // notifyListeners();
  }

  setCurrentUser(User user) {
    currentUser = user;
    notifyListeners();
  }

  setCurrentRevisionProgressLevel(int level) {
    currentRevisionProgressLevel = level;
    notifyListeners();
  }

  setCurrentRevisionStudyProgress(
      RevisionStudyProgress? revisionStudyProgress) {
    currentRevisionStudyProgress = revisionStudyProgress;
    notifyListeners();
  }

  setCurrentCourseCompletionStudyProgress(
      CourseCompletionStudyProgress? courseCompletionStudyProgress) {
    currentCourseCompletion = courseCompletionStudyProgress;
    notifyListeners();
  }

  setCurrentSpeedProgress(SpeedStudyProgress? speedStudyProgress) {
    currentSpeedStudyProgress = speedStudyProgress;
    notifyListeners();
  }

  setCurrentCourse(Course course) {
    currentCourse = course;
    notifyListeners();
  }

  setCurrentStudyType(StudyType studyType) {
    currentStudyType = studyType;
    notifyListeners();
  }

  /// get all topics in a particular course
  /// Assign the total number of topics to [totalTopics]
  getTotalTopics(Course course) async {
    List<Topic> allTopics = await TopicDB().allCourseTopics(course);
    totalTopics = allTopics.length;
    print("the total number of topics is $totalTopics");
    notifyListeners();
  }

  /// set the current study progress
  /// this function is call when the learn mode is opened
  /// it keeps the state of the currentProgress
  setCurrentProgress(StudyProgress currentProgress) async {
    progress = currentProgress;
    print("this is the new study progress ==> ${progress!.toJson()}");
    setRevisionRemaining();
    setCCRemaining();
    notifyListeners();
  }

  Future<Study?> getStudyAndProgress() async {
    return await StudyDB().getStudyById(progress!.studyId!);
  }

  /// set the current number of revisions remaining
  setRevisionRemaining() async {
    Study? study = await getStudyAndProgress();

    String studyTypeString = study!.type!;

    if (studyTypeString == StudyType.REVISION.toString()) {
      if (progress!.level! <= 1) {
        totalRevision = totalTopics;
      } else {
        totalRevision = (totalTopics - progress!.level!) + 1;
      }
    }

    notifyListeners();
  }

  /// set the current number of revisions remaining
  setCCRemaining() {
    if (progress!.level! <= 1) {
      totalCC = totalTopics;
    } else {
      totalCC = (totalTopics - progress!.level!) + 1;
    }
    notifyListeners();
  }
}

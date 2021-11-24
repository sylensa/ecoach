import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/mastery_course_db.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn_mode.dart';

class MasteryController extends StudyController {
  MasteryController(this.user, this.course,
      {this.questions = const [], required this.name, required this.progress})
      : super(user, course, name: name, progress: progress) {
    type = StudyType.MASTERY_IMPROVEMENT;
  }
  final User user;
  final Course course;
  final StudyProgress progress;
  final String name;
  List<Question> questions;

  startTest() {
    super.startTest();
  }

  Duration getTestDuration() {
    return DateTime.now().difference(startTime!);
  }

  updateMasteryCourse() async {
    print("updating mastery course");
    MasteryCourse? mc =
        await MasteryCourseDB().getCurrentTopic(progress.studyId!);
    if (mc != null) {
      print(mc.topicName);
      mc.passed = true;
      await MasteryCourseDB().update(mc);
    }

    mc = await MasteryCourseDB().getCurrentTopic(progress.studyId!);
    if (mc != null) {
      print(mc.topicName);
      progress.topicId = mc.topicId;
      progress.name = mc.topicName;
      progress.updatedAt = DateTime.now();

      await StudyDB().updateProgress(progress);
    }

    return progress;
  }
}

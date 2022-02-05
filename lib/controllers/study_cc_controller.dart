import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/views/learn_mode.dart';

class CourseCompletionController extends StudyController {
  CourseCompletionController(this.user, this.course,
      {this.questions = const [], required this.name, required this.progress})
      : super(user, course, name: name, progress: progress) {
    type = StudyType.COURSE_COMPLETION;
    duration = Duration(minutes: 10);
    resetDuration = Duration(seconds: 10);
    startingDuration = duration;

    timerController = CustomTimerController();
    
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
}

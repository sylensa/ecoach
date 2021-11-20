import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
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
}

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn_mode.dart';

import 'study_controller.dart';

class RevisionController extends StudyController {
  RevisionController(this.user, this.course,
      {this.questions = const [], required this.name, required this.progress})
      : super(user, course, name: name, progress: progress) {
    type = StudyType.REVISION;
  }

  final User user;
  final Course course;
  List<Question> questions;
  final String name;
  final StudyProgress progress;
}

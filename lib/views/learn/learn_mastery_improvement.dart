import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/study/study_quiz_view.dart';
import 'package:ecoach/widgets/layouts/speed_enhancement_introit.dart';
import 'package:flutter/material.dart';

class LearnMastery extends StatefulWidget {
  const LearnMastery(this.user, this.course, this.progress, {Key? key})
      : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;

  @override
  _LearnMasteryState createState() => _LearnMasteryState();
}

class _LearnMasteryState extends State<LearnMastery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpeedEnhancementIntroit(
        heroText: 'Mastery Improvement',
        subText:
            'Let\'s help you Improve your average score on a subject,\none topic at a time',
        heroImageURL: 'assets/images/learn_module/mastery_improvement.png',
        topActionOnPressed: () {
          Navigator.pop(context);
        },
        mainActionLabel: 'Enter',
        color: kAdeoTaupe,
        mainActionOnPressed: () async {
          List<Question> questions =
              await QuestionDB().getMasteryQuestions(widget.course.id!, 5);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return StudyQuizView(
                controller: MasteryController(widget.user, widget.course,
                    questions: questions,
                    name: widget.progress.name!,
                    progress: widget.progress));
          }));
        },
      ),
    );
  }
}

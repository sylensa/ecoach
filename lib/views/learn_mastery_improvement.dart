import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn_attention_topics.dart';
import 'package:ecoach/widgets/layouts/speed_enhancement_introit.dart';
import 'package:flutter/material.dart';

class LearnMastery extends StatefulWidget {
  const LearnMastery(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

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
        mainActionLabel: 'Enter',
        color: kAdeoTaupe,
        mainActionOnPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LearnAttentionTopics();
          }));
        },
      ),
    );
  }
}

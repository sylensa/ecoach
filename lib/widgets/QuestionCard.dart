import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/widgets/adeo_switch.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    required this.user,
    required this.question,
    required this.questionNumber,
    required this.isSaved,
    required this.isSelected,
    required this.onSaveToggled,
    required this.onSelected,
    required this.diagnostic,

    Key? key,
  }) : super(key: key);

  final User user;
  final Map question;
  final String questionNumber;
  final bool isSaved;
  final bool isSelected;
  final Function onSaveToggled;
  final Function onSelected;
  final bool diagnostic;

  static TextStyle questionStyle(isSelected) {
    return TextStyle(
      fontSize: 12,
      color: isSelected ? Colors.white : Color(0xFF323232),
    );
  }

  getBackgroundColor(isSelected) {
    if (isSelected) {
      switch (question['score']) {
        case ExamScore.CORRECTLY_ANSWERED:
          return Color(0xFF00C664);
        case ExamScore.WRONGLY_ANSWERED:
          return Color(0xFFFF614E);
        case ExamScore.NOT_ATTEMPTED:
          return Color(0xFF323232);
      }
    } else
      return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onSelected();
          },
          child: Container(
            color: getBackgroundColor(isSelected),
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionNumber,
                      style: questionStyle(isSelected),
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: AdeoHtmlTex(user, question['question'], textColor: isSelected ? Colors.white : Color(0xFF323232), fontSize: 12,useLocalImage: !diagnostic),
                        
                    ),
                    SizedBox(width: 13),
                    AdeoSwitch(
                      value: isSaved,
                      activeColor: Color(0xFF00ABE0),
                      onChanged: (status) {
                        onSaveToggled(question['id'], status);
                      },
                    ),
                  ],
                ),
                Container(
                  width: 18,
                  height: 18,
                  child: Image.asset(
                    (question['score']) == ExamScore.CORRECTLY_ANSWERED
                        ? 'assets/icons/courses/answered.png'
                        : (question['score']) == ExamScore.WRONGLY_ANSWERED
                            ? 'assets/icons/courses/unanswered.png'
                            : 'assets/icons/courses/not_attempted.png',
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 6),
      ],
    );
  }
}

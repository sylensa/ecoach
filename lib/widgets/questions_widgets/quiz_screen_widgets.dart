import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';

class Objective extends StatelessWidget {
  const Objective(
    this.user, {
    this.enabled = true,
    required this.id,
    required this.label,
    required this.themeColor,
    this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    Key? key,
  }) : super(key: key);

  final User user;
  final bool enabled;
  final int id;
  final String label;
  final onTap;
  final bool isSelected;
  final bool isCorrect;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() async {
        if (!enabled) return;

        onTap(id);
      }, context),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 35,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF222E3B) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: isSelected
              ? Border.all(
                  color: themeColor,
                  width: 1,
                  style: BorderStyle.solid,
                )
              : Border(),
        ),
        child: AdeoHtmlTex(
          user,
          label,
          fontSize: getTextSize(),
          textColor: getTextColor(),
          removeTags: false,
        ),
      ),
    );
  }

  double getTextSize() {
    if (enabled || (!isSelected && !isCorrect)) {
      return 20;
    }

    return 25;
  }

  Color getTextColor() {
    if (!enabled && isCorrect) {
      return Color(0xFF23B95B);
    } else if (!enabled && !isCorrect && isSelected) {
      return Color(0xFFFF614E);
    }
    if (isSelected) {
      return Colors.white;
    }
    return Color(0xB3FFFFFF);
  }
}

class DetailedInstruction extends StatelessWidget {
  const DetailedInstruction(
    this.user, {
    required this.details,
    Key? key,
  }) : super(key: key);

  final User user;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 11,
        ),
        child: AdeoHtmlTex(
          user,
          details,
          fontSize: 15,
          textColor: Colors.white,
          fontStyle: FontStyle.italic,
        ));
  }
}

class Instruction extends StatelessWidget {
  const Instruction(
    this.user, {
    required this.instruction,
    Key? key,
  }) : super(key: key);

  final User user;
  final String instruction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      color: Color(0xFF66717D),
      child: AdeoHtmlTex(
        user,
        instruction,
        fontSize: 15,
        textColor: Colors.white,
      ),
    );
  }
}

class QuestionWid extends StatelessWidget {
  const QuestionWid(
    this.user, {
    required this.question,
    Key? key,
  }) : super(key: key);

  final User user;
  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 28,
      ),
      color: Color(0xFF222E3B),
      child: AdeoHtmlTex(
        user,
        question,
        fontSize: 18,
        textColor: Colors.white,
      ),
    );
  }
}

class QuizStats extends StatelessWidget {
  const QuizStats({
    required this.changeUp,
    required this.averageScore,
    required this.correctScore,
    required this.speed,
    required this.wrongScrore,
    Key? key,
  }) : super(key: key);

  final bool changeUp;
  final String averageScore;
  final String speed;
  final String correctScore;
  final String wrongScrore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: Color(0xFF2D3E50),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                changeUp
                    ? 'assets/icons/progress_up.png'
                    : 'assets/icons/progress_down.png',
                width: 24,
                height: 19,
              ),
              SizedBox(width: 7),
              Text(
                averageScore,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                child: Image.asset(
                  'assets/icons/courses/speed.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(width: 7),
              Text(
                speed,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                child: Image.asset(
                  'assets/icons/plus.png',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 7),
              Text(
                correctScore,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 2,
                child: Image.asset(
                  'assets/icons/minus.png',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 7),
              Text(
                wrongScrore,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class Objective extends StatelessWidget {
  const Objective({
    required this.id,
    required this.label,
    required this.themeColor,
    this.onTap,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  final int id;
  final String label;
  final onTap;
  final bool isSelected;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() {
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
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSelected ? 25 : 20,
            color: isSelected ? Colors.white : Color(0xB3FFFFFF),
          ),
        ),
      ),
    );
  }
}

class DetailedInstruction extends StatelessWidget {
  const DetailedInstruction({
    required this.details,
    Key? key,
  }) : super(key: key);

  final String details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      child: Text(
        details,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class Instruction extends StatelessWidget {
  const Instruction({
    required this.instruction,
    Key? key,
  }) : super(key: key);

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
      child: Text(
        instruction,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontFamily: 'Hamelin',
        ),
      ),
    );
  }
}

class Question extends StatelessWidget {
  const Question({
    required this.question,
    Key? key,
  }) : super(key: key);

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
      child: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}

class QuizStats extends StatelessWidget {
  const QuizStats({
    required this.averageScore,
    required this.correctScore,
    required this.speed,
    required this.wrongScrore,
    Key? key,
  }) : super(key: key);

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
                'assets/icons/progress_down.png',
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
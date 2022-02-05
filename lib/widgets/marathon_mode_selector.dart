import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class MarathonModeSelector extends StatelessWidget {
  const MarathonModeSelector({
    required this.mode,
    required this.label,
    required this.isSelected,
    this.isUnselected = false,
    this.onTap,
    this.size = Sizes.large,
    Key? key,
  }) : super(key: key);

  final mode;
  final String label;
  final bool isSelected;
  final bool isUnselected;
  final onTap;
  final Sizes size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() {
        onTap(mode);
      }, context),
      child: AnimatedContainer(
        padding: size == Sizes.large
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: kAdeoBlue,
                  width: 2,
                  style: BorderStyle.solid,
                )
              : Border(),
        ),
        duration: Duration(milliseconds: 100),
        child: size == Sizes.large
            ? Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUnselected ? Color(0x80FFFFFF) : Colors.white,
                  fontSize: isSelected ? 56 : 35,
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUnselected ? Color(0x80FFFFFF) : Colors.white,
                  fontSize: isSelected ? 34 : 25,
                ),
              ),
      ),
    );
  }
}

class MarathonTopicSelector extends StatelessWidget {
  const MarathonTopicSelector({
    required this.topicId,
    required this.numberOfQuestions,
    required this.label,
    required this.isSelected,
    this.isUnselected = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final int topicId;
  final int numberOfQuestions;
  final String label;
  final bool isSelected;
  final bool isUnselected;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() {
        onTap(topicId);
      }, context),
      child: AnimatedContainer(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: kAdeoBlue,
                  width: 2,
                  style: BorderStyle.solid,
                )
              : Border(),
        ),
        duration: Duration(milliseconds: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isUnselected ? Color(0x80FFFFFF) : Colors.white,
                fontSize: isSelected ? 34 : 25,
              ),
            ),
            if (isSelected)
              Text(
                numberOfQuestions.toString() + 'Q',
                style: TextStyle(
                  fontSize: 18,
                ),
              )
          ],
        ),
      ),
    );
  }
}

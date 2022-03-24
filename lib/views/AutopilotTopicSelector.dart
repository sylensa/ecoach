import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class AutopilotModeSelector extends StatelessWidget {
  const AutopilotModeSelector({
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
        height: isSelected ? 80 : 45,
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
        child: FittedBox(
          child: size == Sizes.large
              ? Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnselected ? Color(0x80FFFFFF) : Colors.white,
                    fontSize: isSelected ? 60 : 35,
                  ),
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnselected ? Color(0x80FFFFFF) : Colors.white,
                    fontSize: isSelected ? 35 : 25,
                  ),
                ),
        ),
      ),
    );
  }
}

class AutopilotTopicSelector extends StatelessWidget {
  const AutopilotTopicSelector({
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
        height: 80,
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
            Expanded(
              child: FittedBox(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  height: 80,
                  child: Text(
                    label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: isUnselected ? Color(0x80FFFFFF) : Colors.white,
                      fontSize: isSelected ? 34 : 25,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 48),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  numberOfQuestions.toString() + 'Q',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

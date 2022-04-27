import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class SpeedModeSelector extends StatelessWidget {
  SpeedModeSelector({
    required this.mode,
    required this.label,
    required this.isSelected,
    this.isUnselected = false,
    this.onTap,
    this.textcolor,
    this.size = Sizes.large,
    Key? key,
  }) : super(key: key);

  final mode;
  final String label;
  final bool isSelected;
  final bool isUnselected;
  final onTap;
  final Sizes size;
  Color? textcolor = kDefaultBlack;

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
          color: isSelected ? Colors.black12 : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 1,
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
                    color: isSelected ? textcolor : kDefaultBlack,
                    fontSize: isSelected ? 60 : 35,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? textcolor : kDefaultBlack,
                    fontSize: isSelected ? 35 : 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

class SpeedTopicSelector extends StatelessWidget {
  SpeedTopicSelector({
    required this.topicId,
    required this.numberOfQuestions,
    required this.label,
    required this.isSelected,
    this.isUnselected = false,
    this.onTap,
    this.textcolor,
    Key? key,
  }) : super(key: key);

  final int topicId;
  final int numberOfQuestions;
  final String label;
  final bool isSelected;
  final bool isUnselected;
  final onTap;
  Color? textcolor = kDefaultBlack;

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
          color: isSelected ? Colors.black12 : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 1,
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
                      color: isSelected ? textcolor : kDefaultBlack,
                      fontSize: isSelected ? 34 : 25,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
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
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

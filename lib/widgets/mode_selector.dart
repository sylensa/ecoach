import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({
    required this.mode,
    required this.label,
    required this.isSelected,
    this.isUnselected = false,
    this.onTap,
    this.size = Sizes.large,
    this.activeBorderColor = kAdeoLightTeal,
    Key? key,
  }) : super(key: key);

  final mode;
  final String label;
  final bool isSelected;
  final bool isUnselected;
  final onTap;
  final Sizes size;
  final Color activeBorderColor;

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
                  color: activeBorderColor,
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

class SubModeSelector extends StatelessWidget {
  const SubModeSelector({
    required this.id,
    required this.numberOfQuestions,
    required this.label,
    required this.isSelected,
    this.isUnselected = false,
    this.selectedBorderColor,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final int id;
  final int numberOfQuestions;
  final String label;
  final bool isSelected;
  final bool isUnselected;
  final Color? selectedBorderColor;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() {
        onTap(id);
      }, context),
      child: AnimatedContainer(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: selectedBorderColor ?? kAdeoBlue,
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
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  height: 80,
                  child: Text(
                    label.toLowerCase().toTitleCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: isUnselected ? kAdeoWhiteAlpha50 : Colors.white,
                      fontSize: isSelected ? 34 : 25,
                    ),
                  ),
                ),
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 48, right: 16),
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

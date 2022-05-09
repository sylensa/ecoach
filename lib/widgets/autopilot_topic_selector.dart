import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/AutopilotMultiPurposeTopicCard.dart';

import 'package:flutter/material.dart';

class AutopilotTopicSelector extends StatelessWidget {
  const AutopilotTopicSelector({
    required this.showInPercentage,
    required this.topicId,
    required this.numberOfQuestions,
    required this.label,
    this.subTitle = 'here is a subtitle',
    required this.isSelected,
    required this.correctlyAnswered,
    this.iconURL: null,
    this.isUnselected = false,
    this.showProgress = false,
    this.rightWidget,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final int topicId;
  final bool showInPercentage;
  final int numberOfQuestions;
  final String label;
  final String subTitle;
  final bool isSelected;
  final bool isUnselected;
  final bool showProgress;
  final int correctlyAnswered;
  final String? iconURL;
  final Widget? rightWidget;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return AutopilotMultiPurposeTopicCard(
      title: label,
      subTitle: 'here is a subtitle',
      iconURL: 'assets/icons/courses/auto.png',
      isSelected: isSelected,
      showInPercentage: showInPercentage,
      numberOfQuestions: numberOfQuestions,
      rightWidget: showProgress
          ? (showInPercentage
              ? PercentageSnippet(
                  correctlyAnswered: correctlyAnswered,
                  totalQuestions: numberOfQuestions,
                  isSelected: isSelected,
                )
              : FractionSnippet(
                  correctlyAnswered: correctlyAnswered,
                  totalQuestions: numberOfQuestions,
                  isSelected: isSelected))
          : null,
    );
  }
}

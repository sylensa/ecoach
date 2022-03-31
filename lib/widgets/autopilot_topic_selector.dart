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
      rightWidget: showInPercentage
          ? PercentageSnippet(
              correctlyAnswered: correctlyAnswered,
              totalQuestions: numberOfQuestions,
              isSelected: isSelected,
            )
          : FractionSnippet(
              correctlyAnswered: correctlyAnswered,
              totalQuestions: numberOfQuestions,
              isSelected: isSelected),
    );

    /* Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            if (isSelected)
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: Image.asset('assets/icons/courses/auto.png'),
                  iconSize: 36,
                  onPressed: () {},
                ),
              ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text("${label}"),
                subtitle: Text("here is a subtitle"),
              ),
            )
          ],
        ),
      ),
    ); */
  }
}

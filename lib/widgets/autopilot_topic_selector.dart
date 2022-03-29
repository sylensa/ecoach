import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

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
    return Container(
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
    );
  }
}

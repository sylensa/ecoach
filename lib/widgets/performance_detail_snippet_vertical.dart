import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class PerformanceDetailSnippetVertical extends StatelessWidget {
  const PerformanceDetailSnippetVertical({
    required this.label,
    required this.content,
    this.verticalSpacing = 1.0,
  });

  final String label;
  final Widget content;
  final double verticalSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: kTableBodyMainText,
        ),
        SizedBox(height: verticalSpacing),
        content,
      ],
    );
  }
}

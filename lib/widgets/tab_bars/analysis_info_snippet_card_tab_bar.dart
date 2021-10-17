import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../cards/analysis_info_snippet_card.dart';

class AnalysisInfoSnippetCardTabBar extends StatelessWidget {
  const AnalysisInfoSnippetCardTabBar({
    required this.infoList,
    this.subLabels,
    required this.selectedIndex,
    required this.onActiveTabChange,
    this.theme = 'dark',
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  final List<AnalysisInfoSnippet> infoList;
  final List<String>? subLabels;
  final int selectedIndex;
  final Function onActiveTabChange;
  final String theme;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < infoList.length; i++)
          GestureDetector(
            onTap: () {
              onActiveTabChange(i);
            },
            child: Column(
              children: [
                AnalysisInfoSnippetCard(info: infoList[i]),
                if (subLabels!.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: 12),
                      Text(
                        subLabels![i],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.toLowerCase() == 'dark'
                                ? Colors.white
                                : kDefaultBlack),
                      ),
                    ],
                  ),
                if (selectedIndex == i)
                  Column(
                    children: [
                      SizedBox(height: 4),
                      CustomPaint(
                        painter: TraingularActiveIndicator(
                          theme.toLowerCase() == 'dark'
                              ? kAnalysisScreenActiveColor
                              : Colors.white,
                        ),
                        size: Size(28.0, 16.0),
                      )
                    ],
                  ),
              ],
            ),
          )
      ],
    );
  }
}

class TraingularActiveIndicator extends CustomPainter {
  final Color background;

  TraingularActiveIndicator(this.background);

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = background);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

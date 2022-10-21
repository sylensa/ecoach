import 'dart:math';

import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_loading_progress_indicator.dart';
import 'package:ecoach/widgets/dropdowns/adeo_dropdown.dart';
import 'package:ecoach/widgets/section_heading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressChart extends StatefulWidget {
  const ProgressChart({
    required this.subscriptions,
    this.selectedSubscription,
    this.updateState,
    Key? key,
  }) : super(key: key);

  final List<SubscriptionItem> subscriptions;
  final SubscriptionItem? selectedSubscription;
  final dynamic updateState;

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  // Generate some dummy data for the chart
  // This will be used to draw the red line
  final List<FlSpot> dummyData1 = List.generate(20, (index) {
    return FlSpot(
      index.toDouble(),
      index * Random().nextDouble(),
    );
  });

  // This will be used to draw the orange line
  final List<FlSpot> dummyData2 = List.generate(20, (index) {
    return FlSpot(
      index.toDouble(),
      index * Random().nextDouble(),
    );
  });

  // This will be used to draw the blue line
  final List<FlSpot> dummyData3 = List.generate(20, (index) {
    return FlSpot(
      index.toDouble(),
      index * Random().nextDouble(),
    );
  });

  generateLegend({
    required Color color,
    required String label,
    required int position,
  }) {
    return Row(
      children: [
        if (position > 0) SizedBox(width: 40),
        ClipOval(
          child: Container(
            color: color,
            width: 7,
            height: 7,
          ),
        ),
        SizedBox(width: 10),
        Text(
          label.toTitleCase(),
          style: TextStyle(
            color: kDefaultBlack2,
            fontFamily: 'PoppinsMedium',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var sideTitleStyle = TextStyle(
      color: Color(0xFF919FB6),
      fontWeight: FontWeight.w500,
      fontSize: 10,
    );

    List<Color> lineColors = [
      const Color(0xFF00C664),
      const Color(0xFFFA8600),
      const Color(0xFF0184FE),
    ];

    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 48,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SectionHeading('your progress'),
                    SizedBox(width: 48),
                    widget.selectedSubscription == null
                        ? LoadingProgressIndicator(
                            activeColor: kAdeoCoral,
                            backgroundColor: kShadowColor,
                            size: 20,
                            strokeWidth: 3,
                          )
                        : AdeoDropDown(
                            value: widget.selectedSubscription!,
                            items: widget.subscriptions,
                            onChanged: (item) {
                              widget.updateState({
                                'item': item,
                                'selectedTests': <TestTaken>[],
                              });
                            },
                          ),
                  ],
                ),
                // Expanded(child: SizedBox()),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    generateLegend(
                      color: lineColors[0],
                      label: 'exam',
                      position: 0,
                    ),
                    generateLegend(
                      color: lineColors[1],
                      label: 'topics',
                      position: 1,
                    ),
                    generateLegend(
                      color: lineColors[2],
                      label: 'others',
                      position: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: kPageBackgroundGray2,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (val) {
                    return FlLine(
                      strokeWidth: 1,
                      color: Color(0xFFE5EFFE),
                    );
                  },
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  rightTitles: SideTitles(showTitles: false),
                  topTitles: SideTitles(showTitles: false),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (BuildContext context, value) =>
                        sideTitleStyle,
                    margin: 12,
                    interval: 1,
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    // getTitles: (double value) {
                    //   debugPrint(value.toInt().toString());
                    //   return value.toInt().toString();
                    //   // return widget
                    //   //     .testData![(value - 1).toInt()].testname!;
                    // },
                    getTextStyles: (BuildContext context, value) =>
                        sideTitleStyle,
                    margin: 24,
                    interval: 1,
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    colors: [lineColors[0]],
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    aboveBarData: BarAreaData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: dummyData1,
                  ),
                  LineChartBarData(
                    isCurved: true,
                    colors: [lineColors[1]],
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: dummyData2,
                  ),
                  LineChartBarData(
                    isCurved: true,
                    colors: [lineColors[2]],
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: dummyData3,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

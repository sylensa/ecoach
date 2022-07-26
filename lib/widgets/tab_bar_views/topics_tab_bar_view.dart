// import 'package:ecoach/models/ui/analysis_info_snippet.dart';
// import 'package:ecoach/models/ui/pill.dart';
// import 'package:ecoach/utils/constants.dart';
// import 'package:ecoach/utils/style_sheet.dart';
// import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
// import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
// import 'package:ecoach/widgets/dropdowns/bordered_dropdown_button.dart';
// import 'package:ecoach/widgets/performance_detail_snippet_vertical.dart';
// import 'package:ecoach/widgets/speed_arc.dart';
// import 'package:ecoach/widgets/superscripted_denominator_fraction_horizontal.dart';
// import 'package:ecoach/widgets/tappable_pill.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:signal_strength_indicator/signal_strength_indicator.dart';
//
// import '../tab_bars/analysis_info_snippet_card_tab_bar.dart';
//
// class TopicsTabBarView extends StatefulWidget {
//   @override
//   _TopicsTabBarViewState createState() => _TopicsTabBarViewState();
// }
//
// class _TopicsTabBarViewState extends State<TopicsTabBarView> {
//   List<AnalysisInfoSnippet> infoList = [];
//   int selectedTabIndex = 0;
//   String dropdownValue = 'all';
//   int selectedTableRowIndex = 0;
//   int selectedChartPillIndex = 0;
//
//   handleTableSelectChanged(index) {
//     setState(() {
//       selectedTableRowIndex = index;
//     });
//   }
//
//   handleSelectChanged(index) {
//     setState(() {
//       selectedTabIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     infoList = [
//       AnalysisInfoSnippet(
//         bodyText: '19th',
//         footerText: '209.5',
//         performance: '3',
//         performanceImproved: true,
//         background: kAnalysisInfoSnippetBackground1,
//       ),
//       AnalysisInfoSnippet(
//         bodyText: '20th',
//         footerText: '209.5',
//         performance: '3',
//         performanceImproved: false,
//         background: kAnalysisInfoSnippetBackground2,
//       ),
//       AnalysisInfoSnippet(
//         bodyText: '26th',
//         footerText: '209.5',
//         performance: '3',
//         performanceImproved: false,
//         background: kAnalysisInfoSnippetBackground3,
//       ),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 12.0),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: AnalysisInfoSnippetCardTabBar(
//                 infoList: infoList,
//                 subLabels: ['Photosynthesis', 'Osmosis', 'Compounds'],
//                 selectedIndex: selectedTabIndex,
//                 onActiveTabChange: handleSelectChanged,
//               ),
//             ),
//             Container(
//               color: kAnalysisScreenActiveColor,
//               padding: EdgeInsets.only(
//                 left: 20.0,
//                 right: 20.0,
//                 top: 20.0,
//                 bottom: 32.0,
//               ),
//               child: Column(
//                 children: [
//                   // BorderedDropdownButton(
//                   //   value: dropdownValue,
//                   //   isExpanded: false,
//                   //   size: Sizes.medium,
//                   //   items: ['all', 'value 2', 'value 3', 'value 4'],
//                   //   onChanged: (String? value) {
//                   //     setState(() {
//                   //       dropdownValue = value ?? '';
//                   //     });
//                   //   },
//                   // ),
//                   // SizedBox(height: 28),
//                   Container(
//                     width: double.infinity,
//                     child: Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           PerformanceDetailSnippetVertical(
//                             label: 'Rank',
//                             content: SuperScriptedDenominatorFractionHorizontal(
//                               numerator: 18,
//                               denomenator: 305,
//                               numeratorColor: Color(0x44FFFFFF),
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           PerformanceDetailSnippetVertical(
//                             label: 'Point',
//                             content: SuperScriptedDenominatorFractionHorizontal(
//                               numerator: 205,
//                               denomenator: 505,
//                               numeratorColor: Color(0x44FFFFFF),
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           PerformanceDetailSnippetVertical(
//                             label: 'Strength',
//                             content: Column(
//                               children: [
//                                 SignalStrengthIndicator.bars(
//                                   value: 0.8,
//                                   size: 44,
//                                   barCount: 5,
//                                   radius: Radius.circular(4.0),
//                                   levels: <num, Color>{
//                                     0.25: Colors.red,
//                                     0.50: Colors.yellow,
//                                     0.75: Colors.green,
//                                   },
//                                   inactiveColor: Colors.black26,
//                                   activeColor: Colors.white,
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   '+2.5% gained',
//                                   style: TextStyle(
//                                     color: Color(0x88FFFFFF),
//                                     fontSize: 12.0,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     width: double.infinity,
//                     child: Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           PerformanceDetailSnippetVertical(
//                             label: 'Exposure',
//                             verticalSpacing: 12.0,
//                             content: CircularProgressIndicatorWrapper(
//                               progress: 100,
//                               progressPostFix: 'X',
//                               useProgressAsMainCenterText: false,
//                               mainCenterText: '2',
//                               mainCenterTextSize: ProgressIndicatorSize.large,
//                               size: ProgressIndicatorSize.large,
//                               progressColor: kProgressColors[3],
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           PerformanceDetailSnippetVertical(
//                             label: 'Mastery',
//                             verticalSpacing: 12.0,
//                             content: CircularProgressIndicatorWrapper(
//                               progress: 85,
//                               size: ProgressIndicatorSize.large,
//                               progressColor: kProgressColors[4],
//                               subCenterText: 'avg. score',
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           PerformanceDetailSnippetVertical(
//                             label: 'Speed',
//                             verticalSpacing: 12.0,
//                             content: SpeedArc(speed: 2.5),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Divider(
//               height: 1.0,
//             ),
//             Container(
//               color: kAnalysisScreenActiveColor,
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 24.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedChartPillIndex = 2;
//                           });
//                         },
//                         child: TappablePill(
//                           pill: Pill(
//                             label: 'Day',
//                             activeBackgroundColor: Colors.white10,
//                             activeLabelColor: Colors.white,
//                             inActiveBackgroundColor: Colors.transparent,
//                             borderColor: Colors.transparent,
//                             borderWidth: 0,
//                             height: 40.0,
//                           ),
//                           isSelected: selectedChartPillIndex == 0,
//                         ),
//                       ),
//                       SizedBox(width: 8.0),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedChartPillIndex = 0;
//                           });
//                         },
//                         child: TappablePill(
//                           pill: Pill(
//                             label: 'Month',
//                             activeBackgroundColor: Colors.white10,
//                             activeLabelColor: Colors.white,
//                             inActiveBackgroundColor: Colors.transparent,
//                             borderColor: Colors.transparent,
//                             borderWidth: 0,
//                             height: 40.0,
//                           ),
//                           isSelected: selectedChartPillIndex == 1,
//                         ),
//                       ),
//                       SizedBox(width: 8.0),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedChartPillIndex = 1;
//                           });
//                         },
//                         child: TappablePill(
//                           pill: Pill(
//                             label: 'Year',
//                             activeBackgroundColor: Colors.white10,
//                             activeLabelColor: Colors.white,
//                             inActiveBackgroundColor: Colors.transparent,
//                             borderColor: Colors.transparent,
//                             borderWidth: 0,
//                             height: 40.0,
//                           ),
//                           isSelected: selectedChartPillIndex == 2,
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   AspectRatio(
//                     aspectRatio: 1.70,
//                     child: Container(
//                       child: LineChart(mainData()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.only(
//                 top: 4.0,
//                 bottom: 24.0,
//               ),
//               child: Center(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     headingTextStyle: kSixteenPointWhiteText,
//                     dataTextStyle: kTableBodyMainText,
//                     dataRowHeight: 64.0,
//                     dividerThickness: 0,
//                     showCheckboxColumn: false,
//                     columns: [
//                       DataColumn(label: Text('Date')),
//                       DataColumn(label: Text('Time')),
//                       DataColumn(label: Text('Performance')),
//                     ],
//                     rows: [
//                       makeDataRow(
//                         cell1Text1: '16:04',
//                         cell1Text2: '01/07.22',
//                         cell2Text: '5.2s',
//                         progressColor: kCourseColors[0]['progress']!,
//                         progress: 0.4,
//                         selected: selectedTableRowIndex == 0,
//                         onSelectChanged: (selected) {
//                           handleTableSelectChanged(0);
//                         },
//                       ),
//                       makeDataRow(
//                         cell1Text1: '16:04',
//                         cell1Text2: '01/07.22',
//                         cell2Text: '5.2s',
//                         progressColor: kCourseColors[4]['background']!,
//                         progress: 1.0,
//                         selected: selectedTableRowIndex == 1,
//                         onSelectChanged: (selected) {
//                           handleTableSelectChanged(1);
//                         },
//                       ),
//                       makeDataRow(
//                         cell1Text1: '16:04',
//                         cell1Text2: '01/07.22',
//                         cell2Text: '5.2s',
//                         progressColor: kCourseColors[2]['background']!,
//                         progress: 0.8,
//                         selected: selectedTableRowIndex == 2,
//                         onSelectChanged: (selected) {
//                           handleTableSelectChanged(2);
//                         },
//                       ),
//                       makeDataRow(
//                         cell1Text1: '16:04',
//                         cell1Text2: '01/07.22',
//                         cell2Text: '5.2s',
//                         progressColor: kCourseColors[6]['background']!,
//                         progress: 0.2,
//                         selected: selectedTableRowIndex == 3,
//                         onSelectChanged: (selected) {
//                           handleTableSelectChanged(3);
//                         },
//                       ),
//                       makeDataRow(
//                         cell1Text1: '16:04',
//                         cell1Text2: '01/07.22',
//                         cell2Text: '5.2s',
//                         progressColor: kCourseColors[6]['background']!,
//                         progress: 0.3,
//                         selected: selectedTableRowIndex == 4,
//                         onSelectChanged: (selected) {
//                           handleTableSelectChanged(4);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// LineChartData mainData() {
//   List<Color> gradientColors = [
//     const Color(0xff23b6e6),
//     const Color(0xff02d39a),
//   ];
//
//   return LineChartData(
//     gridData: FlGridData(
//       show: true,
//       drawVerticalLine: true,
//       getDrawingHorizontalLine: (value) {
//         return FlLine(
//           color: const Color(0xff37434d),
//           strokeWidth: 1,
//         );
//       },
//       getDrawingVerticalLine: (value) {
//         return FlLine(
//           color: const Color(0xff37434d),
//           strokeWidth: 1,
//         );
//       },
//     ),
//     titlesData: FlTitlesData(
//       show: true,
//       rightTitles: SideTitles(showTitles: false),
//       topTitles: SideTitles(showTitles: false),
//       bottomTitles: SideTitles(
//         showTitles: true,
//         reservedSize: 22,
//         interval: 1,
//         getTextStyles: (context, value) => const TextStyle(
//           color: Color(0xff68737d),
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//         getTitles: (value) {
//           switch (value.toInt()) {
//             case 2:
//               return '1';
//             case 4:
//               return '2';
//             case 6:
//               return '3';
//             case 8:
//               return '4';
//             case 10:
//               return '5';
//           }
//           return '';
//         },
//         margin: 8,
//       ),
//       leftTitles: SideTitles(
//         showTitles: true,
//         interval: 1,
//         getTextStyles: (context, value) => const TextStyle(
//           color: Color(0xff67727d),
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//         getTitles: (value) {
//           switch (value.toInt()) {
//             case 1:
//               return '20%';
//             case 3:
//               return '40%';
//             case 5:
//               return '60%';
//             case 7:
//               return '80%';
//             case 9:
//               return '100%';
//           }
//           return '';
//         },
//         reservedSize: 32,
//         margin: 12,
//       ),
//     ),
//     borderData: FlBorderData(
//       show: true,
//       border: Border.all(
//         color: const Color(0xff37434d),
//         width: 1,
//       ),
//     ),
//     minX: 0,
//     maxX: 11,
//     minY: 0,
//     maxY: 9,
//     lineBarsData: [
//       LineChartBarData(
//         spots: const [
//           FlSpot(0, 3),
//           FlSpot(2.6, 2),
//           FlSpot(4.9, 5),
//           FlSpot(6.8, 3.1),
//           FlSpot(8, 4),
//           FlSpot(9.5, 3),
//           FlSpot(11, 4),
//         ],
//         isCurved: true,
//         colors: gradientColors,
//         barWidth: 5,
//         isStrokeCapRound: true,
//         dotData: FlDotData(
//           show: false,
//         ),
//         belowBarData: BarAreaData(
//           show: true,
//           colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//         ),
//       ),
//     ],
//   );
// }
//
// // DataRow construction fxn
// DataRow makeDataRow({
//   required String cell1Text1,
//   required String cell1Text2,
//   required String cell2Text,
//   required double progress,
//   required Color progressColor,
//   bool selected: false,
//   required onSelectChanged,
// }) {
//   Color getColor(Set<MaterialState> states) {
//     const Set<MaterialState> interactiveStates = <MaterialState>{
//       MaterialState.selected,
//       MaterialState.focused,
//     };
//     if (states.any(interactiveStates.contains)) {
//       return kAnalysisScreenActiveColor;
//     }
//     return Colors.transparent;
//   }
//
//   return DataRow(
//     selected: selected,
//     onSelectChanged: onSelectChanged,
//     color: MaterialStateProperty.resolveWith(getColor),
//     cells: [
//       DataCell(
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [Text(cell1Text1), Text(cell1Text2, style: kTableBodySubText)],
//         ),
//       ),
//       DataCell(
//         Expanded(child: Text(cell2Text)),
//       ),
//       DataCell(
//         Expanded(
//           child: Center(
//             widthFactor: 1,
//             child: LinearPercentIndicatorWrapper(
//               percent: progress,
//               progressColor: progressColor,
//               backgroundColor: Color(0xFF363636),
//               label: (progress * 100).toString(),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

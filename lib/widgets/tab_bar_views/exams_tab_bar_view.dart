import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
import 'package:ecoach/widgets/dropdowns/bordered_dropdown_button.dart';
import 'package:ecoach/widgets/performance_detail_snippet_vertical.dart';
import 'package:ecoach/widgets/speed_arc.dart';
import 'package:ecoach/widgets/superscripted_denominator_fraction_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

import '../tab_bars/analysis_info_snippet_card_tab_bar.dart';

class ExamsTabBarView extends StatefulWidget {
  @override
  _ExamsTabBarViewState createState() => _ExamsTabBarViewState();
}

class _ExamsTabBarViewState extends State<ExamsTabBarView> {
  List<AnalysisInfoSnippet> infoList = [];
  int selectedTabIndex = 0;
  String dropdownValue = 'all';
  int selectedTableRowIndex = 0;

  handleTableSelectChanged(index) {
    setState(() {
      selectedTableRowIndex = index;
    });
  }

  handleSelectChanged(index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    infoList = [
      AnalysisInfoSnippet(
        bodyText: '19th',
        footerText: '209.5',
        performance: '3',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '209',
        footerText: '209.5',
        performance: '3',
        performanceImproved: false,
        background: kAnalysisInfoSnippetBackground2,
      ),
      AnalysisInfoSnippet(
        bodyText: '26.78',
        footerText: '209.5',
        performance: '3',
        performanceImproved: false,
        background: kAnalysisInfoSnippetBackground3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnalysisInfoSnippetCardTabBar(
                infoList: infoList,
                subLabels: ['Diagnostic1', 'BECE 2020', 'Term 1'],
                selectedIndex: selectedTabIndex,
                onActiveTabChange: handleSelectChanged,
              ),
            ),
            Container(
              color: kAnalysisScreenActiveColor,
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: 24.0,
              ),
              child: Column(
                children: [
                  // BorderedDropdownButton(
                  //   value: dropdownValue,
                  //   isExpanded: false,
                  //   size: Sizes.medium,
                  //   items: ['all', 'value 2', 'value 3', 'value 4'],
                  //   onChanged: (String? value) {
                  //     setState(() {
                  //       dropdownValue = value ?? '';
                  //     });
                  //   },
                  // ),
                  // SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PerformanceDetailSnippetVertical(
                            label: 'Rank',
                            content: SuperScriptedDenominatorFractionHorizontal(
                              numerator: 18,
                              denomenator: 305,
                              numeratorColor: Color(0x44FFFFFF),
                            ),
                          ),
                          SizedBox(width: 12),
                          PerformanceDetailSnippetVertical(
                            label: 'Point',
                            content: SuperScriptedDenominatorFractionHorizontal(
                              numerator: 205,
                              denomenator: 505,
                              numeratorColor: Color(0x44FFFFFF),
                            ),
                          ),
                          SizedBox(width: 12),
                          PerformanceDetailSnippetVertical(
                            label: 'Strength',
                            content: Column(
                              children: [
                                SignalStrengthIndicator.bars(
                                  value: 0.8,
                                  size: 44,
                                  barCount: 5,
                                  radius: Radius.circular(4.0),
                                  levels: <num, Color>{
                                    0.25: Colors.red,
                                    0.50: Colors.yellow,
                                    0.75: Colors.green,
                                  },
                                  inactiveColor: Colors.black26,
                                  activeColor: Colors.white,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '+2.5% gained',
                                  style: TextStyle(
                                    color: Color(0x88FFFFFF),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PerformanceDetailSnippetVertical(
                            label: 'Exposure',
                            verticalSpacing: 12.0,
                            content: CircularProgressIndicatorWrapper(
                              progress: 100,
                              progressPostFix: 'X',
                              useProgressAsMainCenterText: false,
                              mainCenterText: '2',
                              mainCenterTextSize: ProgressIndicatorSize.large,
                              size: ProgressIndicatorSize.large,
                              progressColor: kProgressColors[3],
                            ),
                          ),
                          SizedBox(width: 12),
                          PerformanceDetailSnippetVertical(
                            label: 'Mastery',
                            verticalSpacing: 12.0,
                            content: CircularProgressIndicatorWrapper(
                              progress: 85,
                              size: ProgressIndicatorSize.large,
                              progressColor: kProgressColors[4],
                              subCenterText: 'avg. score',
                            ),
                          ),
                          SizedBox(width: 12),
                          PerformanceDetailSnippetVertical(
                            label: 'Speed',
                            verticalSpacing: 12.0,
                            content: SpeedArc(speed: 2.5),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: kAnalysisScreenBackground,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 4.0,
                bottom: 24.0,
              ),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: kSixteenPointWhiteText,
                    dataTextStyle: kTableBodyMainText,
                    dataRowHeight: 64.0,
                    dividerThickness: 0,
                    showCheckboxColumn: false,
                    columns: [
                      DataColumn(label: Text('Topic')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Performance')),
                    ],
                    rows: [
                      makeDataRow(
                        cell1Text: 'Matter',
                        cell2Text: '5.2s',
                        progressColor: kCourseColors[0]['progress']!,
                        progress: 0.4,
                        selected: selectedTableRowIndex == 0,
                        onSelectChanged: (selected) {
                          handleTableSelectChanged(0);
                        },
                      ),
                      makeDataRow(
                        cell1Text: 'Density',
                        cell2Text: '5.2s',
                        progressColor: kCourseColors[4]['background']!,
                        progress: 1.0,
                        selected: selectedTableRowIndex == 1,
                        onSelectChanged: (selected) {
                          handleTableSelectChanged(1);
                        },
                      ),
                      makeDataRow(
                        cell1Text: 'Pressure',
                        cell2Text: '5.2s',
                        progressColor: kCourseColors[2]['background']!,
                        progress: 0.8,
                        selected: selectedTableRowIndex == 2,
                        onSelectChanged: (selected) {
                          handleTableSelectChanged(2);
                        },
                      ),
                      makeDataRow(
                        cell1Text: 'Machines',
                        cell2Text: '5.2s',
                        progressColor: kCourseColors[6]['background']!,
                        progress: 0.2,
                        selected: selectedTableRowIndex == 3,
                        onSelectChanged: (selected) {
                          handleTableSelectChanged(3);
                        },
                      ),
                      makeDataRow(
                        cell1Text: 'Water',
                        cell2Text: '5.2s',
                        progressColor: kCourseColors[6]['background']!,
                        progress: 0.3,
                        selected: selectedTableRowIndex == 4,
                        onSelectChanged: (selected) {
                          handleTableSelectChanged(4);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DataRow construction fxn
DataRow makeDataRow({
  required String cell1Text,
  required String cell2Text,
  required double progress,
  required Color progressColor,
  bool selected: false,
  required onSelectChanged,
}) {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return kAnalysisScreenActiveColor;
    }
    return Colors.transparent;
  }

  return DataRow(
    selected: selected,
    onSelectChanged: onSelectChanged,
    color: MaterialStateProperty.resolveWith(getColor),
    cells: [
      DataCell(
        Expanded(child: Text(cell1Text)),
      ),
      DataCell(
        Expanded(child: Text(cell2Text)),
      ),
      DataCell(
        Expanded(
          child: Center(
            widthFactor: 1,
            child: LinearPercentIndicatorWrapper(
              percent: progress,
              progressColor: progressColor,
              backgroundColor: Color(0xFF363636),
              label: (progress * 100).toString(),
            ),
          ),
        ),
      ),
    ],
  );
}

import 'dart:developer';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course_analysis.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/database/analysis_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/analysis_info_snippet_card.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllTabBarView extends StatefulWidget {
  AllTabBarView(this.item, {Key? key}) : super(key: key);
  SubscriptionItem item;

  @override
  _AllTabBarViewState createState() => _AllTabBarViewState();
}

class _AllTabBarViewState extends State<AllTabBarView> {
  List<AnalysisInfoSnippet> infoList = [];
  int selectedTableRowIndex = 0;

  handleSelectChanged(index) {
    setState(() {
      selectedTableRowIndex = index;
    });
  }

  List<TestTaken> testsTaken = [];

  @override
  void initState() {
    super.initState();
    getTestTaken();
    getAnalytics();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getTestTaken() {
    TestController().getTestTaken(widget.item.tag!).then((tests) {
      setState(() {
        testsTaken = tests;
      });
    });

    ApiCall<TestTaken>(AppUrl.testTaken, create: (dataItem) {
      return TestTaken.fromJson(dataItem);
    }, onError: (e) {
      print(e);
    }, params: {'course_id': widget.item.tag!}).get(context).then((tests) {
      if (tests == null) return;
      TestTakenDB().insertAll(tests);
      setState(() {
        testsTaken = tests;
      });
    });
  }

  getAnalytics() {
    AnalysisDB().getAnalysisById(int.parse(widget.item.tag!)).then((analytic) {
      // print(analytic!.toJson());
      setInfoList(analytic);

      ApiCall<CourseAnalytic>(AppUrl.analysis + '/' + widget.item.tag!,
              isList: false, create: (dataItem) {
        return CourseAnalytic.fromJson(dataItem);
      }, onError: (e) {
        print(e);
      },
              params: analytic != null
                  ? {
                      'points': analytic.coursePoint ?? null,
                      'last_points': analytic.lastCoursePoint ?? null,
                      'rank': analytic.userRank ?? null,
                      'last_rank': analytic.lastUserRank ?? null,
                      'total_rank': analytic.totalRank ?? null,
                      'mastery': analytic.mastery ?? null,
                      'last_mastery': analytic.lastMastery ?? null,
                      'speed': analytic.usedSpeed ?? null,
                      'last_speed': analytic.lastSpeed ?? null,
                    }
                  : {})
          .get(context)
          .then((analytic) {
        if (analytic == null) return;
        AnalysisDB().insert(analytic);
        setState(() {
          setInfoList(analytic);
        });
      });
    });
  }

  setInfoList(CourseAnalytic? analytic) {
    if (analytic == null) return;
    Duration speedDuration = Duration(seconds: analytic.usedSpeed ?? 0);
    infoList = [
      AnalysisInfoSnippet(
        bodyText: '${positionText(analytic.userRank ?? 0)}',
        footerText: 'rank',
        performance: analytic.lastUserRank != null
            ? "${analytic.lastUserRank! - analytic.userRank!}"
            : "-",
        performanceImproved: analytic.lastUserRank != null
            ? analytic.lastUserRank! - analytic.userRank! >= 0
            : true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '${analytic.coursePoint!.floor()}',
        footerText: 'points',
        performance: analytic.lastCoursePoint != null
            ? "${analytic.coursePoint! - analytic.lastCoursePoint!}"
            : "-",
        performanceImproved: analytic.lastCoursePoint != null
            ? analytic.coursePoint! - analytic.lastCoursePoint! >= 0
            : true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '${(analytic.mastery! * 100).floor()}',
        footerText: 'mastery',
        performance: analytic.lastMastery != null
            ? "${analytic.mastery! - analytic.lastMastery!}"
            : "-",
        performanceImproved: analytic.lastMastery != null
            ? analytic.mastery! - analytic.lastMastery! >= 0
            : true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText:
            "${NumberFormat('00').format(speedDuration.inHours)}:${NumberFormat('00').format(speedDuration.inMinutes % 60)}",
        footerText: 'speed',
        performance: analytic.lastSpeed != null
            ? "${analytic.usedSpeed! - analytic.lastSpeed!}"
            : "-",
        performanceImproved: analytic.lastSpeed != null
            ? analytic.usedSpeed! - analytic.lastSpeed! >= 0
            : true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '12',
        footerText: 'other',
        performance: '4',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //         'Today',
              //         style: kSixteenPointWhiteText,
              //       ),
              //       IconButton(
              //         onPressed: () {},
              //         icon: Icon(
              //           Icons.more_horiz,
              //           color: Colors.white,
              //           size: 28.0,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // SizedBox(height: 12.0),
              Container(
                height: 140.0,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: infoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 12.0,
                        right: index == infoList.length - 1 ? 16.0 : 0,
                      ),
                      child: AnalysisInfoSnippetCard(info: infoList[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 32.0),
              Container(
                color: kAnalysisScreenActiveColor,
                padding: const EdgeInsets.only(
                  top: 4.0,
                  bottom: 24.0,
                ),
                child: Center(
                  child: Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: kSixteenPointWhiteText,
                        dataTextStyle: kTableBodyMainText,
                        dataRowHeight: 72.0,
                        dividerThickness: 0,
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Time (s)')),
                          DataColumn(label: Text('Score')),
                        ],
                        rows: [
                          for (int i = 0; i < testsTaken.length; i++)
                            makeDataRow(
                              cell1Text1: getTime(testsTaken[i].datetime!),
                              cell1Text2: getDateOnly(testsTaken[i].datetime!),
                              cell2Text1: testsTaken[i].testname!,
                              cell2Text2: testsTaken[i].testType!,
                              cell3Text: "${testsTaken[i].testTime!}",
                              progressColor:
                                  kCourseColors[i % kCourseColors.length]
                                      ['progress']!,
                              progress: testsTaken[i].correct! /
                                  testsTaken[i].totalQuestions,
                              selected: selectedTableRowIndex == i,
                              onSelectChanged: (selected) {
                                handleSelectChanged(i);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

DataRow makeDataRow({
  required String cell1Text1,
  required String cell1Text2,
  required String cell2Text1,
  required String cell2Text2,
  required String cell3Text,
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
      return kAnalysisScreenBackground;
    }
    return Colors.transparent;
  }

  print("progress= $progress");
  List<String> type = cell2Text2.split(".");
  String testType = type.length > 1 ? type[1] : type[0];

  return DataRow(
    selected: selected,
    onSelectChanged: onSelectChanged,
    color: MaterialStateProperty.resolveWith(getColor),
    cells: [
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(cell1Text1),
            Text(cell1Text2, style: kTableBodySubText)
          ],
        ),
      ),
      DataCell(
        Container(
          width: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cell2Text1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              Text(testType, style: kTableBodySubText)
            ],
          ),
        ),
      ),
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(cell3Text, softWrap: true)],
        ),
      ),
      DataCell(
        Center(
          widthFactor: 1,
          child: LinearPercentIndicatorWrapper(
            percent: progress,
            progressColor: progressColor,
            backgroundColor: Color(0xFF363636),
            label: (progress * 100).toString(),
          ),
        ),
      ),
    ],
  );
}

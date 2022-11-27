import 'dart:math';

import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/widgets/adeo_loading_progress_indicator.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/dropdowns/adeo_dropdown.dart';
import 'package:ecoach/widgets/section_heading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressChart extends StatefulWidget {
  ProgressChart({
    required this.subscriptions,
    required this.user,
    this.selectedSubscription,
    this.updateState,
    Key? key,
  }) : super(key: key);

  final List<SubscriptionItem> subscriptions;
  SubscriptionItem? selectedSubscription;
  final dynamic updateState;
  final User user;

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  List<TestTaken> testData = [];
  String dropdownValue = 'All';
  Course? course;
  int offset = 0;
  List<FlSpot> testdata = [];
  final List<FlSpot> dummyData1 = [];
  final List<FlSpot> dummyData2 = [];
  final List<FlSpot> dummyData3 = [];

  getAverageStats(String progressType) async {
    testData.clear();
    testdata.clear();
    dummyData1.clear();
    dummyData2.clear();
    dummyData3.clear();
    print("periodperiod:$progressType");
    if (course == null) {
      testData = await TestTakenDB().getAllAverageScore(offset: offset );
    } else {
      testData = await TestTakenDB().getAllAverageScore(courseId: course!.id.toString(),offset: offset);
    }
    print("testData len:${testData.length}");
    if (progressType == "exam") {
      List<TestTaken> graphResultData = [];
      graphResultData = testData
          .where((element) =>
              element.challengeType == TestCategory.EXAM.toString() ||
              element.challengeType == TestCategory.MOCK.toString() ||
              element.challengeType == TestCategory.NONE.toString())
          .toList();
      for (int i = 0; i < graphResultData.length; i++) {
        final test = graphResultData[i];
        dummyData1.add(
          FlSpot(
            (i + 1).toDouble(),
            double.parse(test.score!.toStringAsFixed(2)),
          ),
        );
      }
    } else if (progressType == "topic") {
      List<TestTaken> graphResultData = [];
      graphResultData = testData
          .where((element) =>
              element.challengeType == TestCategory.TOPIC.toString())
          .toList();
      for (int i = 0; i < graphResultData.length; i++) {
        final test = graphResultData[i];
        dummyData2.add(
          FlSpot(
            (i + 1).toDouble(),
            double.parse(test.score!.toStringAsFixed(2)),
          ),
        );
      }
    } else if (progressType == "other") {
      List<TestTaken> graphResultData = [];
      graphResultData = testData
          .where((element) =>
              element.challengeType != TestCategory.TOPIC.toString() &&
              element.challengeType != TestCategory.EXAM.toString() &&
              element.challengeType != TestCategory.MOCK.toString() &&
              element.challengeType != TestCategory.NONE.toString())
          .toList();
      for (int i = 0; i < graphResultData.length; i++) {
        final test = graphResultData[i];
        dummyData3.add(
          FlSpot(
            (i + 1).toDouble(),
            double.parse(test.score!.toStringAsFixed(2)),
          ),
        );
      }
    }
    // else {
    //   List<TestTaken> graphResultData = [];
    //   graphResultData = testData;
    //   for (int i = 0; i < graphResultData.length; i++) {
    //     final test = graphResultData[i];
    //     dummyData1.add(
    //       FlSpot(
    //         (i + 1).toDouble(),
    //         double.parse(test.score!.toStringAsFixed(2)),
    //       ),
    //     );
    //   }
    // }

    setState(() {});
  }

  getCourseById(int id) {
    return CourseDB().getCourseById(id);
  }

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

  getUserTestTakenResults() async {
    listTestTaken = await GroupManagementController().getTestTaken();
    getAverageStats("exam");
    getAverageStats("topic");
    getAverageStats("other");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (listTestTaken.isEmpty) {
      getUserTestTakenResults();
    } else {
      getAverageStats("exam");
      getAverageStats("topic");
      getAverageStats("other");
    }
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionHeading(
                          'your progress',
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                          ),
                        ),
                        // SizedBox(width: 40),
                        if (widget.selectedSubscription == null)
                          LoadingProgressIndicator(
                            activeColor: kAdeoCoral,
                            backgroundColor: kShadowColor,
                            size: 20,
                            strokeWidth: 3,
                          ),
                        SectionHeaderTextButton(
                          label: 'View Details',
                          textStyle: appStyle(col: Color(0xFF1182D8)),
                          onPressed: () {
                            goTo(
                              context,
                              AnalysisView(
                                user: widget.user,
                                course: course,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 0),
                    if (widget.selectedSubscription != null)
                      AdeoDropDown(
                        value: widget.selectedSubscription!,
                        items: widget.subscriptions,
                        onChanged: (item) async {
                          print("selectedSubscription:${item.tag}");
                          widget.selectedSubscription = item;
                          course = await getCourseById(int.parse(item.tag!));
                          setState(() {});
                          dummyData1.clear();
                          dummyData2.clear();
                          dummyData3.clear();
                          getAverageStats("exam");
                          getAverageStats("topic");
                          getAverageStats("other");
                        },
                      ),
                    SizedBox(height: 10),
                  ],
                ),
                // Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    SizedBox(width: 10,),
                    GestureDetector(
                        onTap: (){
                          if(offset != 0){
                            setState(() {
                              offset = offset - 10;
                            });

                            getAverageStats("exam",);
                            getAverageStats("topic");
                            getAverageStats("other");
                          }


                        }, child: Icon(Icons.arrow_back_ios,size: 16,color: offset == 0 ? Colors.grey[400] : Colors.black,)),
                        sText("${offset + 10}"),
                    GestureDetector(
                        onTap: (){
                          if(testData.isNotEmpty){
                            setState(() {
                              offset = offset + 10;
                            });
                            getAverageStats("exam",);
                            getAverageStats("topic");
                            getAverageStats("other");
                          }

                      }, child: Icon(Icons.arrow_forward_ios,size: 16,color: offset != 0 && testData.isEmpty ? Colors.grey[400] : Colors.black,)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (dummyData1.isNotEmpty ||
              dummyData2.isNotEmpty ||
              dummyData3.isNotEmpty)
            Expanded(
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    drawHorizontalLine: false,
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
                      interval: 20,
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
          else
            Expanded(
              child: Center(
                child: sText("No Progress data available"),
              ),
            )
        ],
      ),
    );
  }
}

import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/widgets/adeo_analysis_graph.dart';
import 'package:ecoach/widgets/cards/stats_slider_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as math;
import 'package:syncfusion_flutter_charts/charts.dart';

class KeywordGraph extends StatefulWidget {
  String keyword;
  final Course course;
  bool changeState;
  KeywordGraph(
      {
        required this.keyword,
        required this.course,
        this.changeState = false,

      });

  @override
  State<KeywordGraph> createState() => _KeywordGraphState();
}

class _KeywordGraphState extends State<KeywordGraph> {
  List<TestTaken> testData = [];
  String dropdownValue = 'All';
  List<FlSpot> testdata = [];
  getAverageStats(String period) async {
    testData.clear();
    testdata.clear();
    List<TestTaken> graphResultData = [];
    testData = await TestTakenDB().getKeywordTestTakenPeriod(widget.course.id!.toString(), period, widget.keyword.toLowerCase());
    print("course id:${widget.course.id}");
    graphResultData = testData;
    for (int i = 0; i < graphResultData.length; i++) {
      final test = graphResultData[i];
      testdata.add(
        FlSpot(
          (i + 1).toDouble(),
          double.parse(test.score!.toStringAsFixed(2)),
        ),
      );
    }
    setState(() {});
  }


  getStat() async {
    await getAverageStats(dropdownValue);
    setState(() {
      widget.changeState = false;
    });
  }

  buildDropDownButton() {
    return DropdownButton<String>(
      dropdownColor: Colors.blue,
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(
        color: Colors.white,
      ),
      underline: Container(
        height: 0,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          getStat();
          print(dropdownValue);
        });
      },
      items: <String>[
        'All',
        'Daily',
        'Weekly',
        'Monthly',
      ].map<DropdownMenuItem<String>>(
            (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    getStat();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.changeState){
      getStat();
    }
    return Container(
      child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: Colors.transparent,
          child:  testdata.isNotEmpty
              ? Stack(
            fit: StackFit.passthrough,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    right: 12,
                  ),
                  child: Container(
                    height: 30,
                    width: 100,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: buildDropDownButton(),
                    ),
                  ),
                ),
              ),
              // sfCartesianChart(),
              Container(
                padding: const EdgeInsets.only(
                  right: 18.0,
                  left: 12.0,
                  top: 24,
                  bottom: 12,
                ),
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 1,
                    maxY: 100.0,
                    minY: 0,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    gridData: FlGridData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: SideTitles(
                        showTitles: false,
                      ),
                      topTitles: SideTitles(
                        showTitles: false,
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTitles: (double value) {
                          debugPrint(value.toInt().toString());
                          return value.toInt().toString();
                          // return widget
                          //     .testData![(value - 1).toInt()].testname!;
                        },
                        getTextStyles:
                            (BuildContext context, value) =>
                        const TextStyle(
                          color: Color(0xFF67727D),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        margin: 8,
                        interval: 1,
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: testdata,
                        isCurved: true,
                        show: true,
                        colors: [Colors.blue, Colors.green],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.green.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
              : Container(
              padding: EdgeInsets.only(bottom: 10),
              child: sText("No records for graph"))
      ),
    );
  }
}

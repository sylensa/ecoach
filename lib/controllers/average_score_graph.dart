import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/widgets/adeo_analysis_graph.dart';
import 'package:ecoach/widgets/cards/stats_slider_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as math;
import 'package:syncfusion_flutter_charts/charts.dart';

class AverageScoreGraph extends StatefulWidget {
   Stat? stats;
  final Course course;
  AverageScoreGraph({this.stats,required this.course});

  @override
  State<AverageScoreGraph> createState() => _AverageScoreGraphState();
}

class _AverageScoreGraphState extends State<AverageScoreGraph> {
List <TestTaken> testData = [];
String dropdownValue = 'All';
List<FlSpot> testdata = [];
  getStats(String period)async{
    testData.clear();
    testdata.clear();
    testData = await TestTakenDB().courseTestsTakenPeriod(widget.course.id!,period);
    for (int i = 0; i < testData.length; i++) {
      final test = testData[i];
      testdata.add(
        FlSpot(
          (i + 1).toDouble(),
          double.parse(test.score!.toStringAsFixed(2)),
        ),
      );
    }
    setState((){

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
        getStats(dropdownValue);
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
 void initState(){
    super.initState();
    getStats('All');
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.blue.withOpacity(0.05),
        child: ExpansionTile(
          collapsedTextColor: Colors.black,
          collapsedIconColor: Colors.black,
          iconColor: Colors.black,
          title: const Text(
            'Performance Graph',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          children: [
            Stack(
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
                      width: 80,
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
                  height: 250,
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
                          getTextStyles: (BuildContext context, value) =>
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
          ],
        ),
      ),
    );
  }

}


import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/compare.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExamsTabPage extends StatefulWidget {
  const ExamsTabPage({
    required this.course,
    required this.user,
    Key? key,
  }) : super(key: key);
  final Course course;
  final User user;

  @override
  State<ExamsTabPage> createState() => _ExamsTabPageState();
}

class _ExamsTabPageState extends State<ExamsTabPage> {
  late bool showInPercentage;
  List<TestTaken> selected = [];
  Future<List<TestTaken>>? tests;
  List <TestTaken> graphTestData = [];
  String dropdownValue = 'All';
  List<FlSpot> graphData = [];
  getStats(String period)async{
    graphTestData.clear();
    graphData.clear();
    graphTestData = await TestTakenDB().courseTestsTakenPeriod(widget.course.id!,period);
    for (int i = 0; i < graphTestData.length; i++) {
      final test = graphTestData[i];
      graphData.add(
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
  handleSelection(test) {
    setState(() {
      if (selected.contains(test))
        selected = selected.where((item) => item != test).toList();
      else
        selected = [...selected, test];
    });
  }
  getAll(var test)async{
    reviewQuestionsBack.clear();
    List<Question> questions = await TestController().getAllQuestions(test);
    if(questions.isNotEmpty){
      for(int i = 0; i < questions.length; i++){
        reviewQuestionsBack.add(questions[i]);
      }
      setState(() {
        print("again savedQuestions:${reviewQuestionsBack.length}");
      });
      Navigator.pop(context);
      if(test.testname.toString().toLowerCase() == "test diagnostic"){
        goTo(context, QuizReviewPage(testTaken: selected[0],user: widget.user,disgnostic: true,));
      }else{
        goTo(context, QuizReviewPage(testTaken: selected[0],user: widget.user,));
    }
    }else{
      Navigator.pop(context);
      toastMessage("Question are empty, please download questions");
    }


  }

  @override
  void initState() {
    showInPercentage = false;
    getStats('All');
    tests = TestTakenDB().courseTestsTaken(widget.course.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //graph
        Padding(
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
                              spots: graphData,
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
        ),
        FutureBuilder(
          future: tests,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              default:
                if (snapshot.hasError)
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: inlinePromptStyle.copyWith(color: Colors.red),
                      ),
                    ),
                  );
                else if (snapshot.data != null) {
                  List<TestTaken> testData = snapshot.data! as List<TestTaken>;
                  List<TestTaken> examTest = testData
                      .where((element) =>
                          element.challengeType ==
                              TestCategory.EXAM.toString() ||
                          element.challengeType == TestCategory.MOCK.toString() ||
                              element.challengeType == TestCategory.NONE.toString()
                  )
                      .toList();

                  return Expanded(
                    child: examTest.length == 0
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                'You haven\'t taken any EXAMS-based tests under this course yet',
                                style: inlinePromptStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(height: 16),
                              PercentageSwitch(
                                showInPercentage: showInPercentage,
                                onChanged: (val) {
                                  setState(() {
                                    showInPercentage = val;
                                  });
                                },
                              ),
                              SizedBox(height: 15),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: examTest.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      TestTaken test = examTest[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        child: AnalysisCard(
                                          showInPercentage: showInPercentage,
                                          isSelected: selected.contains(test),
                                          metaData: ActivityMetaData(
                                            date: test.datetime
                                                .toString()
                                                .split(' ')[0],
                                            time: test.datetime
                                                .toString()
                                                .split(' ')[1]
                                                .split('.')[0],
                                            duration: test.usedTimeText,
                                          ),
                                          activity: test.testname!,
                                          activityType: 'Exam',
                                          correctlyAnswered: test.correct!,
                                          totalQuestions: test.totalQuestions,
                                          onTap: () {
                                            handleSelection(test);
                                          },
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                  );
                } else
                  return Expanded(
                    child: Center(
                      child: Text(
                        "Something isn't right",
                        style: inlinePromptStyle,
                      ),
                    ),
                  );
            }
          },
        ),
        if (selected != null)
          Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
            ),
            child: selected.length > 1
                ? Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'analyse',
                          fontSize: 16,
                          color: kAdeoBlue2,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CompareView(
                                    user: widget.user,
                                    course: widget.course,
                                    operands: selected,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ) :
                 selected.length == 1 ?
                 Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AdeoTextButton(
                                label: 'review',
                                fontSize: 16,
                                color: kAdeoBlue2,
                                onPressed: () async{
                                  showLoaderDialog(context, message: "Loading");
                                  await  getAll(selected[0]);
                                },
                              ),
                            ),
                            Container(width: 1.0, color: kPageBackgroundGray),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AdeoTextButton(
                                label: 'result',
                                fontSize: 16,
                                color: kAdeoBlue2,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (BuildContext) {
                                      return ResultsView(
                                        widget.user,
                                        widget.course,
                                        TestType.NONE,
                                        test: selected[0],
                                        diagnostic: selected[0].testname.toString().toLowerCase() == "test diagnostic" ? true : false,
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                            // Container(width: 1.0, color: kPageBackgroundGray),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: AdeoTextButton(
                      //     label: 'retake',
                      //     fontSize: 16,
                      //     color: kAdeoBlue2,
                      //     onPressed: () {},
                      //   ),
                      // ),
                    ],
                  ) : SizedBox.shrink(),
          )
      ],
    );
  }
}

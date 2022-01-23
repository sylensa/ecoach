import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:flutter/material.dart';

class TopicsTabPage extends StatefulWidget {
  const TopicsTabPage({
    required this.course,
    required this.user,
    Key? key,
  }) : super(key: key);
  final Course course;
  final User user;

  @override
  State<TopicsTabPage> createState() => _TopicsTabPageState();
}

class _TopicsTabPageState extends State<TopicsTabPage> {
  late bool showInPercentage;
  dynamic selected = null;
  Future<List<TestTaken>>? tests;

  handleSelection(test) {
    setState(() {
      if (selected == test)
        selected = null;
      else
        selected = test;
    });
  }

  @override
  void initState() {
    showInPercentage = false;
    tests = TestTakenDB().courseTestsTaken(widget.course.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  List<TestTaken> topicTest = testData
                      .where((element) =>
                          element.challengeType ==
                          TestCategory.TOPIC.toString())
                      .toList();
                  return Expanded(
                    child: topicTest.length == 0
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                'You haven\'t taken any TOPICS-based tests under this course yet',
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
                                    itemCount: topicTest.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      TestTaken test = topicTest[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        child: AnalysisCard(
                                          showInPercentage: showInPercentage,
                                          isSelected: selected == test,
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
                                          activityType: 'Topic',
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
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'review',
                          fontSize: 16,
                          color: kAdeoBlue2,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: kPageBackgroundGray,
                      ),
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
                                  test: selected[0],
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: kPageBackgroundGray,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AdeoTextButton(
                    label: 'retake',
                    fontSize: 16,
                    color: kAdeoBlue2,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}

import 'dart:developer';

import 'package:ecoach/controllers/average_score_graph.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/quiz/review_page.dart';
import 'package:ecoach/views/results_ui.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AllTabPage extends StatefulWidget {
   AllTabPage({
    required this.course,
    required this.user,
   required this.rightWidgetState,
    this.onChangeStatus = false,
    Key? key,
  }) : super(key: key);
  final Course course;
  final User user;
  final String rightWidgetState;
  bool onChangeStatus;
  @override
  State<AllTabPage> createState() => _AllTabPageState();
}

class _AllTabPageState extends State<AllTabPage> {
  late bool showInPercentage;
  dynamic selected = null;
  Future<List<TestTaken>>? tests;
  List<TestTaken> listTests = [];

  handleSelection(test) {
    setState(() {
      if (selected == test)
        selected = null;
      else
        selected = test;
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
      print("test.testname:${test.testname}");
      if(test.testname.toString().toLowerCase() == "test diagnostic"){
        goTo(context, QuizReviewPage(testTaken: selected,user: widget.user,disgnostic: true,));
      }else{
        goTo(context, QuizReviewPage(testTaken: selected,user: widget.user,));
      }
    }else{
      Navigator.pop(context);
      toastMessage("Question are empty, please download questions");
    }


  }
  @override
  void initState() {
    super.initState();
    showInPercentage = false;
    print("object hjjh:${widget.rightWidgetState}");
    tests = TestTakenDB().courseTestsTaken(courseId: widget.course.id!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        //graph
        if(widget.rightWidgetState  == "average")
        AverageScoreGraph(course:widget.course,rightWidgetState:widget.rightWidgetState ,onChangeStatus: widget.onChangeStatus),
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
                  // List<TestTaken> testTakenData = testData;
                    listTests = testData;
                  inspect(testData);
                  return Expanded(
                    child: testData.length > 0
                        ? Column(
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
                                    itemCount: testData.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      TestTaken test = testData[index];
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
                                          activityType:
                                              test.challengeType != null
                                                  ? test.challengeType!
                                                      .split('.')[1]
                                                      .toLowerCase()
                                                      .toCapitalized()
                                                  : ' ',
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
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                'You haven\'t taken any tests under this course yet',
                                style: inlinePromptStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
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
                          onPressed: () async{
                            showLoaderDialog(context, message: "Loading");
                           await  getAll(selected);
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
                                  diagnostic: selected.testname.toString().toLowerCase() == "test diagnostic" ? true : false,
                                  test: selected,
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
            ),
          )
      ],
    );
  }
}

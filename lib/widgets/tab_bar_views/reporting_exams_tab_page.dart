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
      goTo(context, QuizReviewPage(testTaken: selected[0],user: widget.user,));
    }else{
      Navigator.pop(context);
      toastMessage("Question are empty, please download questions");
    }


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
                  ) : Container(),
          )
      ],
    );
  }
}

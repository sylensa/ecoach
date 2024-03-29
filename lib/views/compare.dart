import 'dart:developer';

import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/topic_analysis_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/grade.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/topic_analysis_model.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/cards/stats_slider_card.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:flutter/material.dart';

class CompareView extends StatefulWidget {
  static const String routeName = '/analysis';
  final List<TestTaken> operands;
  final User user;
  final Course course;
  const CompareView({
    required this.user,
    required this.course,
    required this.operands,
    Key? key,
  }) : super(key: key);

  @override
  _CompareViewState createState() => _CompareViewState();
}

class _CompareViewState extends State<CompareView> {
  late bool showInPercentage;
  dynamic selected = null;
  String rightWidgetState = '';
   Map<String, dynamic>? stats;
  List topics = [];
  List listTopicsTestTaken = [];
  List listTopicsTestTakenResults = [];
  bool expansionOnChange = false;

  getStarted()async{
    await TopicAnalysisDB().delete();

    showInPercentage = true;

    int correct = 0;
    int totalQuestions = 0;
    double score = 0;
    List<TestTaken> tests = widget.operands;
    List<TestTaken> testResults = [];
    List<TopicAnalysisList> listRes = [];
    for(int i =0; i< tests.length; i++){
      listRes.clear();
      TestTaken test = tests[i];
      correct += test.correct!;
      totalQuestions += test.totalQuestions;
      score += test.score!;
      testResults.add(test);
      Map<String, List<TestAnswer>> listTestAnswer = await TestController().topicsAnalysis(test);
      List<TestAnswer>? answers;

      int corrects = 0;
      listTestAnswer.keys.forEach((key) {

        answers = listTestAnswer[key]!;
        TopicAnalysis analysis = TopicAnalysis(key, answers!);
        corrects += analysis.correct;
        TopicAnalysisList topicAnalysisList = TopicAnalysisList(
            topicId: analysis.answers[0].topicId.toString(),
            name: analysis.name,
            totalQuestions: analysis.total,
            correctlyAnswered: double.parse(analysis.correct.toStringAsFixed(2)),
            testId: test.id.toString(),
            testName: test.testname,
            testScore: double.parse(analysis.correct.toStringAsFixed(2))

        );
        listRes.add(topicAnalysisList);
        TopicAnalysisDB().insert(topicAnalysisList);



      });
      print("topicAnalysisList len:${listRes.length}");

    }
    double avgScore = score / tests.length;
    stats = {
      'avgScore': avgScore,
      'overallOutlook': (tests[0].score! - tests[tests.length - 1].score!) /
          (tests.length - 1),
      'correct': correct,
      'totalQuestions': totalQuestions,
      'grade': GradingSystem(
        score: avgScore,
        level: widget.course.packageCode!,
      ).grade,
    };

  for(int i = 0; i < listRes.length; i++){
    List<TopicAnalysisList> res = await  TopicAnalysisDB().getTopicsAnalysisAverageScore(listRes[i].topicId.toString());
    for(int i =0; i < res.length; i++){
      print("res[i].testId!:${res.length}");
      List<TopicAnalysisList> mapListTopic = await  TopicAnalysisDB().getTopicsAnalysisAverageScorExam(res[i].topicId.toString());
      topics.add({
        'topic_id': res[i].topicId,
        'name': res[i].name,
        'total_questions': res[i].totalQuestions,
        'correctly_answered': res[i].correctlyAnswered,
        'test':mapListTopic
      });
    }
    setState(() {});
    print("topics len:${topics.length}");
  }




  }
  @override
  void initState() {
    super.initState();
    getStarted();

  }

  getTopicsTaken(){
    print("listTopicsTestTaken len:${listTopicsTestTaken.length}");
    for(int i = 0; i < topics.length; i++){
      dynamic total = (topics[i]["correct_answers"] ?? 0);
      for(int t = 0; t < listTopicsTestTaken.length; t++){
          if(topics[i]["topicId"] == listTopicsTestTaken[t]["topicId"]){
            total = total + (listTopicsTestTaken[t]["correct_answers"] ?? 0);
            listTopicsTestTakenResults.add(listTopicsTestTaken[t]);
          }
      }

    }

    setState((){

    });
   // return SizedBox(
   //   height: 200,
   //   child: ListView.builder(
   //        itemCount: listTopicsTestTaken.length,
   //        itemBuilder: (BuildContext context, int index){
   //          var test = listTopicsTestTaken[index];
   //          print("test:$test");
   //          print("listTopicsTestTaken:${listTopicsTestTaken.length}");
   //        return Padding(
   //          padding:
   //          EdgeInsets.symmetric(horizontal: 0),
   //          child: MultiPurposeCourseCardAnnex(
   //            hasSmallHeading: true,
   //            title: "${index +1}.  ${test['name']}",
   //            subTitle: '',
   //            isActive: selected == test,
   //            rightWidget: (() {
   //              switch (
   //              rightWidgetState.toUpperCase()) {
   //                case 'TOTAL_POINTS':
   //                  return FractionSnippet(
   //                    correctlyAnswered:
   //                    test['correctly_answered'],
   //                    totalQuestions:
   //                    test['total_questions'],
   //                    isSelected: selected == test,
   //
   //                  );
   //                case 'STRENGTH':
   //                  return AdeoSignalStrengthIndicator(
   //                    strength: (test[
   //                    'correctly_answered'] /
   //                        test['total_questions']) *
   //                        100,
   //                    size: Sizes.small,
   //                  );
   //                case 'GRADE':
   //                  return Text(
   //                    GradingSystem(
   //                        score: test[
   //                        'correctly_answered'] /
   //                            test[
   //                            'total_questions'],
   //                        level: widget
   //                            .course.packageCode!)
   //                        .grade,
   //                    style: TextStyle(
   //                      color: selected == test
   //                          ? Colors.white
   //                          : Color(0xFF2A9CEA),
   //                      fontSize: 11.0,
   //                      fontWeight: FontWeight.w600,
   //                    ),
   //                  );
   //                default:
   //                  return PercentageSnippet(
   //                    correctlyAnswered:
   //                    test['correctly_answered'],
   //                    totalQuestions:
   //                    test['total_questions'],
   //                    isSelected: selected == test,
   //
   //                  );
   //              }
   //            })(),
   //            onTap: () {
   //              handleSelection(test);
   //            },
   //          ),
   //        );
   //    }),
   // );
  }

  handleSelection(test) {
    setState(() {
      if (selected == test)
        selected = null;
      else
        selected = test;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              pageHeading: 'Comparing Exams',
              size: Sizes.small,
            ),
            if (stats != null)
              StatsSliderCard(
                items: [
                  Stat(
                    value: stats!['avgScore'].toStringAsFixed(1),
                    statLabel: 'average score',
                  ),
                  Stat(
                      value:
                          '${stats!['overallOutlook'] > 0 ? '+' : ''}${stats!['overallOutlook'].toStringAsFixed(0)}',
                      statLabel: 'overall outlook'),
                  Stat(
                      value: '${stats!['correct']}/${stats!['totalQuestions']}',
                      statLabel: 'total points'),
                  Stat(
                    hasStandaloneWidgetAsValue: true,
                    statLabel: 'strength',
                    value: AdeoSignalStrengthIndicator(
                      strength: stats!['avgScore'],
                    ),
                  ),
                  Stat(value: stats!['grade'], statLabel: 'grade'),
                ],
                onChanged: (page) {
                  setState(() {
                    switch (page) {
                      case 2:
                        rightWidgetState = 'total_points';
                        break;
                      case 3:
                        rightWidgetState = 'strength';
                        break;
                      case 4:
                        rightWidgetState = 'grade';
                        break;
                      default:
                        rightWidgetState = '';
                    }
                  });
                },
                course: widget.course,
              ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: widget.operands.map((test) =>
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: MultiPurposeCourseCard(
                              hasSmallHeading: true,
                              title: test.testname!,
                              subTitle: test.challengeType != null
                                  ? test.challengeType!
                                  .split('.')[1]
                                  .toLowerCase()
                                  .toCapitalized()
                                  : 'Null',
                              isActive: selected == test,
                              rightWidget: (() {
                                switch (rightWidgetState.toUpperCase()) {
                                  case 'TOTAL_POINTS':
                                    return FractionSnippet(
                                      correctlyAnswered: test.correct,
                                      totalQuestions: test.totalQuestions,
                                      isSelected: selected == test,
                                    );
                                  case 'STRENGTH':
                                    return AdeoSignalStrengthIndicator(
                                      strength: (test.correct! /
                                          test.totalQuestions) *
                                          100,
                                      size: Sizes.small,
                                    );
                                  case 'GRADE':
                                    return Text(
                                      GradingSystem(
                                          score: test.score!,
                                          level:
                                          widget.course.packageCode!)
                                          .grade,
                                      style: TextStyle(
                                        color: selected == test
                                            ? Colors.white
                                            : Color(0xFF2A9CEA),
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  default:
                                    return PercentageSnippet(
                                      correctlyAnswered: test.correct,
                                      totalQuestions: test.totalQuestions,
                                      isSelected: selected == test,
                                    );
                                }
                              })(),
                              onTap: () {
                                handleSelection(test);
                              },
                            ),
                          ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 14),
                    if (rightWidgetState.toUpperCase() != 'GRADE' && topics.length > 0)
                      Column(
                        children: [
                          Container(height: 3, color: Colors.white),
                          SizedBox(height: 20),
                          Text(
                            'Topics',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: kDefaultBlack,
                            ),
                          ),
                          SizedBox(height: 15),
                          Column(
                            children: topics
                                .map(
                                  (test) =>
                                      Column(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 24),
                                                child: MultiPurposeCourseCardAnnex(
                                                      hasSmallHeading: true,
                                                      title: test['name'],
                                                      subTitle: 'Topic',
                                                      isActive: selected == test,
                                                      rightWidget: (() {
                                                        switch (
                                                            rightWidgetState.toUpperCase()) {
                                                          case 'TOTAL_POINTS':
                                                            return FractionSnippet(
                                                              correctlyAnswered:
                                                                  test['correctly_answered'],
                                                              totalQuestions:
                                                                  test['total_questions'],
                                                              isSelected: selected == test,
                                                            );
                                                          case 'STRENGTH':
                                                            return AdeoSignalStrengthIndicator(
                                                              strength: (test[
                                                                          'correctly_answered'] /
                                                                      test['total_questions']) *
                                                                  100,
                                                              size: Sizes.small,
                                                            );
                                                          case 'GRADE':
                                                            return Text(
                                                              GradingSystem(
                                                                      score: test[
                                                                              'correctly_answered'] /
                                                                          test[
                                                                              'total_questions'],
                                                                      level: widget
                                                                          .course.packageCode!)
                                                                  .grade,
                                                              style: TextStyle(
                                                                color: selected == test
                                                                    ? Colors.white
                                                                    : Color(0xFF2A9CEA),
                                                                fontSize: 11.0,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            );
                                                          default:
                                                            return PercentageSnippet(
                                                              correctlyAnswered:
                                                                  test['correctly_answered'],
                                                              totalQuestions:
                                                                  test['total_questions'],
                                                              isSelected: selected == test,
                                                            );
                                                        }
                                                      })(),
                                                      onTap: () {
                                                        handleSelection(test);
                                                      },
                                                ),
                                              ),
                                              if(selected == test)
                                              for(int i= 0; i< test["test"].length; i++)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                                  child: MultiPurposeCourseCardCompare(
                                                    hasSmallHeading: true,
                                                    title: "${i + 1}. ${test["test"][i].testName}",
                                                    subTitle: '',
                                                    isActive: false,
                                                    hasProgressed: false,
                                                    darkenActiveBackgroundOnPress: false,
                                                    height: 0,
                                                    rightWidget: (() {
                                                      switch (rightWidgetState.toUpperCase()) {
                                                        case 'TOTAL_POINTS':
                                                          return FractionSnippet(
                                                            correctlyAnswered: test["test"][i].testScore,
                                                            totalQuestions:  test["test"][i].totalQuestions,
                                                            isSelected: false,
                                                          );
                                                        case 'STRENGTH':
                                                          return AdeoSignalStrengthIndicator(
                                                            strength: (test["test"][i].testScore /
                                                                test["test"][i].totalQuestions) *
                                                                100,
                                                            size: Sizes.small,
                                                          );
                                                        case 'GRADE':
                                                          return Text(
                                                            GradingSystem(
                                                                score: test["test"][i].testScore,
                                                                level:
                                                                widget.course.packageCode!)
                                                                .grade,
                                                            style: TextStyle(
                                                              color: Color(0xFF2A9CEA),
                                                              fontSize: 11.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          );
                                                        default:
                                                          return PercentageSnippet(
                                                            correctlyAnswered: test["test"][i].testScore,
                                                            totalQuestions:  test["test"][i].totalQuestions,
                                                            isSelected: false,
                                                          );
                                                      }
                                                    })(),
                                                    onTap: () {
                                                      // handleSelection(test);
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 10,)
                                        ],
                                      ),
                                )
                                .toList(),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
            if(selected == null)
            Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
              ),
              child: selected == null
                  ? AdeoTextButton(
                      label: 'Return',
                      fontSize: 16,
                      color: kAdeoBlue2,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : AdeoTextButton(
                      label: 'Revise',
                      fontSize: 16,
                      color: kAdeoBlue2,
                      onPressed: () {},
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

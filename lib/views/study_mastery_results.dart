import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/learn_attention_topics.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StudyMasteryResults extends StatefulWidget {
  StudyMasteryResults({
    Key? key,
    required this.test,
    required this.controller,
  }) : super(key: key);

  TestTaken test;
  MasteryController controller;

  @override
  _StudyMasteryResultsState createState() => _StudyMasteryResultsState();
}

class _StudyMasteryResultsState extends State<StudyMasteryResults> {
  static const TextStyle _topLabelStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFF969696),
  );
  static const TextStyle _topMainTextStyle = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    color: kAdeoGray2,
  );

  int selectedTableRowIndex = 0;

  handleTableSelectChanged(index) {
    setState(() {
      selectedTableRowIndex = index;
    });
  }

  List<TopicAnalysis> topics = [];
  late MasteryController controller;
  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    print("test id = ${widget.test.id}");
    TestController().topicsAnalysis(widget.test).then((mapList) {
      mapList.keys.forEach((key) {
        List<TestAnswer> answers = mapList[key]!;
        topics.add(TopicAnalysis(key, answers));
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => MainHomePage(
                              controller.user,
                              index: 1,
                            ),
                          ), (route) {
                        return false;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircularProgressIndicatorWrapper(
                        subCenterText: 'avg. score',
                        progress: widget.test.score!,
                        progressColor: kAdeoGreen,
                        size: ProgressIndicatorSize.large,
                        resultType: true,
                      ),
                      SizedBox(height: 12.0),
                      Text('Score', style: _topLabelStyle)
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                          getDurationTime(
                              Duration(seconds: widget.test.usedTime ?? 0)),
                          style: _topMainTextStyle),
                      Text('Time Taken', style: _topLabelStyle)
                    ],
                  ),
                  Column(
                    children: [
                      Text("${widget.test.numberOfQuestions}",
                          style: _topMainTextStyle),
                      Text('Questions', style: _topLabelStyle)
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingTextStyle: kSixteenPointWhiteText.copyWith(
                    color: kDefaultBlack,
                  ),
                  dataTextStyle: kTableBodyMainText.copyWith(
                    color: kDefaultBlack,
                  ),
                  dataRowHeight: 64.0,
                  dividerThickness: 0,
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(label: Text('Topic')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Performance')),
                  ],
                  rows: [
                    for (int i = 0; i < topics.length; i++)
                      makeDataRow(
                        cell1Text: topics[i].name,
                        cell2Text: "${topics[i].time}s",
                        progressColor: kCourseColors[i % kCourseColors.length]
                            ['progress']!,
                        progress: topics[i].performace,
                        selected: selectedTableRowIndex == i,
                        onSelectChanged: (selected) {
                          handleTableSelectChanged(i);
                        },
                      ),
                  ],
                ),
              ),
            ),
            Container(height: 6.0, color: Colors.white),
            Container(
              height: 52.0,
              color: Color(0xFFF6F6F6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Button(
                      label: 'review',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(width: 1.0, color: kNavigationTopBorderColor),
                  Expanded(
                    child: Button(
                        label: 'Continue',
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LearnAttentionTopics();
                          }));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        SizedBox(
          width: 100,
          child: Text(
            cell1Text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? Colors.white : kDefaultBlack,
            ),
          ),
        ),
      ),
      DataCell(
        Text(
          cell2Text,
          style: TextStyle(
            color: selected ? Colors.white : kDefaultBlack,
          ),
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

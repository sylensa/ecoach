import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/note_view.dart';
import 'package:ecoach/views/notes_topics.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ResultsView extends StatefulWidget {
  ResultsView(this.user, this.course,
      {Key? key, required this.test, this.diagnostic = false})
      : super(key: key);
  final User user;
  final Course course;
  TestTaken test;
  bool diagnostic;

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
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

  @override
  void initState() {
    super.initState();

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
                              widget.user,
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
                  Button(
                    label: 'review',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(width: 1.0, color: kNavigationTopBorderColor),
                  if (!widget.diagnostic)
                    Button(
                      label: 'revise',
                      onPressed: () async {
                        int topicId =
                            topics[selectedTableRowIndex].answers[0].topicId!;
                        Topic? topic = await TopicDB().getTopicById(topicId);

                        if (topic != null) {
                          print(
                              "_______________________________________________________");
                          print(topic.notes);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return NoteView(widget.user, topic);
                              });
                        } else {
                          showFeedback(context, "No notes available");
                        }
                      },
                    ),
                  if (widget.diagnostic)
                    Button(
                      label: 'Purchase',
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                StorePage(widget.user),
                          ),
                        );
                      },
                    ),
                  Container(width: 1.0, color: kNavigationTopBorderColor),
                  Button(
                    label: 'new test',
                    onPressed: () {
                      Navigator.popUntil(context,
                          ModalRoute.withName(CourseDetailsPage.routeName));
                    },
                  ),
                ],
              ),
            )
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

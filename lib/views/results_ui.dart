import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:ecoach/widgets/tab_bar_views/results_page_questions_view.dart';
import 'package:ecoach/widgets/tab_bar_views/results_page_topics_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    fontSize: 14.0,
    color: Color(0xFF969696),
  );
  static const TextStyle _topMainTextStyle = TextStyle(
    fontFamily: 'Helvetica Rounded',
    fontSize: 35.0,
    color: kAdeoGray2,
  );

  List<TopicAnalysis> topics = [];
  List topicsPlaceholder = [
    {
      'name': 'Density',
      'rating': 'Excellent',
      'total_questions': 10,
      'correctly_answered': 10,
    },
    {
      'name': 'Volume',
      'rating': 'Good performance',
      'total_questions': 10,
      'correctly_answered': 8,
    },
    {
      'name': 'Nervous System',
      'rating': 'More room for improvement',
      'total_questions': 10,
      'correctly_answered': 5,
    },
    {
      'name': 'Cells',
      'rating': 'Good performance',
      'total_questions': 10,
      'correctly_answered': 8,
    },
    {
      'name': 'Density',
      'rating': 'Excellent',
      'total_questions': 10,
      'correctly_answered': 10,
    },
    {
      'name': 'Volume',
      'rating': 'Good performance',
      'total_questions': 10,
      'correctly_answered': 8,
    },
    {
      'name': 'Nervous System',
      'rating': 'More room for improvement',
      'total_questions': 10,
      'correctly_answered': 5,
    },
    {
      'name': 'Cells',
      'rating': 'Good performance',
      'total_questions': 10,
      'correctly_answered': 8,
    },
  ];

  @override
  void initState() {
    super.initState();

    // print("test id = ${widget.test.id}");
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPageBackgroundGray,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 31.0,
                bottom: 21.0,
                left: 24,
                right: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.test.score!.ceil().toString() + '%',
                        style: _topMainTextStyle,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Score',
                        style: _topLabelStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        getDurationTime(
                          Duration(seconds: widget.test.usedTime ?? 0),
                        ),
                        style: _topMainTextStyle,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Time Taken',
                        style: _topLabelStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${widget.test.numberOfQuestions}",
                        style: _topMainTextStyle,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Questions',
                        style: _topLabelStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              thickness: 3.0,
              color: Colors.white,
            ),
            SizedBox(height: 25),
            AdeoTabControl(
              variant: 'default',
              tabs: ['topics', 'questions'],
              tabPages: [
                TopicsTabPage(
                  topics: topicsPlaceholder,
                  diagnostic: widget.diagnostic,
                  user: widget.user,
                ),
                QuestionsTabPage(
                  questions: topicsPlaceholder,
                  diagnostic: widget.diagnostic,
                  user: widget.user,
                ),
              ],
            ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: DataTable(
            //       headingTextStyle: kSixteenPointWhiteText.copyWith(
            //         color: kDefaultBlack,
            //       ),
            //       dataTextStyle: kTableBodyMainText.copyWith(
            //         color: kDefaultBlack,
            //       ),
            //       dataRowHeight: 64.0,
            //       dividerThickness: 0,
            //       showCheckboxColumn: false,
            //       columns: [
            //         DataColumn(label: Text('Topic')),
            //         DataColumn(label: Text('Correct')),
            //         DataColumn(label: Text('Performance')),
            //       ],
            //       rows: [
            //         for (int i = 0; i < topics.length; i++)
            //           makeDataRow(
            //             cell1Text: topics[i].name,
            //             cell2Text: "${topics[i].time}",
            //             progressColor: kCourseColors[i % kCourseColors.length]
            //                 ['progress']!,
            //             progress: topics[i].performace,
            //             selected: selectedTableRowIndex == i,
            //             onSelectChanged: (selected) {
            //               handleTableSelectChanged(i);
            //             },
            //           ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(height: 6.0, color: Colors.white),
            // Container(
            //   height: 52.0,
            //   color: Color(0xFFF6F6F6),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Button(
            //         label: 'review',
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //       ),
            //       Container(width: 1.0, color: kNavigationTopBorderColor),
            //       if (!widget.diagnostic)
            //         Button(
            //           label: 'revise',
            //           onPressed: () async {
            //             int topicId =
            //                 topics[selectedTableRowIndex].answers[0].topicId!;
            //             Topic? topic = await TopicDB().getTopicById(topicId);

            //             if (topic != null) {
            //               print(
            //                   "_______________________________________________________");
            //               print(topic.notes);
            //               showDialog(
            //                   context: context,
            //                   builder: (context) {
            //                     return NoteView(widget.user, topic);
            //                   });
            //             } else {
            //               showFeedback(context, "No notes available");
            //             }
            //           },
            //         ),
            //       if (widget.diagnostic)
            //         Button(
            //           label: 'Purchase',
            //           onPressed: () {
            //             Navigator.push<void>(
            //               context,
            //               MaterialPageRoute<void>(
            //                 builder: (BuildContext context) =>
            //                     StorePage(widget.user),
            //               ),
            //             );
            //           },
            //         ),
            //       Container(width: 1.0, color: kNavigationTopBorderColor),
            //       if (!widget.diagnostic)
            //         Button(
            //           label: 'new test',
            //           onPressed: () {
            //             Navigator.popUntil(context,
            //                 ModalRoute.withName(CourseDetailsPage.routeName));
            //           },
            //         ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}


// DataRow makeDataRow({
//   required String cell1Text,
//   required String cell2Text,
//   required double progress,
//   required Color progressColor,
//   bool selected: false,
//   required onSelectChanged,
// }) {
//   Color getColor(Set<MaterialState> states) {
//     const Set<MaterialState> interactiveStates = <MaterialState>{
//       MaterialState.selected,
//       MaterialState.focused,
//     };
//     if (states.any(interactiveStates.contains)) {
//       return kAnalysisScreenActiveColor;
//     }
//     return Colors.transparent;
//   }

//   return DataRow(
//     selected: selected,
//     onSelectChanged: onSelectChanged,
//     color: MaterialStateProperty.resolveWith(getColor),
//     cells: [
//       DataCell(
//         SizedBox(
//           width: 100,
//           child: Text(
//             cell1Text,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: selected ? Colors.white : kDefaultBlack,
//             ),
//           ),
//         ),
//       ),
//       DataCell(
//         Text(
//           cell2Text,
//           style: TextStyle(
//             color: selected ? Colors.white : kDefaultBlack,
//           ),
//         ),
//       ),
//       DataCell(
//         Center(
//           widthFactor: 1,
//           child: LinearPercentIndicatorWrapper(
//             percent: progress,
//             progressColor: progressColor,
//             backgroundColor: Color(0xFF363636),
//             label: (progress * 100).toString(),
//           ),
//         ),
//       ),
//     ],
//   );
// }

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course_analysis.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/analysis_info_snippet_card.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AllTabBarView extends StatefulWidget {
  AllTabBarView(this.item, {Key? key}) : super(key: key);
  SubscriptionItem item;

  @override
  _AllTabBarViewState createState() => _AllTabBarViewState();
}

class _AllTabBarViewState extends State<AllTabBarView> {
  List<AnalysisInfoSnippet> infoList = [];
  int selectedTableRowIndex = 0;

  handleSelectChanged(index) {
    setState(() {
      selectedTableRowIndex = index;
    });
  }

  List<TestTaken> testsTaken = [];
  CourseAnalytic? analytic;

  @override
  void initState() {
    super.initState();
    print("all tabs called ${widget.item.tag}");
    TestController().getTestTaken(widget.item.tag!).then((tests) {
      setState(() {
        testsTaken = tests;
      });
    });

    ApiCall<CourseAnalytic> apiCall = new ApiCall<CourseAnalytic>(
        AppUrl.analysis + '/' + widget.item.tag!,
        isList: false, create: (dataItem) {
      return CourseAnalytic();
    }, onMessage: (message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });

    var futureAnalytic = apiCall.get(context);

    infoList = [
      AnalysisInfoSnippet(
        bodyText: '19th',
        footerText: 'rank',
        performance: '3',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '209',
        footerText: 'points',
        performance: '3',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '26.78',
        footerText: 'mastery',
        performance: '3',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '1:02',
        footerText: 'speed',
        performance: '3',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '12',
        footerText: 'other',
        performance: '4',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Today',
                    style: kSixteenPointWhiteText,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 12.0),
            Container(
              height: 140.0,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: infoList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16.0 : 12.0,
                      right: index == infoList.length - 1 ? 16.0 : 0,
                    ),
                    child: AnalysisInfoSnippetCard(info: infoList[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 32.0),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0x88FFFFFF),
                    width: 0.5,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: kSixteenPointWhiteText,
                dataTextStyle: kTableBodyMainText,
                dataRowHeight: 64.0,
                dividerThickness: 0,
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Score')),
                ],
                rows: [
                  for (int i = 0; i < testsTaken.length; i++)
                    makeDataRow(
                      cell1Text1: getTime(testsTaken[i].datetime!),
                      cell1Text2: getDateOnly(testsTaken[i].datetime!),
                      cell2Text1: testsTaken[i].testname!,
                      cell2Text2: testsTaken[i].testType!,
                      cell3Text: "${testsTaken[i].testTime!}",
                      progressColor: kCourseColors[i % kCourseColors.length]
                          ['progress']!,
                      progress:
                          testsTaken[i].correct! / testsTaken[i].totalQuestions,
                      selected: selectedTableRowIndex == 0,
                      onSelectChanged: handleSelectChanged(0),
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
  required String cell1Text1,
  required String cell1Text2,
  required String cell2Text1,
  required String cell2Text2,
  required String cell3Text,
  required double progress,
  required Color progressColor,
  bool selected: false,
  required onSelectChanged,
}) {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      // MaterialState.pressed,
      MaterialState.selected,
      // MaterialState.hovered,
      // MaterialState.focused,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(cell1Text1),
            Text(cell1Text2, style: kTableBodySubText)
          ],
        ),
      ),
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cell2Text1),
            Text(cell2Text2, style: kTableBodySubText)
          ],
        ),
      ),
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(cell3Text)],
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

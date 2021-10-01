import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/analysis_info_snippet_card.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
import 'package:flutter/material.dart';

class AllTabBarView extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
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
                  makeDataRow(
                    cell1Text1: '16:04',
                    cell1Text2: '07/09/21',
                    cell2Text1: 'Term 1',
                    cell2Text2: 'exam',
                    cell3Text: '3.2s',
                    progressColor: kCourseColors[0]['progress']!,
                    progress: 0.4,
                    selected: selectedTableRowIndex == 0,
                    onSelectChanged: handleSelectChanged(0),
                  ),
                  makeDataRow(
                    cell1Text1: '16:04',
                    cell1Text2: '07/09/21',
                    cell2Text1: 'Pressure',
                    cell2Text2: 'topic',
                    cell3Text: '4.2s',
                    progressColor: kCourseColors[2]['background']!,
                    progress: 0.8,
                    selected: selectedTableRowIndex == 1,
                    onSelectChanged: handleSelectChanged(1),
                  ),
                  makeDataRow(
                    cell1Text1: '16:04',
                    cell1Text2: '07/09/21',
                    cell2Text1: 'Diagnostic',
                    cell2Text2: 'exam',
                    cell3Text: '5.2s',
                    progressColor: kCourseColors[7]['progress']!,
                    progress: 1,
                    selected: selectedTableRowIndex == 2,
                    onSelectChanged: handleSelectChanged(2),
                  ),
                  makeDataRow(
                    cell1Text1: '16:04',
                    cell1Text2: '07/09/21',
                    cell2Text1: 'Mixed Topics',
                    cell2Text2: 'exam',
                    cell3Text: '15.2s',
                    progressColor: kCourseColors[7]['background']!,
                    progress: 0.2,
                    selected: selectedTableRowIndex == 3,
                    onSelectChanged: handleSelectChanged(3),
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cell1Text1),
              Text(cell1Text2, style: kTableBodySubText)
            ],
          ),
        ),
      ),
      DataCell(
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cell2Text1),
              Text(cell2Text2, style: kTableBodySubText)
            ],
          ),
        ),
      ),
      DataCell(
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(cell3Text)],
          ),
        ),
      ),
      DataCell(
        Expanded(
          child: Center(
            widthFactor: 1,
            child: LinearPercentIndicatorWrapper(
              percent: progress,
              progressColor: progressColor,
              backgroundColor: Color(0xFF363636),
              label: (progress * 100).toString(),
            ),
          ),
        ),
      ),
    ],
  );
}

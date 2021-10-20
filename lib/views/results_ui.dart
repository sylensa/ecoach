import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';
import 'package:flutter/material.dart';

class ResultsView extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                        progress: 85,
                        progressColor: kAdeoGreen,
                        size: ProgressIndicatorSize.large,
                      ),
                      SizedBox(height: 12.0),
                      Text('Score', style: _topLabelStyle)
                    ],
                  ),
                  Column(
                    children: [
                      Text('01:30', style: _topMainTextStyle),
                      Text('Time Taken', style: _topLabelStyle)
                    ],
                  ),
                  Column(
                    children: [
                      Text('40', style: _topMainTextStyle),
                      Text('Questions', style: _topLabelStyle)
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                    makeDataRow(
                      cell1Text: 'Density',
                      cell2Text: '5.2s',
                      progressColor: kCourseColors[0]['progress']!,
                      progress: 0.4,
                      selected: selectedTableRowIndex == 0,
                      onSelectChanged: (selected) {
                        handleTableSelectChanged(0);
                      },
                    ),
                    makeDataRow(
                      cell1Text: 'Photosynthesis',
                      cell2Text: '5.2s',
                      progressColor: kCourseColors[4]['background']!,
                      progress: 1.0,
                      selected: selectedTableRowIndex == 1,
                      onSelectChanged: (selected) {
                        handleTableSelectChanged(1);
                      },
                    ),
                    makeDataRow(
                      cell1Text: 'Pollination',
                      cell2Text: '5.2s',
                      progressColor: kCourseColors[2]['background']!,
                      progress: 0.8,
                      selected: selectedTableRowIndex == 2,
                      onSelectChanged: (selected) {
                        handleTableSelectChanged(2);
                      },
                    ),
                    makeDataRow(
                      cell1Text: 'Valency',
                      cell2Text: '5.2s',
                      progressColor: kCourseColors[6]['background']!,
                      progress: 0.2,
                      selected: selectedTableRowIndex == 3,
                      onSelectChanged: (selected) {
                        handleTableSelectChanged(3);
                      },
                    ),
                    makeDataRow(
                      cell1Text: 'Viscosity',
                      cell2Text: '5.2s',
                      progressColor: kCourseColors[6]['background']!,
                      progress: 0.3,
                      selected: selectedTableRowIndex == 4,
                      onSelectChanged: (selected) {
                        handleTableSelectChanged(4);
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
                    onPressed: () {},
                  ),
                  Container(width: 1.0, color: kNavigationTopBorderColor),
                  Button(
                    label: 'revise',
                    onPressed: () {},
                  ),
                  Container(width: 1.0, color: kNavigationTopBorderColor),
                  Button(
                    label: 'new test',
                    onPressed: () {},
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

class Button extends StatelessWidget {
  const Button({
    required this.label,
    this.onPressed,
  });

  final String label;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontSize: 20.0),
        ),
        height: 48.0,
        textColor: Color(0xFFA2A2A2),
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
        Expanded(
          child: Text(
            cell1Text,
            style: TextStyle(
              color: selected ? Colors.white : kDefaultBlack,
            ),
          ),
        ),
      ),
      DataCell(
        Expanded(
          child: Text(
            cell2Text,
            style: TextStyle(
              color: selected ? Colors.white : kDefaultBlack,
            ),
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

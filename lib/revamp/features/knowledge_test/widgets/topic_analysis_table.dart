// import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:flutter/material.dart';

class AnalyticsTable extends StatefulWidget {
  const AnalyticsTable({
    Key? key,
    required this.testsTaken,
  }) : super(key: key);
  final List<TestTaken> testsTaken;

  @override
  State<AnalyticsTable> createState() => _AnalyticsTableState();
}

class _AnalyticsTableState extends State<AnalyticsTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 0,
      headingRowHeight: 30,
      minWidth: 200,
      headingTextStyle: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      dataTextStyle: TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
      columns: [
        DataColumn2(
          label: Text('Topic'),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Outcome'),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Strength'),
          size: ColumnSize.S,
        ),
      ],
      rows: List<DataRow>.generate(
        widget.testsTaken.length,
        (index) => DataRow(
          cells: [
            DataCell(Text(widget.testsTaken[index].testname!.toCapitalized())),
            DataCell(Center(
              child: Text(
                "${widget.testsTaken[index].correct!}/${widget.testsTaken[index].totalQuestions}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            DataCell(
              AdeoSignalStrengthIndicator(
                strength: widget.testsTaken[index].score!,
                size: Sizes.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

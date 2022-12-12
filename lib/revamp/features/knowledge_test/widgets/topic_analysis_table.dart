
import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:flutter/material.dart';

class AnalyticsTable extends StatelessWidget {
  AnalyticsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 0,
      headingRowHeight: 48,
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
        5,
        (index) => DataRow(
          cells: [
            DataCell(Text('A' * (10 - index % 10))),
            DataCell(Text('B' * (10 - (index + 5) % 10))),
            DataCell(Text('C' * (15 - (index + 5) % 10))),
          ],
        ),
      ),
    );
  }
}

import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/buttons/arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MarathonRanking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArrowButton(
                  arrow: 'assets/icons/arrows/chevron_left_blue.png',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Row(
                  children: [
                    AdeoOutlinedButton(
                      label: 'Exit',
                      size: Sizes.small,
                      color: kAdeoOrange,
                      borderRadius: 5,
                      fontSize: 14,
                      onPressed: () {},
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
            Text(
              'Rankings',
              style: TextStyle(
                fontSize: 41,
                fontFamily: 'Hamelin',
                color: kAdeoBlue,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 120),
                    DataTable(
                      columnSpacing: 16,
                      headingTextStyle: kSixteenPointWhiteText,
                      dataTextStyle: TextStyle(
                        fontSize: 15,
                        color: kAdeoBlueAccent,
                      ),
                      dividerThickness: 2,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Mastery')),
                        DataColumn(label: Text('Time Taken')),
                      ],
                      rows: [
                        for (int i = 0; i < 12; i++)
                          makeDataRow(
                            cell1Text: '1. Raymond Reddington',
                            cell2Text: '65.43%',
                            cell3Text: '00 : 02 : 25 : 18',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
              ),
              child: AdeoTextButton(
                label: 'Next',
                fontSize: 20,
                color: Colors.white,
                background: kAdeoBlue,
                onPressed: () {},
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
  required String cell3Text,
}) {
  return DataRow(
    cells: [
      DataCell(Text(cell1Text)),
      DataCell(Text(cell2Text)),
      DataCell(Text(cell3Text)),
    ],
  );
}

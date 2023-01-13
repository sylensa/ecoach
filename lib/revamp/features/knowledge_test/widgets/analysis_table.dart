import 'package:data_table_2/data_table_2.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsTable extends StatefulWidget {
  const AnalyticsTable({
    Key? key,
    required this.testsTaken,
    required this.testCategory,
    this.user,
  }) : super(key: key);
  final List<TestTaken> testsTaken;
  final TestCategory testCategory;
  final User? user;

  @override
  State<AnalyticsTable> createState() => _AnalyticsTableState();
}

class _AnalyticsTableState extends State<AnalyticsTable> {
  late int totalQuestionsForTestTaken;

  getAll({int? topicId, required TestTaken testTaken}) async {
    reviewQuestionsBack.clear();
    List<Question> questions = [];

    questions = await TestController()
        .getAllQuestions(testTaken, topicId: topicId != null ? topicId : null);

    for (int i = 0; i < questions.length; i++) {
      reviewQuestionsBack.add(questions[i]);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("testCategory: ${widget.testCategory}");
    return widget.testCategory != TestCategory.EXAM
        ? DataTable2(
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
                  DataCell(
                      Text(widget.testsTaken[index].testname!.toCapitalized())),
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
          )
        : DataTable2(
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
                label: Text('Date'),
                size: ColumnSize.M,
                fixedWidth: 80
              ),
              DataColumn2(
                label: Text('Time'),
                size: ColumnSize.M,
                fixedWidth: 56
              ),
              DataColumn2(
                label: Text('Outcome'),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Action'),
                ),
                size: ColumnSize.S,
              ),
            ],
            rows: List<DataRow>.generate(
              widget.testsTaken.length,
              (index) {
                DateTime _dateTime = DateTime.parse(
                    widget.testsTaken[index].datetime!.toString());
                final _dateFormat = DateFormat('dd.MM.yyyy');

                String _testDate = _dateFormat.format(_dateTime);
                String _testTime = DateFormat.Hm().format(_dateTime);
                totalQuestionsForTestTaken = widget.testsTaken[index].correct! +
                    widget.testsTaken[index].wrong!;

                return DataRow(
                  cells: [
                    DataCell(Text("${_testDate}")),
                    DataCell(
                      Text("${_testTime}"),
                    ),
                    DataCell(Center(
                      child: Text(
                        "${widget.testsTaken[index].correct!}/${totalQuestionsForTestTaken}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Review",
                        ),
                      ),
                      onTap: (() async {
                        if (widget.user != null) {
                          await getAll(testTaken: widget.testsTaken[index]);

                          await goTo(
                            context,
                            QuizReviewPage(
                              testTaken: widget.testsTaken[index],
                              user: widget.user!,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                );
              },
            ),
          );
  }
}

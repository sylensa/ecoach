import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/quiz_db.dart';
import 'package:ecoach/providers/subscription_item_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/more_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BundleDownload extends StatefulWidget {
  const BundleDownload(this.user, {Key? key, required this.bundle})
      : super(key: key);

  final Subscription bundle;
  final User user;

  @override
  _BundleDownloadState createState() => _BundleDownloadState();
}

class _BundleDownloadState extends State<BundleDownload> {
  List<Map<String, dynamic>> courseList = [];
  List<Map<String, dynamic>> selectedTableRows = [];
  late String subName;
  @override
  void initState() {
    super.initState();

    subName = widget.bundle.name!;
    subName =
        subName.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();

    print(widget.bundle.subscriptionItems);
    SubscriptionItemDB().subscriptionItems(widget.bundle.planId!).then((items) {
      setState(() {
        for (int i = 0; i < items.length; i++) {
          courseList.add({
            'id': items[i].id,
            'time': {'date': items[i].dateOnly, 'time': items[i].timeOnly},
            'courseName': items[i].name,
            'downloadStatus': items[i].downloadStatus
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * .35,
              color: kAdeoGray,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          // child: Image.asset('assets/icons/arrows/arrow_right.png', fit: BoxFit.fill),
                          child: Icon(
                            Icons.chevron_left,
                            size: 32.0,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.black12,
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          widget.bundle.timeLeft + ' left',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bundle.name!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'updated ${widget.bundle.updatedAgo}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: kDefaultBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: darken(kAdeoGray, 20),
                            checkboxTheme: CheckboxThemeData(
                              fillColor:
                                  MaterialStateProperty.resolveWith((states) {
                                const Set<MaterialState> interactiveStates =
                                    <MaterialState>{
                                  MaterialState.selected,
                                  MaterialState.focused,
                                  MaterialState.pressed,
                                };
                                if (states.any(interactiveStates.contains))
                                  return Colors.green;
                              }),
                              checkColor:
                                  MaterialStateProperty.resolveWith((states) {
                                const Set<MaterialState> interactiveStates =
                                    <MaterialState>{
                                  MaterialState.selected,
                                  MaterialState.focused
                                };
                                if (states.any(interactiveStates.contains))
                                  return Colors.white;
                              }),
                            ),
                          ),
                          child: DataTable(
                            headingTextStyle: kSixteenPointWhiteText.copyWith(
                              color: kDefaultBlack,
                            ),
                            dataTextStyle: TextStyle(
                              color: kDefaultBlack,
                              fontSize: 16.0,
                            ),
                            dataRowHeight: 64.0,
                            dividerThickness: 0,
                            headingRowColor:
                                MaterialStateProperty.all(kAdeoGray),
                            columns: [
                              DataColumn(label: Text('Time')),
                              DataColumn(label: Text('Course')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: [
                              for (int i = 0; i < courseList.length; i++)
                                makeDataRow(
                                  cell1: courseList[i]['time'],
                                  cell2: courseList[i]['courseName']
                                      .toUpperCase()
                                      .replaceFirst(subName.toUpperCase(), ""),
                                  cell3: courseList[i]['downloadStatus'],
                                  selected:
                                      selectedTableRows.contains(courseList[i]),
                                  onSelectChanged: (isSelected) {
                                    final Map<String, dynamic> course =
                                        courseList[i];

                                    setState(() {
                                      final bool isAdding =
                                          isSelected != null && isSelected;

                                      isAdding
                                          ? selectedTableRows.add(course)
                                          : selectedTableRows.remove(course);
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),
            ),
            if (selectedTableRows.length > 0)
              GestureDetector(
                onTap: () async {
                  for (int i = 0; i < selectedTableRows.length; i++) {
                    print(
                        "downloading ${selectedTableRows[i]['courseName']}\n data");
                    showDownloadDialog(context,
                        message:
                            "downloading..... ${selectedTableRows[i]['courseName']} data",
                        current: i,
                        total: selectedTableRows.length);
                    SubscriptionItem? subscriptionItem =
                        await getSubscriptionItem(selectedTableRows[i]['id']!);
                    print(subscriptionItem);
                    if (subscriptionItem != null) {
                      await CourseDB().insert(subscriptionItem.course!);
                      await QuizDB().insertAll(subscriptionItem.quizzes!);
                    }

                    Navigator.pop(context);
                  }
                  setState(() {});
                },
                child: Container(
                  height: 60.0,
                  color: kAdeoGreen,
                  child: Center(
                    child: Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  getSubscriptionItem(id) async {
    return await ApiCall(AppUrl.subscriptionItem + '/$id?', isList: false,
        create: (json) {
      return SubscriptionItem.fromJson(json);
    }).get(context);
  }
}

DataRow makeDataRow({
  required Map cell1,
  required String cell2,
  required String cell3,
  bool selected: false,
  required onSelectChanged,
}) {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
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
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cell1['time']),
              Text(
                cell1['date'],
                style: kTableBodySubText.copyWith(
                  color: kBlack38,
                ),
              ),
            ],
          ),
        ),
      ),
      DataCell(SizedBox(
        width: 100,
        child: Text(
          cell2,
          softWrap: true,
        ),
      )),
      DataCell(Text(cell3)),
    ],
  );
}

import 'dart:convert';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/package_downloader.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/more_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/src/provider.dart';
import 'package:wakelock/wakelock.dart';

class BundleDownload extends StatefulWidget {
  BundleDownload(this.user,
      {Key? key, required this.bundle, required this.controller})
      : super(key: key);

  final Subscription bundle;
  User user;
  MainController controller;

  @override
  _BundleDownloadState createState() => _BundleDownloadState();
}

class _BundleDownloadState extends State<BundleDownload> {
  List<SubscriptionItem> selectedTableRows = [];
  List<SubscriptionItem> items = [];

  late String subName;
  @override
  void initState() {
    super.initState();

    subName = widget.bundle.name!;
    subName =
        subName.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();

    print(widget.bundle.subscriptionItems);
    getSubscriptionItems();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  getSubscriptionItems() {
    SubscriptionItemDB().subscriptionItems(widget.bundle.planId!).then((items) {
      setState(() {
        this.items = items;
      });
    });
  }

  clearList() {
    items.clear();
    selectedTableRows.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canExit = true;
        if (context.read<DownloadUpdate>().isDownloading)
          await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Exist?",
                    style: TextStyle(color: Colors.black),
                  ),
                  content: Text(
                    "Are you sure you want to quit the download and leave?",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          canExit = true;
                          Navigator.pop(context);
                        },
                        child: Text("Yes")),
                    ElevatedButton(
                        onPressed: () {
                          canExit = false;
                          Navigator.pop(context);
                        },
                        child: Text("No"))
                  ],
                );
              });

        return Future.value(canExit);
      },
      child: SafeArea(
        child: Scaffold(
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
                              Navigator.maybePop(context);
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
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) {
                                    const Set<MaterialState> interactiveStates =
                                        <MaterialState>{
                                      MaterialState.selected,
                                      MaterialState.focused,
                                      MaterialState.pressed,
                                    };
                                    if (states.any(interactiveStates.contains))
                                      return Colors.green;
                                  }),
                                  checkColor: MaterialStateProperty.resolveWith(
                                      (states) {
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
                                showCheckboxColumn: true,
                                headingTextStyle:
                                    kSixteenPointWhiteText.copyWith(
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
                                  DataColumn(label: Text('Course')),
                                  DataColumn(label: Text('Quizzes')),
                                  DataColumn(label: Text('Questions')),
                                ],
                                rows: [
                                  for (int i = 0; i < items.length; i++)
                                    makeDataRow(
                                      cell1: items[i]
                                          .name!
                                          .toUpperCase()
                                          .replaceFirst(
                                              subName.toUpperCase(), ""),
                                      cell2: items[i].quizCount!,
                                      cell3: items[i].questionCount!,
                                      selected:
                                          selectedTableRows.contains(items[i]),
                                      onSelectChanged: (isSelected) {
                                        final SubscriptionItem course =
                                            items[i];

                                        setState(() {
                                          final bool isAdding =
                                              isSelected != null && isSelected;

                                          isAdding
                                              ? selectedTableRows.add(course)
                                              : selectedTableRows
                                                  .remove(course);
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
                if (context.watch<DownloadUpdate>().isDownloading)
                  Container(
                    child: Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 7),
                              child: Text(
                                context.read<DownloadUpdate>().message!,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.black),
                              )),
                          context.read<DownloadUpdate>().percentage > 0 &&
                                  context.read<DownloadUpdate>().percentage <
                                      100
                              ? LinearPercentIndicator(
                                  percent: context
                                          .read<DownloadUpdate>()
                                          .percentage /
                                      100,
                                )
                              : LinearProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: context
                                  .read<DownloadUpdate>()
                                  .doneDownloads
                                  .length,
                              itemBuilder: (context, index) {
                                print("showing courses downloaded");
                                return Text(
                                  context
                                      .read<DownloadUpdate>()
                                      .doneDownloads[index],
                                  style: TextStyle(color: Colors.black),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () async {
                    if (selectedTableRows.length < 1) {
                      return;
                    }
                    if (context.read<DownloadUpdate>().isDownloading) {
                      return;
                    }
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Download package",
                                style: TextStyle(color: Colors.black),
                              ),
                              content: Text(
                                "Are you sure you want to redownload this package?",
                                style: TextStyle(color: Colors.black),
                                softWrap: true,
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      widget.controller.downloadSubscription(
                                          selectedTableRows, (success) {
                                        UserPreferences()
                                            .getUser()
                                            .then((user) {
                                          setState(() {
                                            widget.user = user!;
                                          });
                                        });
                                        clearList();
                                        getSubscriptionItems();
                                      });
                                    },
                                    child: Text("Yes")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")),
                              ],
                            );
                          });
                    });
                  },
                  child: Container(
                    height: 60.0,
                    color: kAdeoGreen,
                    child: Center(
                      child: Text(
                        'Download Package',
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
        ),
      ),
    );
  }
}

DataRow makeDataRow({
  required String cell1,
  required int cell2,
  required int cell3,
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
          width: 120,
          child: Text(
            cell1,
            softWrap: true,
          ),
        ),
      ),
      DataCell(SizedBox(
        width: 40,
        child: Text(
          "$cell2",
        ),
      )),
      DataCell(Text("$cell3")),
    ],
  );
}

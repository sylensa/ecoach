import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/src/provider.dart';

class SavedDownload extends StatefulWidget {
  SavedDownload(this.user,
      {Key? key, required this.bundle, required this.controller})
      : super(key: key);

  final Subscription bundle;
  User user;
  MainController controller;

  @override
  _SavedDownloadState createState() => _SavedDownloadState();
}

class _SavedDownloadState extends State<SavedDownload> {
  List<SubscriptionItem> selectedTableRows = [];
  List<SubscriptionItem> items = [];
  bool isPressedDown = false;
  List que = [];
  late String subName;
  @override
  void initState() {
    super.initState();

    subName = widget.bundle.name!;
    subName = subName.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();

    print(widget.bundle.subscriptionItems);
    getSubscriptionItems();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  getSubscriptionItems() async{
    List<SubscriptionItem> sItem = await SubscriptionItemDB().subscriptionItems(widget.bundle.planId!);
    print("sItem:${sItem.length}");
    for(int t = 0; t < sItem.length; t++){
      List<Question> question = await TestController().getSavedTests(sItem[t].course!,limit: sItem[t].questionCount);
      print("object:${question.length}");
      if(question.length > 0){
        que.add(question.length);
        this.items.add( sItem[t]);
      }

    }
    setState(() {
      print("que:${que.length}");
      print("sItem:${sItem.length}");

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
        return Future.value(canExit);
      },
      child: Scaffold(
        backgroundColor: kPageBackgroundGray,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16.0),
                    height: MediaQuery.of(context).size.height * .3,
                    color: kAdeoGray,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              splashColor: Colors.red,
                              onTap: Feedback.wrapForTap(() async {
                                setState(() {
                                  isPressedDown = true;
                                });
                                await Future.delayed(
                                  Duration(milliseconds: 300),
                                );
                                Navigator.maybePop(context);
                                // setState(() {
                                //   isPressedDown = false;
                                // });
                              }, context),
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: isPressedDown
                                      ? Color(0x1A000000)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
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
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                // border: Border.all(
                                //   color: Colors.black12,
                                //   width: 2.0,
                                // ),
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
                                  fontSize: 30.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Saved Questions',
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
                      width: appWidth(context),
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
                                    MaterialStateProperty.resolveWith(
                                            (states) {
                                          const Set<MaterialState>
                                          interactiveStates = <MaterialState>{
                                            MaterialState.selected,
                                            MaterialState.focused,
                                            MaterialState.pressed,
                                          };
                                          if (states
                                              .any(interactiveStates.contains))
                                            return Colors.green;
                                        }),
                                    checkColor:
                                    MaterialStateProperty.resolveWith(
                                            (states) {
                                          const Set<MaterialState>
                                          interactiveStates = <MaterialState>{
                                            MaterialState.selected,
                                            MaterialState.focused
                                          };
                                          if (states
                                              .any(interactiveStates.contains))
                                            return Colors.white;
                                        }),
                                  ),
                                ),
                                child: DataTable(
                                  showCheckboxColumn: true,
                                  // horizontalMargin: 0,
                                  headingTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  dataTextStyle: TextStyle(
                                    color: kDefaultBlack,
                                    fontSize: 13.0,
                                  ),
                                  dataRowHeight: 64.0,
                                  dividerThickness: 0,
                                  headingRowColor: MaterialStateProperty.all(kAdeoGray),
                                  horizontalMargin: 35,
                                  columns: [
                                    DataColumn(label: Text('Course')),
                                    DataColumn(label: Text('No Questions')),
                                  ],
                                  rows: [
                                    for (int i = 0; i < items.length; i++)
                                      makeDataRow(
                                        context: context,
                                        cell1: items[i]
                                            .name!
                                            .toUpperCase()
                                            .replaceFirst(
                                            subName.toUpperCase(), ""),
                                        cell2: que.isNotEmpty ? que[i]! : 0,
                                        selected: selectedTableRows
                                            .contains(items[i]),
                                        onSelectChanged: (isSelected) {
                                          final SubscriptionItem course =
                                          items[i];

                                          setState(() {
                                            final bool isAdding =
                                                isSelected != null &&
                                                    isSelected;

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
                  if (selectedTableRows.length > 0)
                    GestureDetector(
                      onTap: () async {
                        if (selectedTableRows.length < 1) {
                          return;
                        }
                        if (context.read<DownloadUpdate>().isDownloading) {
                          return;
                        }
                        setState(
                              () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Saved questions",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Text(
                                    "Are you sure you want to remove these course from saved questions?",
                                    style: TextStyle(color: Colors.black),
                                    softWrap: true,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async{
                                        Navigator.pop(context);
                                        for(int  i =0; i < selectedTableRows.length; i++){
                                          await  QuestionDB().deleteSavedTestByCourseId(selectedTableRows[i].course!.id!);
                                          List<Question> ques = await  QuestionDB().getSavedTestQuestionsByType(selectedTableRows[i].course!.id!);
                                          que.clear();
                                          await  getSubscriptionItems();
                                          setState((){
                                            if(ques.isEmpty){
                                              selectedTableRows.clear();
                                              toastMessage("Course removed from saved questions");
                                            }else{
                                              print("Failed");
                                            }
                                          });
                                        }

                                      },
                                      child: Text("Yes"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 60.0,
                        color: kAdeoGreen,
                        child: Center(
                          child: Text(
                            'Remove Questions',
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

            ],
          ),
        ),
      ),
    );
  }
}

DataRow makeDataRow({
  required String cell1,
  required int cell2,
  bool selected: false,
  required onSelectChanged,
  required BuildContext context,
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
        Container(
         width: appWidth(context)/3,
          child: Text(
            cell1,
            softWrap: true,
          ),
        ),
      ),
      DataCell(
        Container(
          width: appWidth(context)/4,
          child: Text(
            "$cell2",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
            ),
          ),
        ),
      ),
    ],
  );
}

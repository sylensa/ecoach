import 'package:ecoach/database/treadmill_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/buttons/arrow_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:flutter/material.dart';

class TreadmillCompleted extends StatefulWidget {
  const TreadmillCompleted(
    this.user,
    this.course, {
    Key? key,
  }) : super(key: key);

  final User user;
  final Course course;

  @override
  State<TreadmillCompleted> createState() => _TreadmillCompletedState();
}

class _TreadmillCompletedState extends State<TreadmillCompleted> {
  List<Treadmill> treadmills = [];
  late bool showInPercentage;
  List selected = [];

  handleSelection(id) {
    setState(() {
      if (selected.contains(id))
        selected = selected.where((item) => item != id).toList();
      else
        selected = [...selected, id];
    });
  }

  @override
  void initState() {
    showInPercentage = false;

    TreadmillDB().completedTreadmills(widget.course).then((mList) {
      setState(() {
        treadmills = mList;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArrowButton(
                  arrow: 'assets/icons/arrows/chevron_left.png',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Text(
                    'Completed Runs',
                    style: TextStyle(
                      color: kAdeoLightTeal,
                      fontSize: 28,
                      fontFamily: 'Hamelin',
                    ),
                  ),
                ),
                Container(),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  PercentageSwitch(
                    showInPercentage: showInPercentage,
                    onChanged: (val) {
                      setState(() {
                        showInPercentage = val;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (int i = 0; i < treadmills.length; i++)
                              AnalysisCard(
                                variant: CardVariant.LIGHT,
                                correctlyAnswered: treadmills[i].totalCorrect!,
                                totalQuestions: treadmills[i].totalQuestions!,
                                activity: treadmills[i].title!,
                                activityType: treadmills[i].type!,
                                showInPercentage: showInPercentage,
                                isSelected: selected.contains(i + 1),
                                selectedBackground: kAdeoLightTeal,
                                metaData: ActivityMetaData(
                                  date: treadmills[i].date,
                                  time: treadmills[i].time,
                                  duration:
                                      '${Duration(seconds: treadmills[i].totalTime!).inMinutes}min:${Duration(seconds: treadmills[i].totalTime!).inSeconds % 60}sec',
                                ),
                                onTap: () {
                                  handleSelection(1);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: selected.length > 0
          ? Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
              ),
              child: AdeoTextButton(
                label: 'Next',
                fontSize: 20,
                background: kAdeoLightTeal,
                color: Colors.white,
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return CompareView(
                  //         user: widget.user,
                  //         course: widget.course,
                  //         operands: [],
                  //       );
                  //     },
                  //   ),
                  // );
                },
              ),
            )
          : Container(
              height: .1,
              color: Colors.transparent,
            ),
    );
  }
}
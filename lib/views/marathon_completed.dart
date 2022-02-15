import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/compare.dart';
import 'package:ecoach/widgets/buttons/adeo_gray_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/buttons/arrow_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:flutter/material.dart';

class MarathonCompleted extends StatefulWidget {
  const MarathonCompleted(
    this.user,
    this.course, {
    Key? key,
  }) : super(key: key);

  final User user;
  final Course course;

  @override
  State<MarathonCompleted> createState() => _MarathonCompletedState();
}

class _MarathonCompletedState extends State<MarathonCompleted> {
  List<Marathon> marathons = [];
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

    MarathonDB().completedMarathons(widget.course).then((mList) {
      setState(() {
        marathons = mList;
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
                    'Completed Marathons',
                    style: TextStyle(
                      color: kAdeoBlue,
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
                            for (int i = 0; i < marathons.length; i++)
                              AnalysisCard(
                                variant: CardVariant.LIGHT,
                                correctlyAnswered: marathons[i].totalCorrect!,
                                totalQuestions: marathons[i].totalQuestions!,
                                activity: marathons[i].title!,
                                activityType: marathons[i].type!,
                                showInPercentage: showInPercentage,
                                isSelected: selected.contains(i + 1),
                                metaData: ActivityMetaData(
                                  date: marathons[i].date,
                                  time: marathons[i].time,
                                  duration: '05min:20sec',
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
                background: kAdeoBlue,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CompareView(
                          user: widget.user,
                          course: widget.course,
                          operands: [],
                        );
                      },
                    ),
                  );
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

import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/database/treadmill_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/treadmill/treadmill_practise_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/buttons/arrow_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:flutter/material.dart';

import '../compare.dart';
import '../course_details.dart';

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
  //List<Treadmill> treadmills = [];
  List<TestTaken> treadmills = [];
  late bool showInPercentage;
  List selected = [];
  TreadmillController? _controller;

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
    print("${widget.course.name} ${widget.user.name}");

    // TreadmillDB().treadmills().then((mList) {
    //   setState(() {
    //     treadmills = mList;
    //   });
    // });
    TestTakenDB().courseTestsTaken(widget.course.id!).then((mList) {
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
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArrowButton(
                  arrow: 'assets/icons/arrows/chevron_left.png',
                  onPressed: () {
                    //  Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TreadmillWelcome(
                            course: widget.course,
                            user: widget.user,
                          );
                        },
                      ),
                    );
                  },
                ),
                const Expanded(
                  child: Text(
                    'Completed Runs',
                    style: TextStyle(
                      color: kAdeoLightTeal,
                      fontSize: 28,
                      fontFamily: 'Hamelin',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context,
                        ModalRoute.withName(CourseDetailsPage.routeName));
                  },
                  child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D3E50),
                        border: Border.all(
                          color: const Color(0xFFFF4949),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Exit',
                          style: TextStyle(
                            color: Color(0xFFFF4949),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 40),
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
                  const SizedBox(height: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (int i = 0; i < treadmills.length; i++)
                              AnalysisCard(
                                variant: CardVariant.LIGHT,
                                correctlyAnswered: treadmills[i].correct!,
                                totalQuestions: treadmills[i].totalQuestions,
                                activity: treadmills[i].testname!,
                                activityType: treadmills[i].testType != null
                                    ? treadmills[i]
                                        .testType!
                                        .split('.')[1]
                                        .toLowerCase()
                                    : ' ',
                                showInPercentage: showInPercentage,
                                isSelected: selected.contains(i + 1),
                                selectedBackground: kAdeoLightTeal,
                                metaData: ActivityMetaData(
                                  date: treadmills[i]
                                      .datetime
                                      .toString()
                                      .split(' ')[0],
                                  time: treadmills[i]
                                      .datetime
                                      .toString()
                                      .split(' ')[1]
                                      .split('.')[0],
                                  duration: '${treadmills[i].usedTimeText}',
                                ),
                                onTap: () {
                                  handleSelection(treadmills[i]);
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
              height: .1,
              color: Colors.transparent,
            )
          // Container(
          //     height: 60.0,
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //       boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
          //     ),
          //     child: AdeoTextButton(
          //       label: 'Next',
          //       fontSize: 20,
          //       background: kAdeoLightTeal,
          //       color: Colors.white,
          //       onPressed: () {
          //         // Navigator.push(
          //         //   context,
          //         //   MaterialPageRoute(
          //         //     builder: (context) {
          //         //       return CompareView(
          //         //         user: widget.user,
          //         //         course: widget.course,
          //         //         operands: [],
          //         //       );
          //         //     },
          //         //   ),
          //         // );
          //       },
          //     ),
          //   )

          : Container(
              height: .1,
              color: Colors.transparent,
            ),
    );
  }
}

import 'dart:math';

import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/cards/activity_course_card.dart';
import 'package:flutter/material.dart';

class OngoingActivitiesTab extends StatefulWidget {
  const OngoingActivitiesTab({Key? key, required this.ongoingActivities})
      : super(key: key);
  final List ongoingActivities;

  @override
  State<OngoingActivitiesTab> createState() => _OngoingActivitiesTabState();
}

class _OngoingActivitiesTabState extends State<OngoingActivitiesTab> {
  showTapActions(context) {
    double sheetHeight = 480;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            return Container(
              height: sheetHeight,
              padding: EdgeInsets.only(
                left: 40,
                right: 40,
                bottom: 18,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  )),
              child: Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(top: 48.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Marathon".trim().toUpperCase(),
                              style: TextStyle(
                                color: kAdeoBlue3,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "JHS 2 Ashanti Twi".trim(),
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: (() {}),
                              child: Container(
                                width: double.maxFinite,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: kAdeoGreen4,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            InkWell(
                              onTap: (() {}),
                              child: Container(
                                width: double.maxFinite,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: kAdeoGreen4,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "Retake",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: kAdeoGreen4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: (() {}),
                      child: Container(
                        width: double.maxFinite,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "End Activity",
                            style: TextStyle(
                              fontSize: 18,
                              color: kAdeoOrange2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                              color: kAdeoGray3,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  late Random random;
  late double _percentageCompleted;

  @override
  void initState() {
    super.initState();
    random = Random();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      padding: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: kPageBackgroundGray2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: widget.ongoingActivities.map(
            ((ongoingActivity) {
              bool isLastItem =
                  widget.ongoingActivities.indexOf(ongoingActivity) ==
                      widget.ongoingActivities.length - 1;
              _percentageCompleted = random.nextDouble() * 100;
              return Container(
                margin: EdgeInsets.only(
                  bottom: isLastItem ? 0 : 12,
                ),
                child: ActivityCourseCard(
                  activityType: CompletedActivityType.MARATHON,
                  courseTitle: 'JHS 2 Ashanti Twi',
                  iconUrl: 'assets/icons/courses/treadmill.png',
                  hasProgressIndicator: true,
                  percentageCompleted: _percentageCompleted,
                  onTap: () {
                    showTapActions(context);
                  },
                ),
              );
            }),
          ).toList(),
        ),
      )),
    );
  }
}

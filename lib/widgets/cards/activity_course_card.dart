import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class ActivityCourseCard extends StatelessWidget {
  const ActivityCourseCard({
    Key? key,
    this.onTap,
    required this.courseTitle,
    required this.activityType,
    required this.iconUrl,
    this.hasProgressIndicator = false,
    this.percentageCompleted = 0,
  }) : super(key: key);

  final Function()? onTap;
  final String courseTitle;
  final TestActivityType activityType;
  final String iconUrl;
  final double? percentageCompleted;
  final bool hasProgressIndicator;

  @override
  Widget build(BuildContext context) {
    double _percentageCompleted = percentageCompleted! / 100;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints:
            BoxConstraints(minHeight: hasProgressIndicator ? 160 : 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: hasProgressIndicator
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 240),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activityType.name.trim().toUpperCase(),
                        style: TextStyle(
                          color: kAdeoBlue3,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        courseTitle.trim(),
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!hasProgressIndicator && activityType.name.toString() != "AUTOPILOT")
                  Text(
                    "${(percentageCompleted! * 100).roundToDouble()}%",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (hasProgressIndicator || activityType.name.toString() == "AUTOPILOT")
                  Container(
                    width: 48.0,
                    height: 48.0,
                    child: Image.asset(
                      iconUrl,
                      fit: BoxFit.fill,
                    ),
                  )
              ],
            ),
            if (hasProgressIndicator)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      backgroundColor: Color(0xFFEBEBEB),
                      color: kAdeoGreen4,
                      minHeight: 7,
                      value: _percentageCompleted,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "${percentageCompleted!.round()}% Completed",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

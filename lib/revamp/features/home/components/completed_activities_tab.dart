import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/activity_course_card.dart';
import 'package:flutter/material.dart';

class CompletedActivitiesTab extends StatefulWidget {
  const CompletedActivitiesTab({Key? key, required this.completedActivities})
      : super(key: key);
  final List completedActivities;

  @override
  State<CompletedActivitiesTab> createState() => _CompletedActivitiesTabState();
}

class _CompletedActivitiesTabState extends State<CompletedActivitiesTab> {
  showTapActions(context, String title, CompletedActivity completedActivity) {
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
                              "${completedActivity.activityType}"
                                  .trim()
                                  .toUpperCase(),
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
                              "${title}".trim(),
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
                                    "View Results",
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
                          color: kAdeoBlue3,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "New",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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

  List<CompletedActivity> completedActivities = [];
  List<Marathon> marathons = [];
  late CompletedActivityList completedMarathons;

  getCompletedMarathons() {
    MarathonDB().completedMarathons().then((mList) {
      marathons = mList;

      print("marathons length: ${marathons.length}");
      Map<String, dynamic> completedMarathon = {
        "marathons": marathons,
      };
      completedMarathons = CompletedActivityList.fromJson(completedMarathon);

      for (var completedMarathon in completedMarathons.marathons!) {
        Map<String, dynamic> completedMarathonJSON = {
          "activityType": CompletedActivityType.MARATHON.name,
          "activityStartTime": completedMarathon.startTime,
          "marathon": completedMarathon,
        };

        CompletedActivity completedMarathonObject =
            CompletedActivity.fromJson(completedMarathonJSON);
        completedActivities.add(completedMarathonObject);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCompletedMarathons();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print("Completed Activities: ${completedActivities[0].type}");
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
          children: completedActivities.map(
            ((completedActivity) {
              int index = completedActivities.indexOf(completedActivity);
              bool isLastItem = index == completedActivities.length - 1;
              String activityTitle;

              switch (completedActivity.activityType) {
                case "MARATHON":
                  activityTitle = completedActivity.marathon!.title.toString();
;
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: isLastItem ? 0 : 12,
                    ),
                    child: ActivityCourseCard(
                      courseTitle: activityTitle,
                      activityType: completedActivity.activityType!,
                      iconUrl: 'assets/icons/courses/marathon.png',
                      onTap: () {
                        showTapActions(
                            context, activityTitle, completedActivity);
                      },
                    ),
                  );
                // break;
                default:
                  activityTitle = "Title";

                  return Container(
                    margin: EdgeInsets.only(
                      bottom: isLastItem ? 0 : 12,
                    ),
                    child: ActivityCourseCard(
                      courseTitle: "Title",
                      activityType: "Type",
                      iconUrl: 'assets/icons/courses/learn.png',
                      onTap: () {
                        showTapActions(
                            context, activityTitle, completedActivity);
                      },
                    ),
                  );
              }
            }),
          ).toList(),
        ),
      )),
    );
  }
}

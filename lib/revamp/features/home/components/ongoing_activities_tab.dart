import 'dart:math';

import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/marathon/marathon_completed.dart';
import 'package:ecoach/views/marathon/marathon_countdown.dart';
import 'package:ecoach/views/marathon/marathon_ended.dart';
import 'package:ecoach/views/marathon/marathon_practise_mock.dart';
import 'package:ecoach/views/marathon/marathon_practise_topic_menu.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/cards/activity_course_card.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OngoingActivitiesTab extends StatefulWidget {
  const OngoingActivitiesTab({Key? key, required this.ongoingActivities})
      : super(key: key);
  final List ongoingActivities;

  @override
  State<OngoingActivitiesTab> createState() => _OngoingActivitiesTabState();
}

class _OngoingActivitiesTabState extends State<OngoingActivitiesTab> {
  List<TestActivity> ongoingActivities = [];
  List<Marathon> marathons = [];
  late TestActivityList ongoingMarathons;
  late Topic? topic;
  late User user;
  bool isLoadingCompletedActivities = true;

  getOngoingMarathons() {
    MarathonDB().ongoingMarathons().then((mList) async {
      marathons = mList;
      Map<String, dynamic> ongoingMarathonsMap = {
        "marathons": marathons,
      };
      ongoingMarathons = TestActivityList.fromJson(ongoingMarathonsMap);
      for (var ongoingMarathon in ongoingMarathons.marathons!) {
        if (ongoingMarathon.topicId != null) {
          topic = await TopicDB().getTopicById(ongoingMarathon.topicId!);

          Map<String, dynamic> completedMarathonJSON = {
            "activityType": TestActivityType.MARATHON,
            "courseId": ongoingMarathon.courseId,
            "activityStartTime": ongoingMarathon.startTime!.toIso8601String(),
            "marathon": ongoingMarathon,
            "topic": topic,
          };

          TestActivity completedMarathonObject =
              TestActivity.fromJson(completedMarathonJSON);
          ongoingActivities.add(completedMarathonObject);
        }
      }
    });
  }

  Future loadCompletedActivities() async {
    user = await UserPreferences().getUser() as User;
    await getOngoingMarathons();
    // await getCompletedTreadmills();
    // await getCompletedAutopilots();

    isLoadingCompletedActivities = false;
  }

  @override
  void initState() {
    super.initState();
    loadCompletedActivities();
    setState(() {});
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
        child: isLoadingCompletedActivities
            ? Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: kAdeoGreen4,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  if (ongoingActivities.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You do not currently have an ongoing activity",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        AdeoFilledButton(
                          color: Colors.white,
                          background: kAdeoBlue,
                          label: 'Take an activity',
                          size: Sizes.medium,
                          fontSize: 16,
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return MainHomePage(
                                user,
                                index: 2,
                              );
                            }));
                          },
                        )
                      ],
                    ),
                  if (ongoingActivities.isNotEmpty)
                    ...ongoingActivities.map(
                      ((ongoingActivity) {
                        String activityTitle;
                        bool isLastItem =
                            ongoingActivities.indexOf(ongoingActivity) ==
                                ongoingActivities.length - 1;

                        switch (ongoingActivity.activityType) {
                          case TestActivityType.MARATHON:
                            activityTitle =
                                "${ongoingActivity.topic!.name!} (${ongoingActivity.marathon!.title!})";

                            print(
                                "Marathon Percentage: ${ongoingActivity.marathon!.toJson()}");
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: isLastItem ? 0 : 12,
                              ),
                              child: ActivityCourseCard(
                                courseTitle: activityTitle,
                                activityType: ongoingActivity.activityType!,
                                iconUrl: 'assets/icons/courses/treadmill.png',
                                hasProgressIndicator: true,
                                percentageCompleted:
                                    ongoingActivity.marathon!.avgScore,
                                onTap: () {
                                  showTapActions(
                                    context,
                                    courseId: ongoingActivity.courseId!,
                                    ongoingActivity: ongoingActivity,
                                    title: activityTitle,
                                    user: user,
                                  );
                                },
                              ),
                            );
                          case TestActivityType.TREADMILL:
                            return Container();

                          case TestActivityType.AUTOPILOT:
                            return Container();

                          default:
                            return Container();
                        }
                      }),
                    )
                ],
              ),
      )),
    );
  }

  showTapActions(
    context, {
    required String title,
    required int courseId,
    required TestActivity ongoingActivity,
    required User user,
  }) async {
    double sheetHeight = 480;
    Course? course = await CourseDB().getCourseById(courseId) as Course;

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
                              ongoingActivity.activityType!.name,
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
                              textAlign: TextAlign.center,
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
                              onTap: (() async {
                                switch (ongoingActivity.activityType) {
                                  case TestActivityType.MARATHON:
                                    MarathonController marathonController =
                                        MarathonController(
                                      user,
                                      course,
                                      name: ongoingActivity.marathon!.title,
                                    );

                                    showLoaderDialog(context,
                                        message: "loading marathon");
                                    bool success =
                                        await marathonController.loadMarathon();
                                    Navigator.pop(context);

                                    if (success) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (c) {
                                        return MarathonCountdown(
                                          controller: marathonController,
                                        );
                                      }));
                                    } else {
                                      AdeoDialog(
                                        title: "No marathon",
                                        content:
                                            "No marathon was found for this course. Kindly start over",
                                        actions: [
                                          AdeoDialogAction(
                                              label: "Ok",
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    }

                                    break;
                                  default:
                                    break;
                                }
                              }),
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
                              onTap: (() async {
                                dynamic screenToNavigateTo;
                                switch (ongoingActivity.activityType) {
                                  case TestActivityType.MARATHON:
                                    Marathon marathon =
                                        ongoingActivity.marathon!;
                                    MarathonController marathonController =
                                        MarathonController(
                                      user,
                                      course,
                                      name: ongoingActivity.marathon!.title,
                                      marathon: marathon,
                                    );

                                    MarathonType marathonTopicType =
                                        MarathonType.TOPIC;
                                    MarathonType marathonMockType =
                                        MarathonType.MOCK;

                                    if (marathon.type.toString() ==
                                        marathonTopicType.toString()) {
                                      showLoaderDialog(context,
                                          message: "Creating marathon");

                                      await marathonController
                                          .createTopicMarathon(
                                        marathon.topicId!,
                                      );
                                      marathonController.name =
                                          ongoingActivity.topic!.name!;
                                      Navigator.pop(context);

                                      screenToNavigateTo = Instructions(
                                        topicId: marathon.topicId!,
                                        controller: marathonController,
                                      );
                                    } else if (marathon.type.toString() ==
                                        marathonMockType.toString()) {
                                      showLoaderDialog(
                                        context,
                                        message: "Creating marathon",
                                      );
                                      int count = await QuestionDB()
                                          .getTotalQuestionCount(courseId);
                                      Navigator.pop(context);
                                      screenToNavigateTo = MarathonPractiseMock(
                                        count: count,
                                        controller: marathonController,
                                      );
                                    }

                                    break;
                                  default:
                                    break;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: RouteSettings(
                                      name: MainHomePage.routeName,
                                    ),
                                    builder: (context) {
                                      return screenToNavigateTo;
                                    },
                                  ),
                                );
                              }),
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
                      onTap: (() async {
                        dynamic screenToNavigateTo;
                        switch (ongoingActivity.activityType) {
                          case TestActivityType.MARATHON:
                            Marathon marathon = ongoingActivity.marathon!;
                            MarathonController marathonController =
                                MarathonController(
                              user,
                              course,
                              name: ongoingActivity.marathon!.title,
                              marathon: marathon,
                            );

                            marathonController.endMarathon();
                            screenToNavigateTo = MarathonEnded(
                              controller: marathonController,
                            );

                            break;
                          default:
                            break;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) {
                              return screenToNavigateTo;
                            },
                          ),
                        );
                      }),
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
}

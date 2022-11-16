import 'dart:convert';

import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/home/view/screen/homepage.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon/marathon_complete_congratulation.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/marathon/marathon_practise_topic_menu.dart';
import 'package:ecoach/views/result_summary/below_pass_mark.dart';
import 'package:ecoach/views/result_summary/result_summary.dart';
import 'package:ecoach/views/treadmill/treadmill_timer.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/cards/activity_course_card.dart';
import 'package:flutter/material.dart';

class CompletedActivitiesTab extends StatefulWidget {
  static const String routeName = '/completed-activities';

  const CompletedActivitiesTab({Key? key, required this.completedActivities})
      : super(key: key);
  final List completedActivities;

  @override
  State<CompletedActivitiesTab> createState() => _CompletedActivitiesTabState();
}

class _CompletedActivitiesTabState extends State<CompletedActivitiesTab> {
  List<CompletedActivity> completedActivities = [];
  List<Marathon> marathons = [];
  List<TestTaken> treadmills = [];
  bool isLoadingCompletedActivities = true;
  late CompletedActivityList completedMarathons;
  late CompletedActivityList completedTreadmills;
  late Topic? topic;

  viewResults(TestTaken testTaken, controller, test, diagnostic) {
    if (testTaken.score! >= 95) {
      goTo(
        context,
        ResultSummaryScreen(
          controller.user,
          controller.course,
          controller.type,
          test: test!,
          diagnostic: diagnostic,
          controller: controller,
          testCategory: controller.challengeType,
          message: 'Excellent',
        ),
        replace: true,
      );
    } else if (testTaken.score! >= 80) {
      goTo(
        context,
        ResultSummaryScreen(
          controller.user,
          controller.course,
          controller.type,
          test: test!,
          diagnostic: diagnostic,
          controller: controller,
          testCategory: controller.challengeType,
          message: 'Very Good',
        ),
        replace: true,
      );
    } else if (testTaken.score! >= 60) {
      goTo(
        context,
        ResultSummaryScreen(
          controller.user,
          controller.course,
          controller.type,
          test: test!,
          diagnostic: diagnostic,
          controller: controller,
          testCategory: controller.challengeType,
          message: 'Good, more room for improvement',
        ),
        replace: true,
      );
    } else if (testTaken.score! >= 40) {
      goTo(
        context,
        BelowPassMark(
          controller.user,
          controller.course,
          controller.type,
          test: test!,
          diagnostic: diagnostic,
          controller: controller,
          testCategory: controller.challengeType,
          message: 'Average Performance, need improvement',
        ),
        replace: true,
      );
    } else {
      goTo(
        context,
        BelowPassMark(
          controller.user,
          controller.course,
          controller.type,
          test: test!,
          diagnostic: diagnostic,
          controller: controller,
          testCategory: controller.challengeType,
          message: 'Poor Performance',
        ),
        replace: true,
      );
    }
  }

  showTapActions(
    context, {
    required String title,
    required int courseId,
    required CompletedActivity completedActivity,
  }) async {
    double sheetHeight = 480;
    User _user = await UserPreferences().getUser() as User;
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              completedActivity.activityType!.name
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
                              onTap: (() {
                                switch (completedActivity.activityType) {
                                  case CompletedActivityType.MARATHON:
                                    MarathonController marathonController =
                                        MarathonController(
                                      _user,
                                      course,
                                      name: course.name!,
                                      marathon: completedActivity.marathon,
                                    );

                                    Navigator.push<void>(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return MarathonCompleteCongratulations(
                                            controller: marathonController,
                                          );
                                        },
                                      ),
                                    ).then((value) {
                                      marathonController.currentQuestion = 0;
                                      marathonController.reviewMode = true;
                                      setState(() {});
                                    });
                                    break;
                                  default:
                                    QuizController controller = QuizController(
                                      _user,
                                      course,
                                      name: completedActivity.topic!.name!,
                                    );
                                    viewResults(
                                      completedActivity.treadmill!,
                                      controller,
                                      completedActivity.treadmill!,
                                      true,
                                    );
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
                            // if (completedActivity.activityType != "TREADMILL")
                            InkWell(
                              onTap: (() async {
                                switch (completedActivity.activityType!) {
                                  case CompletedActivityType.MARATHON:
                                    MarathonController marathonController =
                                        MarathonController(
                                      _user,
                                      course,
                                      name: course.name!,
                                    );
                                    Marathon marathon =
                                        completedActivity.marathon!;

                                    MarathonType marathonTopicType =
                                        MarathonType.TOPIC;
                                    MarathonType marathonMockType =
                                        MarathonType.MOCK;

                                    if (marathon.type.toString() ==
                                        marathonTopicType.toString()) {
                                      await marathonController
                                          .createTopicMarathon(
                                              marathon.topicId!);
                                      marathonController.name =
                                          completedActivity.topic!.name!;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          settings: RouteSettings(
                                            name: HomePage2.routeName,
                                          ),
                                          builder: (context) {
                                            return Instructions(
                                              topicId: marathon.topicId!,
                                              controller: marathonController,
                                            );
                                          },
                                        ),
                                      );
                                    } else if (marathon.type.toString() ==
                                        marathonMockType.toString()) {}
                                    break;
                                  case CompletedActivityType.TREADMILL:
                                    TreadmillController treadmillController =
                                        TreadmillController(
                                      _user,
                                      course,
                                    );
                                    String? treadmillTestCategory =
                                        completedActivity
                                            .treadmill!.challengeType;
                                    int topicId = jsonDecode(completedActivity
                                        .treadmill!
                                        .responses)["Q1"]["topic_id"];

                                    late TreadmillMode treadmillMode;
                                    print(treadmillTestCategory.runtimeType);

                                    if (treadmillTestCategory ==
                                        "TestCategory.TOPIC") {
                                      treadmillMode = TreadmillMode.TOPIC;
                                    } else if (treadmillTestCategory ==
                                        "TestCategory.MOCK") {
                                      treadmillMode = TreadmillMode.MOCK;
                                    } else {
                                      treadmillMode = TreadmillMode.BANK;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return TreadmillTime(
                                            controller: treadmillController,
                                            mode: treadmillMode,
                                            count: treadmillController
                                                .countQuestions,
                                            topic: topic,
                                            topicId: topicId,
                                            bankId: topicId,
                                          );
                                        },
                                      ),
                                    );
                                    break;
                                  default:
                                    break;
                                }
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
                      onTap: (() {
                        switch (completedActivity.activityType) {
                          case CompletedActivityType.MARATHON:
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) {
                              return MarathonIntroit(_user, course);
                            }));
                            break;
                          case CompletedActivityType.TREADMILL:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TreadmillWelcome(
                                    user: _user,
                                    course: course,
                                  );
                                },
                              ),
                            );
                            break;
                          default:
                            break;
                        }
                      }),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
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

  Future loadCompletedActivities() async {
    await getCompletedMarathons();
    await getCompletedTreadmills();

    isLoadingCompletedActivities = false;
  }

  getCompletedMarathons() {
    MarathonDB().completedMarathons().then((mList) async {
      marathons = mList;

      Map<String, dynamic> completedMarathonsMap = {
        "marathons": marathons,
      };
      completedMarathons =
          CompletedActivityList.fromJson(completedMarathonsMap);
      for (var completedMarathon in completedMarathons.marathons!) {
        if (completedMarathon.topicId != null) {
          topic = await TopicDB().getTopicById(completedMarathon.topicId!);

          Map<String, dynamic> completedMarathonJSON = {
            "activityType": CompletedActivityType.MARATHON,
            "courseId": completedMarathon.courseId,
            "activityStartTime": completedMarathon.startTime!.toIso8601String(),
            "marathon": completedMarathon,
            "topic": topic,
          };
          CompletedActivity completedMarathonObject =
              CompletedActivity.fromJson(completedMarathonJSON);
          completedActivities.add(completedMarathonObject);
        }
      }
    });
  }

  getCompletedTreadmills() {
    TestTakenDB().courseTestsTaken().then((mList) async {
      treadmills = mList;

      Map<String, dynamic> completedTreadmillsMap = {
        "treadmills": treadmills,
      };
      completedTreadmills =
          CompletedActivityList.fromJson(completedTreadmillsMap);

      for (var completedTreadmill in completedTreadmills.treadmills!) {
        int topicId =
            jsonDecode(completedTreadmill.responses)["Q1"]["topic_id"];
        topic = await TopicDB().getTopicById(topicId);

        Map<String, dynamic> completedTreadmillJSON = {
          "activityType": CompletedActivityType.TREADMILL,
          "courseId": completedTreadmill.courseId,
          "activityStartTime": completedTreadmill.updatedAt!.toIso8601String(),
          "treadmill": completedTreadmill,
          "topic": topic,
        };
        CompletedActivity completedTreadmillObject =
            CompletedActivity.fromJson(completedTreadmillJSON);
        completedActivities.add(completedTreadmillObject);
      }
    });
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
            : Column(children: [
                if (completedActivities.isEmpty)
                  Text(
                    "You do not currently have any completed activity",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (completedActivities.isNotEmpty)
                  ...completedActivities.map(
                    ((completedActivity) {
                      int index =
                          completedActivities.indexOf(completedActivity);
                      bool isLastItem = index == completedActivities.length - 1;
                      String activityTitle;

                      switch (completedActivity.activityType) {
                        case CompletedActivityType.MARATHON:
                          activityTitle =
                              completedActivity.marathon!.title.toString();
                          ;
                          double percentageCompleted =
                              completedActivity.marathon!.totalCorrect! /
                                  completedActivity.marathon!.totalQuestions!;
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: isLastItem ? 0 : 12,
                            ),
                            child: ActivityCourseCard(
                              courseTitle: completedActivity.topic!.name!,
                              activityType: completedActivity.activityType!,
                              iconUrl: 'assets/icons/courses/marathon.png',
                              percentageCompleted: percentageCompleted,
                              onTap: () {
                                showTapActions(
                                  context,
                                  title: completedActivity.topic!.name!,
                                  completedActivity: completedActivity,
                                  courseId: completedActivity.courseId!,
                                );
                              },
                            ),
                          );
                        case CompletedActivityType.TREADMILL:
                          activityTitle =
                              completedActivity.treadmill!.testname.toString();
                          ;
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: isLastItem ? 0 : 12,
                            ),
                            child: ActivityCourseCard(
                              courseTitle: activityTitle,
                              activityType: completedActivity.activityType!,
                              iconUrl: 'assets/icons/courses/treadmill.png',
                              onTap: () {
                                showTapActions(
                                  context,
                                  completedActivity: completedActivity,
                                  title: activityTitle,
                                  courseId: completedActivity.courseId!,
                                );
                              },
                            ),
                          );

                        default:
                          activityTitle = "Title";

                          return Container(
                            margin: EdgeInsets.only(
                              bottom: isLastItem ? 0 : 12,
                            ),
                            child: ActivityCourseCard(
                              courseTitle: "Title",
                              activityType: CompletedActivityType.MARATHON,
                              iconUrl: 'assets/icons/courses/learn.png',
                              onTap: () {
                                showTapActions(
                                  context,
                                  completedActivity: completedActivity,
                                  title: activityTitle,
                                  courseId: completedActivity.courseId!,
                                );
                              },
                            ),
                          );
                      }
                    }),
                  )
              ]),
      )),
    );
  }
}

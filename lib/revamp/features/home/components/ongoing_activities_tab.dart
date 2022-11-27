import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/autopilot_db.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_topic_menu.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/marathon/marathon_countdown.dart';
import 'package:ecoach/views/marathon/marathon_ended.dart';
import 'package:ecoach/views/marathon/marathon_practise_mock.dart';
import 'package:ecoach/views/marathon/marathon_practise_topic_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_countdown.dart';
import 'package:ecoach/views/treadmill/treadmill_timer.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/cards/activity_course_card.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OngoingActivitiesTab extends StatefulWidget {
  const OngoingActivitiesTab({
    Key? key,
    required this.mainController,
    required this.user,
    required this.allOngoingActivities,
    this.planId,
  }) : super(key: key);
  final MainController mainController;
  final int? planId;
  final User user;
  final List<TestActivity> allOngoingActivities;

  @override
  State<OngoingActivitiesTab> createState() => _OngoingActivitiesTabState();
}

class _OngoingActivitiesTabState extends State<OngoingActivitiesTab> {
  List<TestActivity> _allOngoingActivities = [];

  @override
  void initState() {
    _allOngoingActivities = widget.allOngoingActivities;
    super.initState();
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
        child: _allOngoingActivities.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You do not currently have any ongoing activities",
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
                    background: kAdeoGreen4,
                    label: 'Take an activity',
                    size: Sizes.medium,
                    fontSize: 16,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return MainHomePage(
                          widget.user,
                          index: 2,
                        );
                      }));
                    },
                  )
                ],
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 18),
                itemCount: _allOngoingActivities.length,
                scrollDirection: Axis.vertical,
                itemBuilder: ((context, index) {
                  TestActivity ongoingActivity = _allOngoingActivities[index];

                  String activityTitle;

                  switch (ongoingActivity.activityType) {
                    case TestActivityType.MARATHON:
                      activityTitle =
                          "${ongoingActivity.topic!.name!} (${ongoingActivity.marathon!.title!})";

                      return Container(
                        margin: EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ActivityCourseCard(
                          courseTitle: activityTitle,
                          activityType: ongoingActivity.activityType!,
                          iconUrl: 'assets/icons/courses/marathon.png',
                          hasProgressIndicator: true,
                          percentageCompleted:
                              ongoingActivity.marathon!.avgScore,
                          onTap: () {
                            showTapActions(
                              context,
                              courseId: ongoingActivity.courseId!,
                              ongoingActivity: ongoingActivity,
                              title: activityTitle,
                              user: widget.user,
                            );
                          },
                        ),
                      );
                    case TestActivityType.TREADMILL:
                      activityTitle =
                          ongoingActivity.ongoingTreadmill!.title.toString();
                      ;
                      int totalAnswered =
                          ongoingActivity.ongoingTreadmill!.totalCorrect! +
                              ongoingActivity.ongoingTreadmill!.totalWrong!;
                      double percentageAnswered = (totalAnswered /
                          ongoingActivity.ongoingTreadmill!.totalQuestions!);

                      return Container(
                        margin: EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ActivityCourseCard(
                          courseTitle: activityTitle,
                          activityType: ongoingActivity.activityType!,
                          iconUrl: 'assets/icons/courses/treadmill.png',
                          hasProgressIndicator: true,
                          percentageCompleted: percentageAnswered,
                          onTap: () {
                            showTapActions(
                              context,
                              courseId: ongoingActivity.courseId!,
                              ongoingActivity: ongoingActivity,
                              title: activityTitle,
                              user: widget.user,
                            );
                          },
                        ),
                      );

                    case TestActivityType.AUTOPILOT:
                      activityTitle = ongoingActivity.autopilot!.title!;
                      return FutureBuilder<Course>(
                          future: getAutopilotCourse(
                              ongoingActivity.autopilot!.courseId),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: kAdeoGreen4,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                );
                              default:
                                if (snapshot.hasError) {
                                  return Container();
                                } else if (snapshot.data != null) {
                                  Course autopilotCourse = snapshot.data!;
                                  AutopilotController autopilotController =
                                      AutopilotController(
                                    widget.user,
                                    autopilotCourse,
                                  );
                                  return FutureBuilder(
                                      future: Future.wait([
                                        TestController()
                                            .getTopics(autopilotCourse),
                                        autopilotController.loadAutopilot(),
                                      ]),
                                      builder: (context,
                                          AsyncSnapshot<List> snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return Center(
                                              child: SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: kAdeoGreen4,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                            );
                                          default:
                                            if (snapshot.hasError) {
                                              return Container();
                                            } else if (snapshot.data != null) {
                                              List<TestNameAndCount> topics =
                                                  snapshot.data![0];

                                              autopilotController.autopilot =
                                                  ongoingActivity.autopilot;
                                              autopilotController.topics =
                                                  topics;

                                              double completedAverage =
                                                  autopilotController
                                                      .getPercentageOfCompletedAutopilotTopics();

                                              return Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                child: ActivityCourseCard(
                                                  courseTitle:
                                                      autopilotCourse.name!,
                                                  activityType: ongoingActivity
                                                      .activityType!,
                                                  iconUrl:
                                                      'assets/icons/courses/autopilot.png',
                                                  hasProgressIndicator: true,
                                                  percentageCompleted:
                                                      completedAverage,
                                                  onTap: () {
                                                    showTapActions(
                                                      context,
                                                      courseId: ongoingActivity
                                                          .courseId!,
                                                      ongoingActivity:
                                                          ongoingActivity,
                                                      title: activityTitle,
                                                      user: widget.user,
                                                      controller:
                                                          autopilotController,
                                                    );
                                                  },
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                        }
                                      });
                                } else {
                                  return Container();
                                }
                            }
                          });

                    default:
                      return Container();
                  }
                }),
              ));
  }

  Future<Course> getAutopilotCourse(courseId) async {
    Course course = await CourseDB().getCourseById(courseId) as Course;
    return course;
  }

  showTapActions(
    context, {
    required String title,
    required int courseId,
    required TestActivity ongoingActivity,
    required User user,
    dynamic controller,
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
                            GestureDetector(
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
                                  case TestActivityType.TREADMILL:
                                    TreadmillController treadmillController =
                                        TreadmillController(
                                      user,
                                      course,
                                      name: ongoingActivity
                                          .ongoingTreadmill!.title!,
                                      treadmill:
                                          ongoingActivity.ongoingTreadmill!,
                                    );
                                    showLoaderDialog(context,
                                        message: "loading runs");

                                    bool success = await treadmillController
                                        .loadTreadmill();
                                    Navigator.pop(context);

                                    if (success) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (c) {
                                          return TreadmillCountdown(
                                            controller: treadmillController,
                                          );
                                        }),
                                      );
                                    } else {
                                      AdeoDialog(
                                        title: "No Treadmill",
                                        content:
                                            "No treadmill was found for this course. Kindly start over",
                                        actions: [
                                          AdeoDialogAction(
                                            label: "Ok",
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    }
                                    break;
                                  case TestActivityType.AUTOPILOT:
                                    AutopilotController autopilotController =
                                        controller as AutopilotController;
                                    await autopilotController.loadAutopilot();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AutopilotTopicMenu(
                                            controller: autopilotController,
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
                                  case TestActivityType.TREADMILL:
                                    TreadmillController treadmillController =
                                        TreadmillController(
                                      user,
                                      course,
                                      name: ongoingActivity
                                          .ongoingTreadmill!.title!,
                                      treadmill:
                                          ongoingActivity.ongoingTreadmill!,
                                    );
                                    late TreadmillMode treadmillMode;
                                    List<TestNameAndCount> topics =
                                        await TestController()
                                            .getTopics(course);

                                    print(
                                        "topic Name: ${ongoingActivity.ongoingTreadmill!.title!}");

                                    TestNameAndCount topic = topics.firstWhere(
                                      (topic) =>
                                          topic.name ==
                                          ongoingActivity
                                              .ongoingTreadmill!.title!,
                                    );

                                    if (ongoingActivity
                                            .ongoingTreadmill!.type ==
                                        "TreadmillType.TOPIC") {
                                      treadmillMode = TreadmillMode.TOPIC;
                                    } else if (ongoingActivity
                                            .ongoingTreadmill!.type ==
                                        "TreadmillType.MOCK") {
                                      treadmillMode = TreadmillMode.MOCK;
                                    } else {
                                      treadmillMode = TreadmillMode.BANK;
                                    }

                                    screenToNavigateTo = TreadmillTime(
                                      controller: treadmillController,
                                      mode: treadmillMode,
                                      topicId: topic.id,
                                    );

                                    break;
                                  case TestActivityType.AUTOPILOT:
                                    AutopilotController autopilotController =
                                        controller as AutopilotController;

                                    print('creating new autopilot');
                                    await autopilotController.createAutopilot();

                                    screenToNavigateTo = AutopilotTopicMenu(
                                      controller: autopilotController,
                                    );

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
                  if (ongoingActivity.activityType !=
                      TestActivityType.TREADMILL)
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) {
                                    return screenToNavigateTo;
                                  },
                                ),
                              );

                              break;
                            case TestActivityType.AUTOPILOT:
                              AutopilotController autopilotController =
                                  AutopilotController(
                                user,
                                course,
                                autopilot: ongoingActivity.autopilot,
                              );

                              await autopilotController.endOngoingAutopilot(
                                  ongoingActivity.autopilot!);

                              Navigator.pop(context);
                              setState(() {});

                              break;

                            default:
                              break;
                          }
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

import 'dart:convert';

import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/autopilot_db.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/home/view/screen/homepage.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_introit_topics.dart';
import 'package:ecoach/views/autopilot/autopilot_topic_menu.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/marathon/marathon_complete_congratulation.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/marathon/marathon_practise_mock.dart';
import 'package:ecoach/views/marathon/marathon_practise_topic_menu.dart';
import 'package:ecoach/views/result_summary/below_pass_mark.dart';
import 'package:ecoach/views/result_summary/result_summary.dart';
import 'package:ecoach/views/treadmill/treadmill_practise_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_timer.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';

import 'package:ecoach/widgets/cards/activity_course_card.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedActivitiesTab extends StatefulWidget {
  static const String routeName = '/completed-activities';

  const CompletedActivitiesTab({
    Key? key,
    required this.mainController,
    this.planId,
  }) : super(key: key);

  final MainController mainController;
  final int? planId;

  @override
  State<CompletedActivitiesTab> createState() => _CompletedActivitiesTabState();
}

class _CompletedActivitiesTabState extends State<CompletedActivitiesTab> {
  late Topic? topic;
  late User user;

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

  getCompletedAutopilots() async {
    List<TestActivity> completedAutopilotActivities = [];
    late TestActivityList completedAutopilots;
    await AutopilotDB().completedAutopilots().then((mList) async {
      List<Autopilot> autopilots = mList;

      Map<String, dynamic> completedAutopilotsMap = {
        "autopilots": autopilots,
      };
      completedAutopilots = TestActivityList.fromJson(completedAutopilotsMap);
      for (var completedAutopilot in completedAutopilots.autopilots!) {
        Map<String, dynamic> completedAutopilotJSON = {
          "activityType": TestActivityType.AUTOPILOT,
          "courseId": completedAutopilot.courseId,
          "activityStartTime": completedAutopilot.startTime!.toIso8601String(),
          "autopilot": completedAutopilot,
          // "topic": null,
        };

        TestActivity completedAutopilotObject =
            TestActivity.fromJson(completedAutopilotJSON);
        completedAutopilotActivities.add(completedAutopilotObject);
      }
    });
    return completedAutopilotActivities;
  }

  getCompletedMarathons() async {
    List<TestActivity> completedMarathonActivities = [];
    late TestActivityList completedMarathons;
    await MarathonDB().completedMarathons().then((mList) async {
      List<Marathon> marathons = mList;

      Map<String, dynamic> completedMarathonsMap = {
        "marathons": marathons,
      };
      completedMarathons = TestActivityList.fromJson(completedMarathonsMap);
      for (var completedMarathon in completedMarathons.marathons!) {
        if (completedMarathon.topicId != null) {
          topic = await TopicDB().getTopicById(completedMarathon.topicId!);

          Map<String, dynamic> completedMarathonJSON = {
            "activityType": TestActivityType.MARATHON,
            "courseId": completedMarathon.courseId,
            "activityStartTime": completedMarathon.startTime!.toIso8601String(),
            "marathon": completedMarathon,
            "topic": topic,
          };
          TestActivity completedMarathonObject =
              TestActivity.fromJson(completedMarathonJSON);
          completedMarathonActivities.add(completedMarathonObject);
        }
      }
    });
    return completedMarathonActivities;
  }

  getCompletedTreadmills() async {
    List<TestActivity> completedTreadmillActivities = [];
    late TestActivityList completedTreadmills;
    await TestTakenDB().courseTestsTaken().then((mList) async {
      List<TestTaken> treadmills = mList;

      Map<String, dynamic> completedTreadmillsMap = {
        "treadmills": treadmills,
      };
      completedTreadmills = TestActivityList.fromJson(completedTreadmillsMap);
      for (var completedTreadmill in completedTreadmills.treadmills!) {
        int topicId =
            jsonDecode(completedTreadmill.responses)["Q1"]["topic_id"];
        topic = await TopicDB().getTopicById(topicId);
        if (topic == null) {
          continue;
        }
        Map<String, dynamic> completedTreadmillJSON = {
          "activityType": TestActivityType.TREADMILL,
          "courseId": completedTreadmill.courseId,
          "activityStartTime": completedTreadmill.updatedAt!.toIso8601String(),
          "treadmill": completedTreadmill,
          "topic": topic,
        };

        TestActivity completedTreadmillObject =
            TestActivity.fromJson(completedTreadmillJSON);
        completedTreadmillActivities.add(completedTreadmillObject);
      }
    });

    return completedTreadmillActivities;
  }

  Future<List<TestActivity>> loadCompletedActivities() async {
    List<TestActivity> completedMarathonActivities = [];
    List<TestActivity> completedAutopilotActivities = [];
    List<TestActivity> completedTreadmillActivities = [];

    user = await UserPreferences().getUser() as User;

    completedMarathonActivities = await getCompletedMarathons();
    completedAutopilotActivities = await getCompletedTreadmills();
    completedTreadmillActivities = await getCompletedAutopilots();

    List<TestActivity> allCompletedActivities = [
      ...completedMarathonActivities,
      ...completedAutopilotActivities,
      ...completedTreadmillActivities,
    ];

    return allCompletedActivities;
  }

  @override
  void initState() {
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: FutureBuilder<List<TestActivity>>(
              future: loadCompletedActivities(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
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
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else if (snapshot.data != null) {
                      List<TestActivity> _completedActivities = snapshot.data!;
                      return Column(
                        children: [
                          if (_completedActivities.isEmpty)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "You do not currently have any completed activity",
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
                                        user,
                                        index: 2,
                                      );
                                    }));
                                  },
                                )
                              ],
                            ),
                          if (_completedActivities.isNotEmpty)
                            ..._completedActivities.map(
                              ((completedActivity) {
                                int index = _completedActivities
                                    .indexOf(completedActivity);
                                bool isLastItem =
                                    index == _completedActivities.length - 1;
                                String activityTitle;

                                switch (completedActivity.activityType) {
                                  case TestActivityType.MARATHON:
                                    activityTitle =
                                        "${completedActivity.topic!.name!} (${completedActivity.marathon!.title!})";

                                    double percentageCompleted =
                                        completedActivity
                                                .marathon!.totalCorrect! /
                                            completedActivity
                                                .marathon!.totalQuestions!;
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: isLastItem ? 0 : 12,
                                      ),
                                      child: ActivityCourseCard(
                                        courseTitle: activityTitle,
                                        activityType:
                                            completedActivity.activityType!,
                                        iconUrl:
                                            'assets/icons/courses/marathon.png',
                                        percentageCompleted:
                                            percentageCompleted,
                                        onTap: () {
                                          showTapActions(
                                            context,
                                            title:
                                                completedActivity.topic!.name!,
                                            completedActivity:
                                                completedActivity,
                                            courseId:
                                                completedActivity.courseId!,
                                            user: user,
                                          );
                                        },
                                      ),
                                    );
                                  case TestActivityType.TREADMILL:
                                    activityTitle = completedActivity
                                        .treadmill!.testname
                                        .toString();
                                    ;
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: isLastItem ? 0 : 12,
                                      ),
                                      child: ActivityCourseCard(
                                        courseTitle: activityTitle,
                                        activityType:
                                            completedActivity.activityType!,
                                        iconUrl:
                                            'assets/icons/courses/treadmill.png',
                                        onTap: () async {
                                          List<Question> questions =
                                              await QuestionDB()
                                                  .getQuestionsByCourseId(
                                            completedActivity.courseId!,
                                          );
                                          print(
                                            "Questions: ${questions.length}",
                                          );
                                          if (questions.isNotEmpty) {
                                            showTapActions(
                                              context,
                                              completedActivity:
                                                  completedActivity,
                                              title: activityTitle,
                                              courseId:
                                                  completedActivity.courseId!,
                                              user: user,
                                            );
                                          } else {
                                            print("Download course first");
                                            // showDialogYesNo(
                                            //     context: context,
                                            //     message:
                                            //         "Download questions for ${completedActivity.treadmill!.courseName}",
                                            //     target: BuyBundlePage(
                                            //       user,
                                            //       controller:
                                            //           widget.mainController,
                                            //       bundle: widget.subscription,
                                            //     ));
                                          }
                                        },
                                      ),
                                    );
                                  case TestActivityType.AUTOPILOT:
                                    activityTitle =
                                        completedActivity.autopilot!.title!;

                                    return FutureBuilder<Course>(
                                        future: getAutopilotCourse(
                                            completedActivity
                                                .autopilot!.courseId),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                              return SizedBox(
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
                                              );
                                            default:
                                              if (snapshot.hasError) {
                                                return Container();
                                              } else if (snapshot.data !=
                                                  null) {
                                                Course autopilotCourse =
                                                    snapshot.data!;

                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: isLastItem ? 0 : 12,
                                                  ),
                                                  child: ActivityCourseCard(
                                                    courseTitle:
                                                        autopilotCourse.name!,
                                                    activityType:
                                                        completedActivity
                                                            .activityType!,
                                                    iconUrl:
                                                        'assets/icons/courses/autopilot.png',
                                                    onTap: () {
                                                      showTapActions(
                                                        context,
                                                        completedActivity:
                                                            completedActivity,
                                                        title: autopilotCourse
                                                            .name!,
                                                        courseId:
                                                            completedActivity
                                                                .courseId!,
                                                        user: user,
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                          }
                                        });

                                  default:
                                    return Container();
                                }
                              }),
                            )
                        ],
                      );
                    } else {
                      return Container();
                    }
                }
              }),
        ),
      ),
    );
  }

  Future<Course> getAutopilotCourse(courseId) async {
    Course? course = await CourseDB().getCourseById(courseId) as Course;
    return course;
  }

  showTapActions(
    context, {
    required String title,
    required int courseId,
    required TestActivity completedActivity,
    required User user,
  }) async {
    double sheetHeight = 480;
    User _user = user;
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
                            Column(
                              children: [
                                if (completedActivity.activityType !=
                                    TestActivityType.AUTOPILOT)
                                  InkWell(
                                    onTap: (() async {
                                      switch (completedActivity.activityType) {
                                        case TestActivityType.MARATHON:
                                          MarathonController
                                              marathonController =
                                              MarathonController(
                                            _user,
                                            course,
                                            name: course.name!,
                                            marathon:
                                                completedActivity.marathon,
                                          );

                                          Navigator.push<void>(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) {
                                                return MarathonCompleteCongratulations(
                                                  controller:
                                                      marathonController,
                                                );
                                              },
                                            ),
                                          ).then((value) {
                                            marathonController.currentQuestion =
                                                0;
                                            marathonController.reviewMode =
                                                true;
                                            setState(() {});
                                          });
                                          break;
                                        case TestActivityType.TREADMILL:
                                          QuizController controller =
                                              QuizController(
                                            _user,
                                            course,
                                            name: completedActivity
                                                .treadmill!.testname!,
                                          );
                                          viewResults(
                                            completedActivity.treadmill!,
                                            controller,
                                            completedActivity.treadmill!,
                                            true,
                                          );
                                          break;
                                        case TestActivityType.AUTOPILOT:
                                          List<TestNameAndCount> topics =
                                              await TestController()
                                                  .getTopics(course);

                                          AutopilotController
                                              autopilotController =
                                              AutopilotController(
                                            _user,
                                            course,
                                            topics: topics,
                                          );

                                          await autopilotController
                                              .loadAutopilot();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return AutopilotTopicMenu(
                                                  controller:
                                                      autopilotController,
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
                              ],
                            ),
                            InkWell(
                              onTap: (() async {
                                switch (completedActivity.activityType!) {
                                  case TestActivityType.MARATHON:
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
                                      showLoaderDialog(context,
                                          message: "Creating marathon");

                                      await marathonController
                                          .createTopicMarathon(
                                        marathon.topicId!,
                                      );
                                      marathonController.name =
                                          completedActivity.topic!.name!;
                                      Navigator.pop(context);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          settings: RouteSettings(
                                            name: MainHomePage.routeName,
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
                                        marathonMockType.toString()) {
                                      showLoaderDialog(context,
                                          message: "Creating marathon");
                                      int count = await QuestionDB()
                                          .getTotalQuestionCount(courseId);
                                      Navigator.pop(context);
                                      MarathonPractiseMock(
                                        count: count,
                                        controller: marathonController,
                                      );
                                    }
                                    break;
                                  case TestActivityType.TREADMILL:
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
                                  case TestActivityType.AUTOPILOT:
                                    AutopilotController autopilotController =
                                        AutopilotController(
                                      _user,
                                      course,
                                    );

                                    print('creating new autopilot');
                                    await autopilotController.createAutopilot();

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
                  if (completedActivity.activityType !=
                      TestActivityType.AUTOPILOT)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: InkWell(
                        onTap: (() {
                          switch (completedActivity.activityType) {
                            case TestActivityType.MARATHON:
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (c) {
                                return MarathonIntroit(_user, course);
                              }));
                              break;
                            case TestActivityType.TREADMILL:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return TreadmillPractiseMenu(
                                      controller: TreadmillController(
                                        _user,
                                        course,
                                        name: course.name!,
                                      ),
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
}

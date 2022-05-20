import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/autopilot/autopilot_introit.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/test/test_challenge_list.dart';
import 'package:ecoach/views/treadmill/treadmill_introit.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class TestTypeView extends StatefulWidget {
  static const String routeName = '/testtype';
  TestTypeView(
    this.user,
    this.course,
  );
  User user;
  Course course;

  @override
  _TestTypeViewState createState() => _TestTypeViewState();
}

class _TestTypeViewState extends State<TestTypeView> {
  TestType testType = TestType.NONE;
  TestCategory testCategory = TestCategory.NONE;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SET THE BACK BUTTON TO MOVE BACK TO THE COURSE DETAILS PAGE,
    //BECAUSE WE ARE IN A TEST PAGE AND I AM PUSHING FROM NEW TEST PAGE
    //to choose test type and don't want it to pop back into the test
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(
            context, ModalRoute.withName(CourseDetailsPage.routeName));
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              child: Column(
                children: [
                  PageHeader(
                    pageHeading: "Choose your test type",
                  ),
                  MultiPurposeCourseCard(
                    title: 'Speed',
                    subTitle:
                        'Accuracy matters , don\'t let the clock run down',
                    iconURL: 'assets/icons/courses/speed.png',
                    onTap: () {
                      // showTestCat(TestType.SPEED);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return TestChallengeList(
                      //         testType: TestType.SPEED,
                      //         course: widget.course,
                      //         user: widget.user,
                      //       );
                      //     },
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SpeedTestIntro(
                              user: widget.user,
                              course: widget.course,
                            );
                          },
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return SpeedTestIntroit(
                      //         user: widget.user,
                      //         course: widget.course,
                      //       );
                      //     },
                      //   ),
                      // );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Knowledge',
                    subTitle: 'Standard test',
                    iconURL: 'assets/icons/courses/knowledge.png',
                    onTap: () {
                      // showTestCat(TestType.KNOWLEDGE);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TestChallengeList(
                              testType: TestType.KNOWLEDGE,
                              course: widget.course,
                              user: widget.user,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Marathon',
                    subTitle: 'Race to complete all questions',
                    iconURL: 'assets/icons/courses/marathon.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MarathonIntroit(widget.user, widget.course);
                          },
                        ),
                      );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Autopilot',
                    subTitle: 'Completing a course one topic at a time',
                    iconURL: 'assets/icons/courses/autopilot.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AutopilotIntroit(widget.user, widget.course);
                          },
                        ),
                      );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Treadmill',
                    subTitle: 'Crank up the speed, how far can you go?',
                    iconURL: 'assets/icons/courses/treadmill.png',
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AdeoDialog(
                            title: 'Treadmill',
                            content:
                                'Crank up the speed. \nFeature coming soon.',
                            actions: [
                              AdeoDialogAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return TreadmillIntroit(widget.user, widget.course);
                      //     },
                      //   ),
                      // );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Customised',
                    subTitle: 'Create your own kind of quiz',
                    iconURL: 'assets/icons/courses/customised.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CustomizedTestIntroit(
                              user: widget.user,
                              course: widget.course,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Timeless',
                    subTitle: 'Practice mode, no pressure.',
                    iconURL: 'assets/icons/courses/untimed.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TestChallengeList(
                              testType: TestType.UNTIMED,
                              course: widget.course,
                              user: widget.user,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Review',
                    subTitle: 'Know the answer to every question',
                    iconURL: 'assets/icons/courses/review.png',
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AdeoDialog(
                            title: 'Review',
                            content:
                                'Know the answer to every question. Feature coming soon.',
                            actions: [
                              AdeoDialogAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  MultiPurposeCourseCard(
                    title: 'Conquest',
                    subTitle: 'Prepare for battle, attempt everything',
                    iconURL: 'assets/icons/courses/conquest.png',
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AdeoDialog(
                            title: 'Conquest',
                            content:
                                'Prepare for battle, attempt everything. Feature coming soon.',
                            actions: [
                              AdeoDialogAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

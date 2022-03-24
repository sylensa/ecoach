import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/autopilot_introit.dart';
import 'package:ecoach/views/customized_test_introit.dart';
import 'package:ecoach/views/marathon_introit.dart';
import 'package:ecoach/views/speed_test_introit.dart';
import 'package:ecoach/views/test_challenge_list.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class TestTypeView extends StatefulWidget {
  static const String routeName = '/testtype';
  TestTypeView(this.user, this.course, {Key? key}) : super(key: key);
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
    return Scaffold(
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
                  subTitle: 'Accuracy matters , don\'t let the clock run down',
                  iconURL: 'assets/icons/courses/speed.png',
                  onTap: () {
                    // showTestCat(TestType.SPEED);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TestChallengeList(
                            testType: TestType.SPEED,
                            course: widget.course,
                            user: widget.user,
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
                  subTitle: 'Race to complete all questions ',
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
                  title: 'Customised',
                  subTitle: 'Create your own kind of quiz',
                  iconURL: 'assets/icons/courses/customised.png',
                  onTap: () {
                    // showTestCat(TestType.CUSTOMIZED);
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
                  title: 'Untimed',
                  subTitle: 'Practice mode , no pressure',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

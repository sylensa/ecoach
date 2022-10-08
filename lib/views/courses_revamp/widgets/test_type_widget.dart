import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/autopilot/autopilot_introit.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/review/review_onboarding.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/test/test_challenge_list.dart';
import 'package:ecoach/views/treadmill/treadmill_save_resumption_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class TestTypeWidget extends StatefulWidget {
  TestTypeWidget({Key? key,required this.course,required this.user,required this.subscription, required this.controller}) : super(key: key);
  Course course;
  User user;
  Plan subscription;
  final MainController controller;

  @override
  State<TestTypeWidget> createState() => _TestTypeWidgetState();
}

class _TestTypeWidgetState extends State<TestTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return   Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          MultiPurposeCourseCard(
            title: 'Speed',
            subTitle:
            'Accuracy matters , don\'t let the clock run down',
            iconURL: 'assets/icons/courses/speed.png',
            onTap: () {
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
            },
          ),
          MultiPurposeCourseCard(
            title: 'Knowledge',
            subTitle: 'Standard test',
            iconURL: 'assets/icons/courses/knowledge.png',
            onTap: () {
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
                    return AutopilotIntroit(
                        widget.user, widget.course);
                  },
                ),
              );
            },
          ),
          MultiPurposeCourseCard(
            title: 'Treadmill',
            subTitle: 'Crank up the speed, how far can you go?',
            iconURL: 'assets/icons/courses/treadmill.png',
            onTap: () async {
              Treadmill? treadmill = await TestController().getCurrentTreadmill(widget.course);
              if (treadmill == null) {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TreadmillWelcome(
                      user: widget.user,
                      course: widget.course,
                    ),
                  ),
                );
              }
              else {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TreadmillSaveResumptionMenu(
                          controller: TreadmillController(
                            widget.user,
                            widget.course,
                            name: widget.course.name!,
                            treadmill: treadmill,
                          ),
                        ),
                  ),
                );
              }
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
                      course:widget.course,
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
              goTo(
                  context,
                  ReviewOnBoarding(
                    user: widget.user,
                    course: widget.course,
                    testType: TestType.NONE,
                  ));
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
    );
  }
}

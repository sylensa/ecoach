import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot_introit_topics.dart';
import 'package:ecoach/views/autopilot_topic_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/adeo_outlined_button.dart';

class AutopilotIntroit extends StatefulWidget {
  AutopilotIntroit(this.user, this.course);

  final User user;
  final Course course;

  @override
  State<AutopilotIntroit> createState() => _AutopilotIntroitState();
}

class _AutopilotIntroitState extends State<AutopilotIntroit> {
  @override
  void initState() {
    print('AutopilotIntroit course ${widget.course.id}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 47.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Text(
                          'Welcome to Autopilot',
                          textAlign: TextAlign.center,
                          style:
                              kIntroitScreenHeadingStyle2(color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text(
                            'AI assistance  to help you complete this course, one topic at a time ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'poppins-mediumItalic',
                              fontStyle: FontStyle.italic,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Image.asset(
                          'assets/images/autopilot_intro.png',
                          width: 170,
                          height: 170,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 138.0),
                  child: AdeoOutlinedButton(
                    label: 'Get Started',
                    onPressed: () async {
                      List<TestNameAndCount> topics =
                          await TestController().getTopics(widget.course);

                      int count = await TestController()
                          .getQuestionsCount(widget.course.id!);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AutopilotIntroitTopics(
                                  count: count,
                                  controller: AutopilotController(
                                    widget.user,
                                    widget.course,
                                    topics: topics,
                                  ),
                                )),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

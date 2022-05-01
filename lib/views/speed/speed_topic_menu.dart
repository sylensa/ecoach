import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon/marathon_practise_mock.dart';
import 'package:ecoach/views/marathon/marathon_quiz_view.dart';

import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/marathon_mode_selector.dart';
import 'package:ecoach/widgets/speed_mode_selector.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/adeo_outlined_button.dart';

enum topics { TOPIC, MOCK }

class SpeedTopicMenu extends StatefulWidget {
  SpeedTopicMenu({this.topics = const [], required this.controller, this.time});
  MarathonController controller;
  List<TestNameAndCount> topics;
  int? time;

  @override
  State<SpeedTopicMenu> createState() => _SpeedTopicMenuState();
}

class _SpeedTopicMenuState extends State<SpeedTopicMenu> {
  late dynamic topicId;
  late MarathonController controller;
  int? next;

  @override
  void initState() {
    topicId = '';
    controller = widget.controller;
    super.initState();
  }

  handletopicSelection(newTopic) {
    setState(() {
      if (topicId == newTopic)
        topicId = '';
      else
        topicId = newTopic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoOrangeH,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 70),
            Text(
              'Select Your Topic',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDefaultBlack,
                fontSize: 33.sp,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: 33),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.topics.length; i++)
                        SpeedTopicSelector(
                          topicId: widget.topics[i].id!,
                          numberOfQuestions: widget.topics[i].totalCount,
                          label: widget.topics[i].name,
                          isSelected: topicId == widget.topics[i].id!,
                          isUnselected:
                              topicId != '' && topicId != widget.topics[i].id!,
                          onTap: (newTopic) {
                            setState(() {
                              if (topicId == newTopic)
                                topicId = '';
                              else
                                topicId = newTopic;
                              setState(() {
                                next = widget.topics[i].totalCount;
                              });
                            });
                          },
                          textcolor: Colors.white,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (topicId != '')
              Column(
                children: [
                  AdeoFilledButton(
                    label: 'Next',
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Instructions1(
                              topicId: topicId,
                              controller: controller,
                              noOfQuestion: next!,
                              time: widget.time,
                            );
                          },
                        ),
                      );
                    },
                    background: Colors.black12,
                    size: Sizes.large,
                  ),
                  SizedBox(height: 53),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Instructions1 extends StatelessWidget {
  Instructions1(
      {required this.controller,
      required this.topicId,
      required this.noOfQuestion,
      this.time});
  MarathonController controller;
  int topicId;
  int noOfQuestion;
  int? time;

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoOrangeH,
      backgroundImageURL: 'assets/images/pool_orange.png',
      pages: [
        getMarathonInstructionsLayout1(() async {
          await controller.createTopicMarathon(topicId);
          Topic? topic = await TopicDB().getTopicById(topicId);
          controller.name = topic!.name!;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Instructions2(
                  topicId: topicId,
                  controller: controller,
                  time: time,
                );
              },
            ),
          );
        }, noOfQuestion),
      ],
    );
  }
}

class Instructions2 extends StatelessWidget {
  Instructions2({required this.controller, required this.topicId, this.time});
  MarathonController controller;
  int topicId;

  int? time;

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoOrangeH,
      backgroundImageURL: 'assets/images/pool_orange.png',
      pages: [
        getMarathonInstructionsLayout2(() async {
          await controller.createTopicMarathon(topicId);
          Topic? topic = await TopicDB().getTopicById(topicId);
          controller.name = topic!.name!;

          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MarathonQuizView(
                  controller: controller,
                  themeColor: kAdeoOrangeH,
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

TestIntroitLayoutPage getMarathonInstructionsLayout1(
    Function onPressed, int noquestion) {
  return TestIntroitLayoutPage(
    foregroundColor: Colors.white,
    fontWeight: FontWeight.w700,
    title: '',
    middlePiece: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text('$noquestion',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black26,
                fontSize: 109.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: 7),
          Text(
            'Questions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 41.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    footer: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AdeoOutlinedButton(
          label: 'Next',
          onPressed: onPressed,
        )
      ],
    ),
  );
}

TestIntroitLayoutPage getMarathonInstructionsLayout2(Function onPressed) {
  return TestIntroitLayoutPage(
    foregroundColor: Colors.white,
    fontWeight: FontWeight.w700,
    title: 'Instructions',
    middlePiece: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          SizedBox(height: 7),
          Text(
            '1. Answer as many questions as possible.',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontStyle: FontStyle.normal,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7.h),
          Text(
            '2. The more questions you answer correctly, the higher your score.',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontStyle: FontStyle.normal,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7.h),
          Text(
            '3.  Test ends when time runs out ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontStyle: FontStyle.normal,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
        ],
      ),
    ),
    footer: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AdeoOutlinedButton(
          label: 'Start',
          onPressed: onPressed,
        )
      ],
    ),
  );
}

import 'dart:developer';

import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_question_count.dart';
import 'package:ecoach/views/treadmill/treadmill_save_resumption_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/mode_selector.dart';
import 'package:flutter/material.dart';

import '../../database/treadmill_db.dart';
import '../../models/treadmill.dart';

class TreadmillTopicsMenu extends StatefulWidget {
  TreadmillTopicsMenu({
    this.topics = const [],
    required this.controller,
  });

  final TreadmillController controller;
  final List<TestNameAndCount> topics;

  @override
  State<TreadmillTopicsMenu> createState() => _TreadmillTopicsMenuState();
}

class _TreadmillTopicsMenuState extends State<TreadmillTopicsMenu> {
  late dynamic topicId;
  late TreadmillController controller;

  Topic? topic;

  @override
  void initState() {
    topicId = '';
    controller = widget.controller;
    super.initState();
  }

  handleTopicSelection(newTopic) {
    setState(() {
      //topic = newTopic;
      if (topicId == newTopic.id)
        topicId = '';
      else {
        topicId = newTopic.id;
        controller.countQuestions = newTopic.totalCount;
      }
      print("topicId: $topicId");
    });
  }

  // handleNext() async {
  //   dynamic screenToNavigateTo;
  //   //TreadmillDB().deleteAll();

  //   Treadmill? treadmill =
  //       await TestController().getCurrentTreadmill(controller.course);
  //   print(treadmill);
  //   print(topicId);
  //   // return;

  //   if (treadmill == null) {
  //     screenToNavigateTo = TreadmillQuestionCount(
  //       topicId: topicId,
  //       count: controller.countQuestions,
  //       topic: topic,
  //       controller: controller,
  //       mode: TreadmillMode.TOPIC,
  //     );
  //   } else {
  //     print('jjjjjjjjjjjj');
  //     print(treadmill.toJson());
  //     print(treadmill.topicId);
  //     print('${controller.course.name}, ${topicId},${treadmill.title}');

  //     screenToNavigateTo = TreadmillSaveResumptionMenu(
  //       controller: TreadmillController(
  //         controller.user,
  //         controller.course,
  //         name: treadmill.title,
  //         treadmill: treadmill,
  //       ),
  //     );
  //   }

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return screenToNavigateTo;
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 70),
            Text(
              'Select Your Topic',
              textAlign: TextAlign.center,
              style: kIntroitScreenHeadingStyle(
                color: kAdeoLightTeal,
              ).copyWith(
                fontSize: 25,
              ),
            ),
            SizedBox(height: 33),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.topics.length; i++)
                        SubModeSelector(
                          id: widget.topics[i].id!,
                          numberOfQuestions: widget.topics[i].totalCount,
                          label: widget.topics[i].name,
                          isSelected:
                              topicId != '' && topicId == widget.topics[i].id!,
                          isUnselected:
                              topicId != '' && topicId != widget.topics[i].id!,
                          selectedBorderColor: kAdeoLightTeal,
                          onTap: (id) =>
                              {handleTopicSelection(widget.topics[i])},
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
                    background: kAdeoLightTeal,
                    size: Sizes.large,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TreadmillQuestionCount(
                              topicId: topicId,
                              count: controller.countQuestions,
                              topic: topic,
                              controller: controller,
                              mode: TreadmillMode.TOPIC,
                            );
                          },
                        ),
                      );
                    },
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

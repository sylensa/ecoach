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
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

enum topics { TOPIC, MOCK }

class MarathonPractiseTopicMenu extends StatefulWidget {
  MarathonPractiseTopicMenu({this.topics = const [], required this.controller});
  MarathonController controller;
  List<TestNameAndCount> topics;

  @override
  State<MarathonPractiseTopicMenu> createState() =>
      _MarathonPractiseTopicMenuState();
}

class _MarathonPractiseTopicMenuState extends State<MarathonPractiseTopicMenu> {
  late dynamic topicId;
  late MarathonController controller;

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
                color: kAdeoBlueAccent,
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
                        MarathonTopicSelector(
                          topicId: widget.topics[i].id!,
                          numberOfQuestions: widget.topics[i].totalCount,
                          label: widget.topics[i].name,
                          isSelected: topicId == widget.topics[i].id!,
                          isUnselected:
                              topicId != '' && topicId != widget.topics[i].id!,
                          onTap: handletopicSelection,
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
                            return Instructions(
                              topicId: topicId,
                              controller: controller,
                            );
                          },
                        ),
                      );
                    },
                    background: kAdeoBlue,
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

class Instructions extends StatelessWidget {
  Instructions({required this.controller, required this.topicId});
  MarathonController controller;
  int topicId;

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_blue_2.png',
      pages: [
        getMarathonInstructionsLayout(() async {
          showLoaderDialog(context, message: "Creating marathon");
          await controller.createTopicMarathon(topicId);
          Topic? topic = await TopicDB().getTopicById(topicId);
          controller.name = topic!.name!;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MarathonQuizView(controller: controller);
              },
            ),
          );
        }),
      ],
    );
  }
}

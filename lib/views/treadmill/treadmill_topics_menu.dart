import 'dart:developer';

import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_question_count.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/mode_selector.dart';
import 'package:flutter/material.dart';

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
  int count = 0;

  @override
  void initState() {
    topicId = '';
    controller = widget.controller;
    super.initState();
  }

  handleTopicSelection(newTopic) {
    setState(() {
      if (topicId == newTopic.id)
        topicId = '';
      else {
        topicId = newTopic.id;
        count = newTopic.totalCount;
      }
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
                              count: count,
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

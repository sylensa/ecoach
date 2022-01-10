import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon_practise_mock.dart';
import 'package:ecoach/views/marathon_quiz_view.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/marathon_mode_selector.dart';
import 'package:flutter/material.dart';

enum topics { TOPIC, MOCK }

class MarathonPractiseTopicMenu extends StatefulWidget {
  @override
  State<MarathonPractiseTopicMenu> createState() =>
      _MarathonPractiseTopicMenuState();
}

class _MarathonPractiseTopicMenuState extends State<MarathonPractiseTopicMenu> {
  late dynamic topicId;

  @override
  void initState() {
    topicId = '';
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
                      MarathonTopicSelector(
                        topicId: 1,
                        numberOfQuestions: 2500,
                        label: 'Acids',
                        isSelected: topicId == 1,
                        isUnselected: topicId != '' && topicId != 1,
                        onTap: handletopicSelection,
                      ),
                      // SizedBox(height: 20),
                      MarathonTopicSelector(
                        topicId: 2,
                        numberOfQuestions: 2500,
                        label: 'Bases',
                        isSelected: topicId == 2,
                        isUnselected: topicId != '' && topicId != 2,
                        onTap: handletopicSelection,
                      ),
                      // SizedBox(height: 20),
                      MarathonTopicSelector(
                        topicId: 3,
                        numberOfQuestions: 2500,
                        label: 'Capillarity',
                        isSelected: topicId == 3,
                        isUnselected: topicId != '' && topicId != 3,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Instructions();
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
  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_blue_2.png',
      pages: [
        getMarathonInstructionsLayout(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MarathonQuizView();
              },
            ),
          );
        }),
      ],
    );
  }
}

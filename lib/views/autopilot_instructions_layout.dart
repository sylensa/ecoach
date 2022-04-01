import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot_topic_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:flutter/material.dart';

class AutopilotInstructionsLayout extends StatefulWidget {
  AutopilotInstructionsLayout({this.count = 0, required this.controller});
  final AutopilotController controller;

  final int count;

  @override
  State createState() => AutopilotInstructionsLayoutState();
}

class AutopilotInstructionsLayoutState
    extends State<AutopilotInstructionsLayout> {
  late AutopilotController controller;

  //what about i use async await to get them and pass them

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  handleNext() async {
    print('name from topic_menu ${widget.controller.name}');
    List<TestNameAndCount> topics =
        await TestController().getTopics(widget.controller.course);

    for (int i = 0; i < topics.length; i++) {
      topics[i].count = await controller.getTopicTotalCorrect(topics[i].id);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AutopilotTopicMenu(topics: topics, controller: widget.controller);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_orange.png',
      pages: [
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          fontWeight: FontWeight.w700,
          title: 'Instructions',
          middlePiece: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 7),
                Text(
                  '1. This is autopilot',
                  style: kCustomizedTestSubtextStyle.copyWith(
                    color: Colors.white.withOpacity(0.68),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 7),
                Text(
                  '2. Prepare adequately before starting',
                  style: kCustomizedTestSubtextStyle.copyWith(
                    color: Colors.white.withOpacity(0.68),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 7),
                Text(
                  '3. Try out every question',
                  style: kCustomizedTestSubtextStyle.copyWith(
                    color: Colors.white.withOpacity(0.68),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 7),
                Text(
                  '4. Pause and continue anytime',
                  style: kCustomizedTestSubtextStyle.copyWith(
                    color: Colors.white.withOpacity(0.68),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 7),
              ],
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset('assets/icons/courses/auto.png'),
                iconSize: 80,
                onPressed: handleNext,
              ),
              /* AdeoFilledButton(
                color: Colors.white,
                background: kAdeoOrange,
                label: 'Let\'s go',
                onPressed: null,
              ) */
            ],
          ),
        )
      ],
    );
  }
}

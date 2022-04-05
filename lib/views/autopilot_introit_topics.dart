import 'package:ecoach/controllers/autopilot_controller.dart';

import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot_introit_questions.dart';

import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';

import 'package:flutter/material.dart';

class AutopilotIntroitTopics extends StatefulWidget {
  AutopilotIntroitTopics({this.count = 0, required this.controller});
  AutopilotController controller;
  int count;

  @override
  State<AutopilotIntroitTopics> createState() => _AutopilotIntroitTopicsState();
}

class _AutopilotIntroitTopicsState extends State<AutopilotIntroitTopics> {
  late AutopilotController controller;
  late int count;

  handleNext() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AutopilotIntroitQuestions(
        count: widget.count,
        controller: controller,
      );
    }));
  }

  @override
  void initState() {
    controller = widget.controller;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_orange.png',
      pages: [
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          middlePiece: Column(
            children: [
              SizedBox(height: 40),
              Text(
                "${controller.numberOfTopics}",
                style: TextStyle(
                  fontSize: 109,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Text(
                'Topics',
                style: TextStyle(
                  fontSize: 41,
                  fontFamily: 'Hamelin',
                  color: Colors.white,
                ),
              )
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoFilledButton(
                color: Colors.white,
                background: kAdeoOrange,
                label: 'Next',
                onPressed: handleNext,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

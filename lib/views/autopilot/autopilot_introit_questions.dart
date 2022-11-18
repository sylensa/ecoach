import 'package:ecoach/controllers/autopilot_controller.dart';

import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_instructions_layout.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:flutter/material.dart';

class AutopilotIntroitQuestions extends StatefulWidget {
  AutopilotIntroitQuestions({this.count = 0, required this.controller});
  AutopilotController controller;

  int count;

  @override
  State<AutopilotIntroitQuestions> createState() =>
      _AutopilotIntroitQuestionsState();
}

class _AutopilotIntroitQuestionsState extends State<AutopilotIntroitQuestions> {
  late AutopilotController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
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
                "${widget.count}",
                style: TextStyle(
                  fontSize: 109,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Text(
                'Questions',
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
                background: kAdeoOrange2,
                label: 'Next',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AutopilotInstructionsLayout(
                              count: widget.count,
                              controller: controller,
                            )),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

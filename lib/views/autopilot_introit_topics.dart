import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot_introit_questions.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/widgets.dart';
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
    print('welcome to autopilot introit topics');
    print('topics from are ' + controller.topics.toString());
    //print('topic name from introit topics = ${controller.topics[0].name}');
    print('from introit to topics no of questions is: ${widget.count}');
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
                "${widget.controller.topics.length}",
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
        /* getAutopilotInstructionsLayout(() async {
          showLoaderDialog(context, message: "Creating marathon");
          await controller.createAutopilot();
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AutopilotQuizView(controller: controller);
              },
            ),
          );
        } ),*/
      ],
    );
  }
}

/* TestIntroitLayoutPage getAutopilotInstructionsLayout(Function onPressed) {
  return TestIntroitLayoutPage(
    foregroundColor: Colors.white,
    fontWeight: FontWeight.w700,
    title: 'Instructions',
    middlePiece: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SizedBox(height: 7),
          Text(
            '1. This is a marathon.',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '2. There is no test duration',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '3. Finish faster for a higher ranking',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '4. Answer questions correctly to make progress',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '5. You can only complete the marathon by answering every question correctly',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
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
          color: kAdeoBlue,
          label: 'Start',
          onPressed: onPressed,
        )
      ],
    ),
  );
}
 */
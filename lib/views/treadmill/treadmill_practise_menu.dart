import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_bank_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_question_count.dart';
import 'package:ecoach/views/treadmill/treadmill_topics_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/mode_selector.dart';
import 'package:flutter/material.dart';

import '../../models/treadmill.dart';
import '../../widgets/widgets.dart';

class TreadmillPractiseMenu extends StatefulWidget {
  TreadmillPractiseMenu({
    Key? key,
    required this.controller,
    // required this.mode,
  }) : super(key: key);

  final TreadmillController controller;
  // final TreadmillMode mode;
  @override
  State<TreadmillPractiseMenu> createState() => _TreadmillPractiseMenuState();
}

class _TreadmillPractiseMenuState extends State<TreadmillPractiseMenu> {
  late dynamic mode;
  late TreadmillController controller;

  @override
  void initState() {
    mode = '';
    controller = widget.controller;
    super.initState();
    // print(widget.mode);
  }

  handleModeSelection(newMode) {
    setState(() {
      if (mode == newMode)
        mode = '';
      else
        mode = newMode;
    });
  }

  handleNext() async {
    dynamic screenToNavigateTo;

    switch (mode) {
      case TreadmillMode.TOPIC:
        showLoaderDialog(context);
        // Navigator.pop(context);
        List<TestNameAndCount> topics = await TestController().getTopics(
          controller.course,
        );

        screenToNavigateTo = TreadmillTopicsMenu(
          mode: mode,
          topics: topics,
          controller: controller,
        );

        // controller.treadmillType = TreadmillType.TOPIC;
        controller.treadmillType = 'TOPIC';
        break;
      case TreadmillMode.MOCK:
        showLoaderDialog(context);
        int count = await QuestionDB().getTotalQuestionCount(
          controller.course.id!,
        );
        screenToNavigateTo = TreadmillQuestionCount(
          count: count,
          controller: controller,
          mode: TreadmillMode.MOCK,
        );
        //controller.treadmillType = TreadmillType.MOCK;
        controller.treadmillType = 'MOCK';
        break;
      case TreadmillMode.BANK:
        showLoaderDialog(context);
        List<TestNameAndCount> banks = await TestController().getBankTest(
          controller.course,
        );
        // screenToNavigateTo = TreadmillBankMenu(
        //   banks: banks,
        //   controller: controller,
        // );
        screenToNavigateTo = TreadmillTopicsMenu(
            topics: banks, controller: controller, mode: mode);
        // controller.treadmillType = TreadmillType.BANK;
        controller.treadmillType = 'BANK';

        break;
    }
    //  showLoaderDialog(context);
    goTo(context, screenToNavigateTo, replace: true);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return screenToNavigateTo;
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 70),
                      Text(
                        'Select your mode',
                        textAlign: TextAlign.center,
                        style: kIntroitScreenHeadingStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Choose your preferred treadmill mode',
                        textAlign: TextAlign.center,
                        style:
                            kIntroitScreenSubHeadingStyle(color: Colors.white),
                      ),
                      SizedBox(height: 65),
                      ModeSelector(
                        label: 'Topic',
                        mode: TreadmillMode.TOPIC,
                        isSelected: mode == TreadmillMode.TOPIC,
                        isUnselected: mode != '' && mode != TreadmillMode.TOPIC,
                        onTap: handleModeSelection,
                        activeBorderColor: kAdeoLightTeal,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        label: 'Mock',
                        mode: TreadmillMode.MOCK,
                        isSelected: mode == TreadmillMode.MOCK,
                        isUnselected: mode != '' && mode != TreadmillMode.MOCK,
                        onTap: handleModeSelection,
                        activeBorderColor: kAdeoLightTeal,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        label: 'Bank',
                        mode: TreadmillMode.BANK,
                        isSelected: mode == TreadmillMode.BANK,
                        isUnselected: mode != '' && mode != TreadmillMode.BANK,
                        onTap: handleModeSelection,
                        activeBorderColor: kAdeoLightTeal,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (mode != '')
              Column(
                children: [
                  AdeoFilledButton(
                    label: 'Next',
                    onPressed: handleNext,
                    background: kAdeoLightTeal,
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

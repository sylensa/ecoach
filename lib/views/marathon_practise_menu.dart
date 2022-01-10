import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon_practise_mock.dart';
import 'package:ecoach/views/marathon_practise_topic_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/marathon_mode_selector.dart';
import 'package:flutter/material.dart';

enum Modes { TOPIC, MOCK }

class MarathonPractiseMenu extends StatefulWidget {
  @override
  State<MarathonPractiseMenu> createState() => _MarathonPractiseMenuState();
}

class _MarathonPractiseMenuState extends State<MarathonPractiseMenu> {
  late dynamic mode;

  @override
  void initState() {
    mode = '';
    super.initState();
  }

  handleModeSelection(newMode) {
    setState(() {
      if (mode == newMode)
        mode = '';
      else
        mode = newMode;
    });
  }

  handleNext() {
    dynamic screenToNavigateTo;

    switch (mode) {
      case Modes.TOPIC:
        screenToNavigateTo = MarathonPractiseTopicMenu();
        break;
      case Modes.MOCK:
        screenToNavigateTo = MarathonPractiseMock();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return screenToNavigateTo;
        },
      ),
    );
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
                        'Choose your preferred timing',
                        textAlign: TextAlign.center,
                        style:
                            kIntroitScreenSubHeadingStyle(color: Colors.white),
                      ),
                      SizedBox(height: 65),
                      MarathonModeSelector(
                        label: 'Topic',
                        mode: Modes.TOPIC,
                        isSelected: mode == Modes.TOPIC,
                        isUnselected: mode != '' && mode != Modes.TOPIC,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      MarathonModeSelector(
                        label: 'Mock',
                        mode: Modes.MOCK,
                        isSelected: mode == Modes.MOCK,
                        isUnselected: mode != '' && mode != Modes.MOCK,
                        onTap: handleModeSelection,
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

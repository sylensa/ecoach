import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon/marathon_completed.dart';
import 'package:ecoach/views/marathon/marathon_live.dart';

import 'package:ecoach/views/marathon/marathon_practise_menu.dart';
import 'package:ecoach/views/marathon/marathon_save_resumption_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/mode_selector.dart';
import 'package:flutter/material.dart';

class MarathonIntroit extends StatefulWidget {
  MarathonIntroit(this.user, this.course);

  final User user;
  final Course course;
  static const String routeName = '/marathon-introit';

  @override
  State<MarathonIntroit> createState() => _MarathonIntroitState();
}

class _MarathonIntroitState extends State<MarathonIntroit> {
  late dynamic mode;

  @override
  void initState() {
    mode = '';
    super.initState();
  }

  handleModeSelection(TestMode newMode) {
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
      case TestMode.LIVE:
        screenToNavigateTo = MarathonLive();
        break;
      case TestMode.PRACTISE:
        Marathon? marathon =
            await TestController().getCurrentMarathon(widget.course);
        if (marathon == null) {
          screenToNavigateTo = MarathonPractiseMenu(
            controller: MarathonController(
              widget.user,
              widget.course,
              name: widget.course.name!,
            ),
          );
        } else {
          print(marathon.toJson());
          screenToNavigateTo = MarathonSaveResumptionMenu(
            controller: MarathonController(widget.user, widget.course,
                name: widget.course.name!),
          );
        }

        break;
      case TestMode.COMPLETED:
        screenToNavigateTo = MarathonCompleted(widget.user, widget.course);
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
                        'Choose your preferred marathon',
                        textAlign: TextAlign.center,
                        style:
                            kIntroitScreenSubHeadingStyle(color: Colors.white),
                      ),
                      SizedBox(height: 65),
                      ModeSelector(
                        label: 'Live',
                        mode: TestMode.LIVE,
                        isSelected: mode == TestMode.LIVE,
                        isUnselected: mode != '' && mode != TestMode.LIVE,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        label: 'Practise',
                        mode: TestMode.PRACTISE,
                        isSelected: mode == TestMode.PRACTISE,
                        isUnselected: mode != '' && mode != TestMode.PRACTISE,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        label: 'Completed',
                        mode: TestMode.COMPLETED,
                        isSelected: mode == TestMode.COMPLETED,
                        isUnselected: mode != '' && mode != TestMode.COMPLETED,
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

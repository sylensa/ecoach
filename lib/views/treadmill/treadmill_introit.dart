import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_practise_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_completed.dart';
import 'package:ecoach/views/treadmill/treadmill_live.dart';
import 'package:ecoach/views/treadmill/treadmill_save_resumption_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/mode_selector.dart';
import 'package:flutter/material.dart';

class TreadmillIntroit extends StatefulWidget {
  TreadmillIntroit(this.user, this.course, this.mode);

  final User user;
  final Course course;
  final TreadmillMode? mode;

  @override
  State<TreadmillIntroit> createState() => _TreadmillIntroitState();
}

class _TreadmillIntroitState extends State<TreadmillIntroit> {
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
        screenToNavigateTo = TreadmillLive();
        break;
      case TestMode.PRACTISE:
        print("Testing");
        // screenToNavigateTo = TreadmillPractiseMenu(
        //   controller: TreadmillController(
        //     widget.user,
        //     widget.course,
        //     name: widget.course.name!,
        //   ),
        // );
        // Treadmill? treadmill =
        //     await TestController().getCurrentTreadmill(widget.course);
        // print(treadmill!.toJson());

        // if (treadmill == null) {
        screenToNavigateTo = TreadmillPractiseMenu(
          controller: TreadmillController(
            widget.user,
            widget.course,
            name: widget.course.name!,
          ),
          // mode: widget.mode!,
        );
        // } else {
        //   print('jjjjjjjjjjjj');
        //   print(treadmill.toJson());
        //   print(treadmill.topicId);

        //   screenToNavigateTo = TreadmillSaveResumptionMenu(
        //     controller: TreadmillController(
        //       widget.user,
        //       widget.course,
        //       name: widget.course.name!,
        //       treadmill: treadmill,
        //     ),
        //   );
        // }
        break;
      case TestMode.COMPLETED:
        screenToNavigateTo = TreadmillCompleted(widget.user, widget.course);
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
                      ModeSelector(
                        label: 'Live',
                        mode: TestMode.LIVE,
                        isSelected: mode == TestMode.LIVE,
                        isUnselected: mode != '' && mode != TestMode.LIVE,
                        onTap: handleModeSelection,
                        activeBorderColor: kAdeoLightTeal,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        label: 'Practise',
                        mode: TestMode.PRACTISE,
                        isSelected: mode == TestMode.PRACTISE,
                        isUnselected: mode != '' && mode != TestMode.PRACTISE,
                        onTap: handleModeSelection,
                        activeBorderColor: kAdeoLightTeal,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        label: 'Completed',
                        mode: TestMode.COMPLETED,
                        isSelected: mode == TestMode.COMPLETED,
                        isUnselected: mode != '' && mode != TestMode.COMPLETED,
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

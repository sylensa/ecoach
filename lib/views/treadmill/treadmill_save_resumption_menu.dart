import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_completed.dart';
import 'package:ecoach/views/treadmill/treadmill_countdown.dart';
import 'package:ecoach/views/treadmill/treadmill_practise_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/mode_selector.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../database/treadmill_db.dart';

class TreadmillSaveResumptionMenu extends StatefulWidget {
  TreadmillSaveResumptionMenu({required this.controller});
  final TreadmillController controller;

  @override
  State<TreadmillSaveResumptionMenu> createState() =>
      _TreadmillSaveResumptionMenuState();
}

class _TreadmillSaveResumptionMenuState
    extends State<TreadmillSaveResumptionMenu> {
  late dynamic mode;

  @override
  void initState() {
    mode = '';
    super.initState();
  }

  handleModeSelection(TestMode newMode) {
    setState(() {
      if (mode == newMode) {
        mode = '';
      } else {
        mode = newMode;
      }
    });
  }

  handleNext() async {
    switch (mode) {
      case TestMode.CONTINUE:
        showLoaderDialog(context, message: "loading runs");
        bool success = await widget.controller.loadTreadmill();
        Navigator.pop(context);

        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) {
              return TreadmillCountdown(controller: widget.controller);
            }),
          );
        } else {
          AdeoDialog(
            title: "No Treadmill",
            content:
                "No treadmill was found for this course. Kindly start over",
            actions: [
              AdeoDialogAction(
                label: "Ok",
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
        break;
      case TestMode.NEW:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Caution(
                controller_treadmill: widget.controller,
              );
            },
          ),
        );
        break;
      case TestMode.COMPLETED:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TreadmillCompleted(
                widget.controller.user,
                widget.controller.course,
              );
            },
          ),
        );
        break;
    }
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
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: kIntroitScreenHeadingStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'We saved your session so you can continue',
                        textAlign: TextAlign.center,
                        style:
                            kIntroitScreenSubHeadingStyle(color: Colors.white),
                      ),
                      SizedBox(height: 65),
                      ModeSelector(
                        size: Sizes.small,
                        label: 'Continue',
                        mode: TestMode.CONTINUE,
                        isSelected: mode == TestMode.CONTINUE,
                        isUnselected: mode != '' && mode != TestMode.CONTINUE,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        size: Sizes.small,
                        label: 'New Run',
                        mode: TestMode.NEW,
                        isSelected: mode == TestMode.NEW,
                        isUnselected: mode != '' && mode != TestMode.NEW,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      ModeSelector(
                        size: Sizes.small,
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

class Caution extends StatelessWidget {
  Caution({Key? key, required this.controller_treadmill}) : super(key: key);
  TreadmillController controller_treadmill;

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      padTop: PadTop.MILD,
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_light_teal.png',
      pages: [
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          fontWeight: FontWeight.w700,
          title: 'Caution',
          middlePiece: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                SizedBox(height: 7),
                Text(
                  'You will lose your saved treadmill session\nonce you begin a new one.',
                  style: kCustomizedTestSubtextStyle.copyWith(
                    color: kAdeoBlueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Click on CONTINUE if you wish to do so. \nIf not kindly go back to your old Treadmill',
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
                label: 'Continue',
                onPressed: () async {
                  showLoaderDialog(context, message: "Deleting Treadmill");
                  //restart
                  await controller_treadmill.restartTreadmill();

                  // await controller_treadmill.deleteTreadmill();
                  // controller_treadmill.treadmill!.status =
                  //     TreadmillStatus.COMPLETED.toString();
                  // controller_treadmill.treadmill!.endTime = DateTime.now();
                  // TreadmillDB().update(controller_treadmill.treadmill!);
                  // // controller.treadmill;
                  // // await controller.endTreadmill();
                  // List<TreadmillProgress> questions = [];
                  // questions = await TreadmillDB()
                  //     .getProgresses(controller_treadmill.treadmill!.id!);
                  // print(questions);
                  // await TreadmillDB()
                  //     .delete(controller_treadmill.treadmill!.id!);
                  // for (int i = 0; i < questions.length; i++) {
                  //   await TreadmillDB().deleteProgress(questions[i].id!);
                  //   //await TreadmillDB().delete(treadmill!.id!);
                  // }
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) {
                      return TreadmillCountdown(
                          controller: controller_treadmill);
                      // return TreadmillPractiseMenu(
                      //   controller: TreadmillController(
                      //     controller_treadmill.user,
                      //     controller_treadmill.course,
                      //     name: controller_treadmill.course.name,
                      //   ),
                      // );
                    }),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}

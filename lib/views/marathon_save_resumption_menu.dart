import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon_completed.dart';
import 'package:ecoach/views/marathon_countdown.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/marathon_mode_selector.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MarathonSaveResumptionMenu extends StatefulWidget {
  MarathonSaveResumptionMenu({required this.controller});
  MarathonController controller;

  @override
  State<MarathonSaveResumptionMenu> createState() =>
      _MarathonSaveResumptionMenuState();
}

class _MarathonSaveResumptionMenuState
    extends State<MarathonSaveResumptionMenu> {
  late dynamic mode;

  @override
  void initState() {
    mode = '';
    super.initState();
  }

  handleModeSelection(MarathonModes newMode) {
    setState(() {
      if (mode == newMode)
        mode = '';
      else
        mode = newMode;
    });
  }

  continueMarathon() {}

  openCompletedMarathon() {}

  handleNext() async {
    switch (mode) {
      case MarathonModes.CONTINUE:
        showLoaderDialog(context, message: "loading marathon");
        bool success = await widget.controller.loadMarathon();
        Navigator.pop(context);

        if (success) {
          Navigator.push(context, MaterialPageRoute(builder: (c) {
            return MarathonCountdown(controller: widget.controller);
          }));
        } else {
          AdeoDialog(
            title: "No marathon",
            content: "No marathon was found for this course. Kindly start over",
            actions: [
              AdeoDialogAction(
                  label: "Ok",
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        }

        break;
      case MarathonModes.NEW_MARATHON:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Caution(
                controller: widget.controller,
              );
            },
          ),
        );
        break;
      case MarathonModes.COMPLETED:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MarathonCompleted(
                  widget.controller.user, widget.controller.course);
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
                      MarathonModeSelector(
                        size: Sizes.small,
                        label: 'Continue',
                        mode: MarathonModes.CONTINUE,
                        isSelected: mode == MarathonModes.CONTINUE,
                        isUnselected:
                            mode != '' && mode != MarathonModes.CONTINUE,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      MarathonModeSelector(
                        size: Sizes.small,
                        label: 'New Marathon',
                        mode: MarathonModes.NEW_MARATHON,
                        isSelected: mode == MarathonModes.NEW_MARATHON,
                        isUnselected:
                            mode != '' && mode != MarathonModes.NEW_MARATHON,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      MarathonModeSelector(
                        size: Sizes.small,
                        label: 'Completed',
                        mode: MarathonModes.COMPLETED,
                        isSelected: mode == MarathonModes.COMPLETED,
                        isUnselected:
                            mode != '' && mode != MarathonModes.COMPLETED,
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
  Caution({required this.controller});
  MarathonController controller;

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      padTop: PadTop.MILD,
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_blue_2.png',
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
                  'You will lose your saved marathon session\nonce you begin a new marathon.',
                  style: kCustomizedTestSubtextStyle.copyWith(
                    color: kAdeoBlueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Click on CONTINUE if you wish to do so. \nIf not kindly go back to your old marathon',
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
                  showLoaderDialog(context, message: "Restarting marathon");
                  await controller.restartMarathon();
                  Navigator.pop(context);

                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return MarathonCountdown(controller: controller);
                  }));
                },
              )
            ],
          ),
        )
      ],
    );
  }
}

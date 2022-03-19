import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AutopilotIntroit extends StatefulWidget {
  AutopilotIntroit(this.user, this.course);

  final User user;
  final Course course;

  @override
  State<AutopilotIntroit> createState() => _AutopilotIntroitState();
}

class _AutopilotIntroitState extends State<AutopilotIntroit> {
  handleNext() {
    print("next screen");
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
                      'Welcome to Autopilot',
                      textAlign: TextAlign.center,
                      style: kIntroitScreenHeadingStyle(color: Colors.white),
                    ),
                    SizedBox(height: 70),
                    Text(
                      'AI assistance  to help you complete this course, one topic at a time ',
                      textAlign: TextAlign.center,
                      style: kIntroitScreenSubHeadingStyle(color: Colors.white),
                    ),
                    Image.asset(
                      'assets/images/autopilot_intro.png',
                      width: 200,
                      height: 400,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 53),
                    AdeoFilledButton(
                      label: 'Next',
                      onPressed: handleNext,
                      background: kAdeoBlue,
                      size: Sizes.large,
                    ),
                  ],
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

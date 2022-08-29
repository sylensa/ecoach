import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_introit.dart';
import 'package:ecoach/views/treadmill/treadmill_time_and_instruction.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class TreadmillWelcome extends StatelessWidget {
  TreadmillWelcome({
    //   required this.controller,
    //   required this.mode,
    //   this.topicId,
    //   this.bankId,
    //   this.bankName,
    required this.user,
    required this.course,
  });

  // final TreadmillController controller;
  // final TreadmillMode mode;
  // final int? topicId;
  // final int? bankId;
  // final String? bankName;
  final User user;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 64,
        ),
        child: Column(
          children: [
            Text(
              'Welcome to treadmill',
              textAlign: TextAlign.center,
              style: kIntroitScreenHeadingStyle(
                color: Colors.white,
              ).copyWith(fontSize: 32),
            ),
            SizedBox(height: 40),
            Text(
              'Crank up the speed, performance under pressure',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 72),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/treadmill_welcome_img.png',
                ),
              ),
            ),
            SizedBox(height: 48),
            AdeoOutlinedButton(
              label: 'Get Started',
              fontSize: 29,
              fontWeight: FontWeight.normal,
              borderColor: kAdeoLightTeal,
              color: Colors.white,
              size: Sizes.small,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TreadmillIntroit(user, course, null),
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return TreadmillTimeAndInstruction(
                //         topicId: topicId,
                //         bankId: bankId,
                //         bankName: bankName,
                //         controller: controller,
                //         mode: mode,
                //       );
                //     },
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}

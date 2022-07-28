import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:flutter/material.dart';

import '../../controllers/treadmill_controller.dart';
import '../../utils/style_sheet.dart';
import '../../widgets/adeo_outlined_button.dart';
import '../../widgets/layouts/test_introit_layout.dart';
import '../../widgets/widgets.dart';

class Caution extends StatelessWidget {
  Caution({required this.controller});
  TreadmillController controller;

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
                  showLoaderDialog(context, message: "Restarting Treadmill");
                  //restart
                  await controller.restartTreadmill();
                  Future<dynamic> b = controller.deleteTreadmill();
                  print('${b}');
                  //controller.endTreadmill();

                  //controller.deleteTreadmill();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) {
                      return TreadmillWelcome(
                        user: controller.user,
                        course: controller.course,
                      );
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

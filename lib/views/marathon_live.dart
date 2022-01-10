import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:flutter/material.dart';

class MarathonLive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_blue_2.png',
      padTop: PadTop.FULL,
      pages: [
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          fontWeight: FontWeight.w700,
          title: 'coming soon',
          middlePiece: Container(),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                color: kAdeoBlue,
                label: 'Back',
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

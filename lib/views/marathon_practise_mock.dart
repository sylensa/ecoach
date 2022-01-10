import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon_quiz_view.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:flutter/material.dart';

class MarathonPractiseMock extends StatefulWidget {
  @override
  State<MarathonPractiseMock> createState() => _MarathonPractiseMockState();
}

class _MarathonPractiseMockState extends State<MarathonPractiseMock> {
  String durationLeft = '';
  String durationRight = '';
  String duration = '';

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_blue_2.png',
      pages: [
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          middlePiece: Column(
            children: [
              SizedBox(height: 40),
              Text(
                '1300',
                style: TextStyle(
                  fontSize: 109,
                  fontWeight: FontWeight.w600,
                  color: kAdeoBlueAccent,
                ),
              ),
              Text(
                'Questions',
                style: TextStyle(
                  fontSize: 41,
                  fontFamily: 'Hamelin',
                ),
              )
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                color: kAdeoBlue,
                label: 'Next',
                onPressed: () {
                  TestIntroitLayout.goForward();
                },
              )
            ],
          ),
        ),
        getMarathonInstructionsLayout(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MarathonQuizView();
              },
            ),
          );
        }),
      ],
    );
  }
}

TestIntroitLayoutPage getMarathonInstructionsLayout(Function onPressed) {
  return TestIntroitLayoutPage(
    foregroundColor: Colors.white,
    fontWeight: FontWeight.w700,
    title: 'Instructions',
    middlePiece: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SizedBox(height: 7),
          Text(
            '1. This is a marathon.',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '2. There is no test duration',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '3. Finish faster for a higher ranking',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '4. Answer questions correctly to make progress',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoBlueAccent,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '5. You can only complete the marathon by answering every question correctly',
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
          label: 'Start',
          onPressed: onPressed,
        )
      ],
    ),
  );
}

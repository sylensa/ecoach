import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/customized_test_new_screen.dart';
import 'package:ecoach/widgets/buttons/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:flutter/material.dart';

class CustomizedTestQuestionMode extends StatelessWidget {
  const CustomizedTestQuestionMode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoTaupe,
      backgroundImageURL: 'assets/images/deep_pool_taupe.png',
      pages: [
        TestIntroitLayoutPage(
          title: 'Time',
          subText: 'Allocation per question',
          middlePiece: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Quaye, your custom number picker comes here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDefaultBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          footer: AdeoOutlinedButton(
            label: 'Next',
            onPressed: TestIntroitLayout.goForward,
          ),
        ),
        TestIntroitLayoutPage(
          title: 'Questions',
          subText: 'Enter your preferred number',
          middlePiece: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Quaye, your custom number picker comes here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDefaultBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                label: 'Previous',
                onPressed: TestIntroitLayout.goBack,
              ),
              SizedBox(width: 8.0),
              AdeoOutlinedButton(
                label: 'Next',
                onPressed: TestIntroitLayout.goForward,
              )
            ],
          ),
        ),
        getInstructionsPage(context),
      ],
    );
  }

  TestIntroitLayoutPage getInstructionsPage(BuildContext context) {
    return TestIntroitLayoutPage(
      title: 'Instructions',
      middlePiece: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            SizedBox(height: 11),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '1.',
                  style: kCustomizedTestSubtextStyle,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'When the time on a question runs out, it moves to the next question',
                    style: kCustomizedTestSubtextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '2.',
                  style: kCustomizedTestSubtextStyle,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'You cannot jump or skip a question ',
                    style: kCustomizedTestSubtextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '3.',
                  style: kCustomizedTestSubtextStyle,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Once you choose an answer option it can\'t be changed, you move automatically to the next',
                    style: kCustomizedTestSubtextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdeoOutlinedButton(
            label: 'Previous',
            onPressed: TestIntroitLayout.goBack,
          ),
          SizedBox(width: 8.0),
          AdeoOutlinedButton(
            label: 'Start',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CustomizedTestScreen();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

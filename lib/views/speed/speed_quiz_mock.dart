import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon/marathon_quiz_view.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SpeedQuizMock extends StatefulWidget {
  SpeedQuizMock({this.count = 0, required this.controller});
  MarathonController controller;

  int count;

  @override
  State<SpeedQuizMock> createState() => _SpeedQuizMockState();
}

class _SpeedQuizMockState extends State<SpeedQuizMock> {
  late MarathonController controller;

  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoOrangeH,
      backgroundImageURL: 'assets/images/deep_pool_orange_h.png',
      pages: [
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          middlePiece: Column(
            children: [
              SizedBox(height: 40),
              Text(
                widget.count.toString(),
                style: TextStyle(
                  fontSize: 109,
                  fontWeight: FontWeight.w600,
                  color: Colors.white24,
                ),
              ),
              Text(
                'Questions',
                style: TextStyle(
                    fontSize: 41,
                    fontFamily: 'Cocon',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                color: Colors.white,
                label: 'Next',
                onPressed: () {
                  TestIntroitLayout.goForward();
                },
              )
            ],
          ),
        ),
        getMarathonInstructionsLayout(() async {
          showLoaderDialog(context, message: "Creating Speed Quiz");
          await controller.createMarathon();
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MarathonQuizView(
                  controller: controller,
                  themeColor: kAdeoOrangeH,
                );
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
            '1. Answer as many questions as possible ',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '2. The more questions you answer correctly, the higher your score. ',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '3. Test ends when time runs out ',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: Colors.white70,
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
          color: Colors.white,
          label: 'Start',
          onPressed: onPressed,
        )
      ],
    ),
  );
}

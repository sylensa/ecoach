import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';

class SpeedTestIntroit extends StatefulWidget {
  final User user;
  final Course course;

  const SpeedTestIntroit({
    Key? key,
    required this.user,
    required this.course,
  }) : super(key: key);

  @override
  State<SpeedTestIntroit> createState() => _SpeedTestIntroitState();
}

class _SpeedTestIntroitState extends State<SpeedTestIntroit> {
  String durationLeft = '';
  String durationRight = '';
  String duration = '';

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAnalysisInfoSnippetBackground3,
      backgroundImageURL: 'assets/images/deep_pool_teal.png',
      pages: [
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          fontWeight: FontWeight.w700,
          title: 'Time',
          subText: 'Allocation per question',
          middlePiece: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    child: PinInput(
                      length: 2,
                      onChanged: (v) {
                        setState(() {
                          durationLeft = v.split('').join('');
                        });
                      },
                    ),
                  ),
                  Text(':', style: kPinInputTextStyle),
                  Container(
                    width: 120.0,
                    child: PinInput(
                      autoFocus: durationLeft.length == 2,
                      length: 2,
                      onChanged: (v) {
                        setState(() {
                          durationRight = v.split('').join('');
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                label: 'start',
                onPressed: () {
                  if (durationRight.length > 0) {
                    TestIntroitLayout.goForward();
                  } else
                    showFeedback(
                      context,
                      'Enter a valid duration',
                    );
                },
              )
            ],
          ),
        ),
        TestIntroitLayoutPage(
          foregroundColor: Colors.white,
          fontWeight: FontWeight.w700,
          title: 'Speed Test',
          middlePiece: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 37),
                Text(
                  'Test type: Topic',
                  style: kSpeedTestSubtextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 19),
                Text(
                  'Topic: Flowering plants',
                  style: kSpeedTestSubtextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 19),
                Text(
                  'Time: 00:30 per question',
                  style: kSpeedTestSubtextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                label: 'start',
                onPressed: () {},
              )
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/test_challenge_list.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';

class CustomizedTestQuizMode extends StatefulWidget {
  const CustomizedTestQuizMode(this.user, this.course, {Key? key})
      : super(key: key);
  final User user;
  final Course course;

  @override
  _CustomizedTestQuizModeState createState() => _CustomizedTestQuizModeState();
}

class _CustomizedTestQuizModeState extends State<CustomizedTestQuizMode> {
  String numberOfQuestions = '';
  String durationLeft = '';
  String durationRight = '';
  String duration = '';

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoTaupe,
      backgroundImageURL: 'assets/images/deep_pool_taupe.png',
      pages: [
        TestIntroitLayoutPage(
          title: 'Questions',
          subText: 'Enter your preferred number',
          middlePiece: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Container(
                width: 180.0,
                child: PinInput(
                  length: 3,
                  onChanged: (v) {
                    setState(() {
                      numberOfQuestions = v.split('').join('');
                    });
                  },
                ),
              ),
            ],
          ),
          footer: AdeoOutlinedButton(
            label: 'Next',
            onPressed: () {
              if (numberOfQuestions.length > 0)
                TestIntroitLayout.goForward();
              else
                showFeedback(
                  context,
                  'Enter the number of questions you want to answer',
                );
            },
          ),
        ),
        TestIntroitLayoutPage(
          title: 'Time',
          subText: 'Enter your preferred number',
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
                label: 'Previous',
                onPressed: TestIntroitLayout.goBack,
              ),
              SizedBox(width: 8.0),
              AdeoOutlinedButton(
                label: 'let\'s go',
                onPressed: () {
                  if (durationRight.length > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TestChallengeList(
                            testType: TestType.CUSTOMIZED,
                            course: widget.course,
                            user: widget.user,
                          );
                        },
                      ),
                    );
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
      ],
    );
  }
}

import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/speed/speed_quiz_menu.dart';
import 'package:ecoach/views/test/test_challenge_list.dart';
import 'package:ecoach/widgets/buttons/adeo_outlined_button.dart';

import 'package:ecoach/widgets/layouts/test_introit_layout_speed.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SpeedTestQuestionMode extends StatefulWidget {
  const SpeedTestQuestionMode(this.user, this.course, this.mode, {Key? key})
      : super(key: key);
  final User user;
  final Course course;
  final String mode;

  @override
  State<SpeedTestQuestionMode> createState() => _SpeedTestQuestionModeState();
}

class _SpeedTestQuestionModeState extends State<SpeedTestQuestionMode> {
  String durationLeft = '';
  String durationRight = '';
  String duration = '';
  late FocusNode focusNode, focusNode2, numberFocus;
  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode2 = FocusNode();
    numberFocus = FocusNode();
    numberFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayoutSpeed(
      background: kAdeoOrangeH,
      backgroundImageURL: 'assets/images/deep_pool_orange_h.png',
      pages: [
        TestIntroitLayoutPageSpeed(
          title: 'Time',
          subText: widget.mode == "question"
              ? 'Allocation per question'
              : "Enter time allocation for the quiz",
          middlePiece: Column(
            children: [
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    child: PinInput(
                      length: 2,
                      focusNode: focusNode,
                      textColor: Colors.white,
                      onChanged: (v) {
                        setState(() {
                          durationLeft = v.split('').join('');
                          if (durationLeft.length > 1) {
                            focusNode2.requestFocus();
                          }
                        });
                      },
                    ),
                  ),
                  Text(':', style: kPinInputTextStyle),
                  Container(
                    width: 120.0,
                    child: PinInput(
                      autoFocus: durationLeft.length == 2,
                      focusNode: focusNode2,
                      length: 2,
                      textColor: Colors.white,
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
                label: 'Next',
                onPressed: () async {
                  if (durationRight.length > 0) {
                    showLoaderDialog(context, message: "loading questions");

                    int min = int.parse(durationLeft);
                    int sec = int.parse(durationRight);
                    int time = (min * 60) + sec;

                    Navigator.pop(context);
                    if (widget.mode == "question") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TestChallengeList(
                              testType: TestType.SPEED,
                              course: widget.course,
                              user: widget.user,
                              time: time,
                            );
                          },
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SpeedQuizMenu(
                              controller: MarathonController(
                                  widget.user, widget.course,
                                  type: TestType.SPEED,
                                  time: time,
                                  name: widget.course.name!),
                              time: time,
                            );
                          },
                        ),
                      );
                    }
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

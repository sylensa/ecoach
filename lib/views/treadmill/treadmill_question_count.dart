import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_time_and_instruction.dart';
import 'package:ecoach/views/treadmill/treadmill_timer.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:flutter/material.dart';

import '../../models/topic.dart';

class TreadmillQuestionCount extends StatelessWidget {
  TreadmillQuestionCount({
    this.topics = const [],
    required this.controller,
    required this.mode,
    this.count = 0,
    this.topicId,
    this.bankId,
    this.bankName,
    this.topic,
  });
  final List<TestNameAndCount> topics;
  final TreadmillController controller;

  final int count;
  final TreadmillMode mode;
  final int? topicId;
  Topic? topic;
  final int? bankId;
  final String? bankName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: Stack(
        children: [
          Positioned(
            left: -36.0,
            right: -36.0,
            top: 85,
            child: Container(
              height: backgroundIllustrationHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/deep_pool_light_teal.png',
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 141),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 109,
                          fontWeight: FontWeight.w600,
                          color: kAdeoWhiteAlpha50,
                        ),
                      ),
                      Text(
                        'Questions',
                        style: TextStyle(
                          fontSize: 41,
                          fontFamily: 'Hamelin',
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (count == 0)
                      AdeoFilledButton(
                        color: Colors.white,
                        background: kAdeoLightTeal,
                        label: 'Back',
                        size: Sizes.large,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    else
                      AdeoFilledButton(
                        color: Colors.white,
                        background: kAdeoLightTeal,
                        label: 'Next',
                        size: Sizes.large,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TreadmillTime(
                                  controller: controller,
                                  topic: topic,
                                  mode: mode,
                                  topicId: topicId,
                                  bankId: bankId,
                                  bankName: bankName,
                                );
                                //TreadmillWelcome(
                                // controller: controller,
                                // mode: mode,
                                // topicId: topicId,
                                // bankId: bankId,
                                // bankName: bankName,
                                // );
                              },
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 53),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

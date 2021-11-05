import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn_next_topic.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LearnMasteryFeedback extends StatelessWidget {
  const LearnMasteryFeedback({
    required this.passed,
    required this.topic,
  });

  final bool passed;
  final String topic;

  static const TextStyle _topLabelStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFF969696),
  );
  static const TextStyle _topMainTextStyle = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    color: kAdeoGray2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CircularProgressIndicatorWrapper(
                      subCenterText: 'avg. score',
                      progress: 80,
                      progressColor: passed ? kAdeoGreen : kAdeoCoral,
                      size: ProgressIndicatorSize.large,
                      resultType: true,
                    ),
                    SizedBox(height: 12.0),
                    Text('Score', style: _topLabelStyle)
                  ],
                ),
                Container(
                  height: 120.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 12.0),
                      Text('08:30', style: _topMainTextStyle),
                      Text('Time Taken', style: _topLabelStyle)
                    ],
                  ),
                ),
                Container(
                  height: 120.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 12.0),
                      Text('10', style: _topMainTextStyle),
                      Text('Questions', style: _topLabelStyle)
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 290.0,
                  child: Image.asset(
                    'assets/images/learn_module/${passed ? 'congrats' : 'aww'}.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  passed ? 'Congratulations' : 'Aww',
                  style: TextStyle(
                    color: kDefaultBlack,
                    fontSize: 32.0,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  passed
                      ? 'You have successfully mastered\n$topic'
                      : 'You scored below the pass mark.\nLet\'s try one more time\nTogether we can',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: kAdeoGray2,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 52.0,
            color: Color(0xFFF6F6F6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button(
                    label: 'review',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(width: 1.0, color: kNavigationTopBorderColor),
                Expanded(
                  child: Button(
                    label: passed ? 'continue' : 'revise',
                    onPressed: () {
                      if (passed)
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LearnNextTopic();
                        }));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

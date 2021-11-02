import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn_mastery_feedback.dart';
import 'package:flutter/material.dart';

class LearnAttentionTopics extends StatelessWidget {
  TextStyle auxTextStyle = TextStyle(
    fontSize: 20.0,
    color: kAdeoGray3,
    fontWeight: FontWeight.w500,
  );

  TextStyle listStyle = TextStyle(
    fontSize: 15.0,
    color: kDefaultBlack,
    height: 3.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 56.0,
            padding: EdgeInsets.only(
              top: 32.0,
              left: 24.0,
              right: 24.0,
              bottom: 32.0,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Text(
                      '10',
                      style: TextStyle(
                        color: kAdeoGray3,
                        fontSize: 100.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                      bottom: 32,
                      child: Container(
                        height: 1.5,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            double.infinity,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: darken(kAdeoGray2, 80),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'topics',
                  style: auxTextStyle,
                ),
                Text(
                  'need your attention',
                  style: auxTextStyle,
                ),
                SizedBox(
                  width: 222.0,
                  child: Divider(
                    color: kAdeoGray2,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                        Text('Density', style: listStyle),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 222.0,
                  child: Divider(
                    color: kAdeoGray2,
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'click on the button below to improve\nyour performance in those topics',
                  style: auxTextStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LearnMasteryFeedback(
                  passed: true,
                  topic: 'Density',
                );
              }));
            },
            child: Container(
              alignment: Alignment.center,
              height: 56.0,
              width: double.infinity,
              color: kAdeoGreen,
              child: Text(
                'let\'s go',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

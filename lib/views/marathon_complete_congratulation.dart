import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/marathon_ranking.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon_introit.dart';
import 'package:ecoach/views/marathon_save_resumption_menu.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';

class MarathonCompleteCongratulations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AdeoOutlinedButton(
                label: 'Exit',
                size: Sizes.small,
                color: kAdeoOrange,
                borderRadius: 5,
                fontSize: 14,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return MarathonSaveResumptionMenu();
                  }));
                },
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 33),
          Text(
            'Congratulations',
            style: TextStyle(
              fontSize: 41,
              fontFamily: 'Hamelin',
              color: kAdeoBlue,
            ),
          ),
          Text(
            'Marathon Completed',
            style: TextStyle(
              fontSize: 18,
              color: Color(0x809EE4FF),
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 48),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Net Score: 250',
                    style: TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '02 hrs : 25 min : 18 sec',
                    style: TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1500 Questions',
                    style: TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  SizedBox(height: 48),
                  QuizStats(
                    averageScore: '65.2%',
                    speed: '240s',
                    correctScore: '286',
                    wrongScrore: '4',
                  ),
                  SizedBox(height: 20),
                  AdeoTextButton(
                    label: 'View Ranking',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) {
                        return MarathonRanking();
                      }));
                    },
                    fontSize: 20,
                    color: kAdeoBlue,
                    background: Colors.transparent,
                  ),
                  SizedBox(height: 96),
                ],
              ),
            ),
          ),
          Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'review',
                          fontSize: 20,
                          color: Colors.white,
                          background: kAdeoBlue,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: kAdeoBlueAccent,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AdeoTextButton(
                          label: 'result',
                          fontSize: 20,
                          color: Colors.white,
                          background: kAdeoBlue,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) {
                              return MarathonIntroit();
                            }));
                          },
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: kAdeoBlueAccent,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AdeoTextButton(
                    label: 'new test',
                    fontSize: 20,
                    color: Colors.white,
                    background: kAdeoBlue,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) {
                        return MarathonIntroit();
                      }));
                    },
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

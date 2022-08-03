import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/treadmill/treadmill_introit.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';

class TreadmillCompleteCongratulations extends StatefulWidget {
  TreadmillCompleteCongratulations({
    required this.controller,
    required this.avgScore,
    required this.correct,
    required this.wrong,
    // required this.avgTimeComplete,
  });

  final TreadmillController controller;
  final double avgScore;
  final int correct;
  final int wrong;
  // final dynamic avgTimeComplete;

  @override
  State<TreadmillCompleteCongratulations> createState() =>
      _TreadmillCompleteCongratulationsState();
}

class _TreadmillCompleteCongratulationsState
    extends State<TreadmillCompleteCongratulations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  //  widget.controller.endTreadmill();
                  Navigator.popUntil(context,
                      ModalRoute.withName(CourseDetailsPage.routeName));
                },
                child: Container(
                    margin: EdgeInsets.all(8),
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D3E50),
                      border: Border.all(
                        color: const Color(0xFFFF4949),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          color: Color(0xFFFF4949),
                        ),
                      ),
                    )),
              ),

              // AdeoOutlinedButton(
              //   label: 'Exit',
              //   size: Sizes.small,
              //   color: kAdeoOrange,
              //   borderRadius: 5,
              //   fontSize: 14,
              //   onPressed: () {
              //     widget.controller.endTreadmill();
              //     Navigator.popUntil(context,
              //         ModalRoute.withName(CourseDetailsPage.routeName));
              //   },
              // ),

              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 33),
          const Text(
            'Congratulations',
            style: TextStyle(
              fontSize: 41,
              fontFamily: 'Hamelin',
              color: kAdeoBlue,
            ),
          ),
          const Text(
            'Run Completed',
            style: TextStyle(
              fontSize: 18,
              color: Color(0x809EE4FF),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // 'Net Score: ${controller.treadmill!.totalCorrect! - controller.treadmill!.totalWrong!}'
                    'Net Score: ${widget.controller.getTotalCorrect() - widget.controller.getTotalWrong()}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${Duration(seconds: widget.controller.treadmill!.totalTime!).inMinutes % 60} min : ${Duration(seconds: widget.controller.treadmill!.totalTime!).inSeconds % 60} sec',
                    // '${widget.controller.minutes} min : ${widget.controller.seconds} sec',
                    style: const TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    // '${controller.questions.length} Questions',
                    '${widget.controller.questions.length} Questions',
                    style: const TextStyle(
                      fontSize: 15,
                      color: kAdeoBlueAccent,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // QuizStats(
                  //   changeUp: true,
                  //   averageScore:
                  //       '${controller.getAvgScore().toStringAsFixed(2)}%',
                  //   speed: '${controller.getAvgTime().toStringAsFixed(2)}s',
                  //   correctScore: '${controller.getTotalCorrect()}',
                  //   wrongScrore: '${controller.getTotalWrong()}',
                  // ),
                  QuizStats(
                    changeUp: true,
                    averageScore: '${widget.avgScore.toStringAsFixed(2)}%',
                    speed: '${widget.controller.avgTime.toStringAsFixed(2)}s',
                    correctScore: '${widget.controller.getTotalCorrect()}',
                    wrongScrore: '${widget.controller.getTotalWrong()}',
                  ),
                  const SizedBox(height: 20),
                  // AdeoTextButton(
                  //   label: 'View Ranking',
                  //   onPressed: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (c) {
                  //       return MarathonRanking();
                  //     }));
                  //   },
                  //   fontSize: 20,
                  //   color: kAdeoBlue,
                  //   background: Colors.transparent,
                  // ),
                  const SizedBox(height: 96),
                ],
              ),
            ),
          ),
          Container(
            height: 48.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AdeoTextButton(
                    label: 'New Test',
                    fontSize: 20,
                    color: Colors.white,
                    background: kAdeoBlue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) {
                          return TreadmillIntroit(
                            widget.controller.user,
                            widget.controller.course,
                          );
                        }),
                      );
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

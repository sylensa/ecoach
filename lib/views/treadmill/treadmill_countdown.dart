import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/quiz_questions_copy.dart';
import 'package:ecoach/views/treadmill/treadmill_quiz_view.dart';
import 'package:ecoach/views/treadmill/treadmill_quiz_view_old.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TreadmillCountdown extends StatefulWidget {
  TreadmillCountdown({required this.controller});
  final TreadmillController controller;

  @override
  State<TreadmillCountdown> createState() => _TreadmillCountdownState();
}

class _TreadmillCountdownState extends State<TreadmillCountdown> {
  late Timer _timer;
  int duration = 5;
  var future = new Future.delayed(const Duration(milliseconds: 500));

  void startTimer() {
    future.asStream().listen((event) {
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) {
          if (duration == 0) {
            setState(() {
              timer.cancel();
              future.asStream().listen((event) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) {
                    return TreadmillQuizView(controller: widget.controller);
                    // return QuizQuestionCopy(controller: widget.controller);
                  }),
                );
              });
            });
          } else {
            setState(() {
              duration--;
            });
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            if (duration > 0)
              Column(
                children: [
                  SizedBox(height: 70),
                  Center(
                    child: Text(
                      'Run\nbegins in',
                      textAlign: TextAlign.center,
                      style: kIntroitScreenHeadingStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            Expanded(
              child: Center(
                child: duration == 0
                    ? Text(
                        'Let\'s go',
                        textAlign: TextAlign.center,
                        style: kIntroitScreenHeadingStyle(color: Colors.white),
                      )
                    : Text(
                        duration.toString(),
                        style: TextStyle(
                          fontSize: 208,
                          fontFamily: 'Helvetica Rounded',
                          color: kAdeoLightTeal,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

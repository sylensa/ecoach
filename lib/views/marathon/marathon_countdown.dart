import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon/marathon_quiz_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MarathonCountdown extends StatefulWidget {
  MarathonCountdown({required this.controller});
  MarathonController controller;

  @override
  State<MarathonCountdown> createState() => _MarathonCountdownState();
}

class _MarathonCountdownState extends State<MarathonCountdown> {
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
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return MarathonQuizView(controller: widget.controller);
                }));
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
            SizedBox(height: 70),
            Center(
              child: Text(
                'Marathon\nbegins in',
                textAlign: TextAlign.center,
                style: kIntroitScreenHeadingStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: duration == 0
                    ? Text(
                        'Let\'s go',
                        style: TextStyle(
                          fontSize: 69,
                          fontFamily: 'Helvetica Rounded',
                        ),
                      )
                    : Text(
                        duration.toString(),
                        style: TextStyle(
                          fontSize: 208,
                          fontFamily: 'Helvetica Rounded',
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

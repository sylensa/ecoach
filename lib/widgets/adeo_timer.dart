import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class AdeoTimer extends StatefulWidget {
  const AdeoTimer(
      {Key? key,
      required this.controller,
      required this.startDuration,
      required this.callbackWidget,
      required this.onFinish})
      : super(key: key);

  final TimerController controller;
  final Duration startDuration;
  final Function(double time) callbackWidget;
  final Function() onFinish;

  @override
  _AdeoTimerState createState() => _AdeoTimerState();
}

class _AdeoTimerState extends State<AdeoTimer> {
  final CountdownController controller =
      new CountdownController(autoStart: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Countdown(
      controller: widget.controller.getController(),
      seconds: widget.startDuration.inSeconds,
      build: (BuildContext context, double time) {
        return widget.callbackWidget(time);
      },
      onFinished: () {
        print('Timer is done!');
        widget.onFinish();
      },
    );
  }
}

class TimerController {
  final CountdownController _controller = new CountdownController(autoStart: true);

  TimerController() {}

  CountdownController getController() {
    return _controller;
  }

  start() {
    _controller.start();
  }

  pause() {
    _controller.pause();
  }

  reset() {
    print("reset call");
    _controller.restart();
  }

  resume() {
    _controller.resume();
  }

  restart() {
    _controller.restart();
  }
}

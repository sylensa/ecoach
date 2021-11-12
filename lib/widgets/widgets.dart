import 'package:ecoach/models/topic_analysis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

showLoaderDialog(BuildContext context, {String? message = "loading..."}) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                message!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

money(double amount, {String currency = ""}) {
  NumberFormat format = NumberFormat.simpleCurrency(
      decimalDigits: 2, locale: "en-GH", name: "GHS");
  return format.format(amount);
}

positionText(int position) {
  String suffix = "th";
  switch (position % 10) {
    case 1:
      suffix = 'st';
      break;
    case 2:
      suffix = 'nd';
      break;
    case 3:
      suffix = 'rd';
      break;
    default:
      suffix = 'th';
  }
  return "$position$suffix";
}

topicRow(TopicAnalysis topicAnalysis) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 25.0, 0, 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            child: Text(
              "${topicAnalysis.name}",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        SizedBox(
            width: 100,
            child: Text("${topicAnalysis.correct}",
                style: TextStyle(fontSize: 15))),
        Expanded(
          child: LinearPercentIndicator(
            width: 140.0,
            lineHeight: 14.0,
            animation: true,
            percent: topicAnalysis.performace,
            backgroundColor: Colors.black,
            progressColor: Colors.orange,
          ),
        ),
      ],
    ),
  );
}

String getTime(DateTime dateTime) {
  return "${NumberFormat('00').format(dateTime.hour)}:${NumberFormat('00').format(dateTime.second)}";
}

String getDurationTime(Duration duration) {
  int min = (duration.inSeconds / 60).floor();
  int sec = duration.inSeconds % 60;
  return "${NumberFormat('00').format(min)}:${NumberFormat('00').format(sec)}";
}

String getDateOnly(DateTime dateTime) {
  return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
}

class Button extends StatelessWidget {
  const Button({
    required this.label,
    this.onPressed,
  });

  final String label;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0),
      ),
      height: 48.0,
      textColor: Color(0xFFA2A2A2),
    );
  }
}

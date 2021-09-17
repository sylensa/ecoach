import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

showLoaderDialog(BuildContext context, {String? message = "loading..."}) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text(message!)),
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

topicRow(TopicAnalysis topicAnalysis) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 22.0, 0, 22.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
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

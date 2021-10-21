import 'package:ecoach/models/topic_analysis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

showLoaderDialog(BuildContext context, {String? message = "loading..."}) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(
              message!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black),
            )),
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

showDownloadDialog(BuildContext context,
    {String? message = "loading...", int? current, int? total}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return await false;
        },
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    "Downloading subscriptions...",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Spacer(),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text(
                          message!,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black),
                        )),
                    current != null && current > 0
                        ? LinearPercentIndicator(
                            percent: current / total!,
                          )
                        : LinearProgressIndicator(),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
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

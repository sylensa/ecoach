import 'package:ecoach/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

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

topicRow(List<Question> questions) {
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
              "${question.topicId}",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        SizedBox(
            width: 120,
            child: Text("${question.isCorrect ? 1 : 0}",
                style: TextStyle(fontSize: 15))),
        Expanded(child: Text("Performance", style: TextStyle(fontSize: 15))),
      ],
    ),
  );
}

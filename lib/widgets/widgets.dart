import 'dart:convert';
import 'dart:io';

import 'package:ecoach/models/topic_analysis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

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

String parseHtmlString(String htmlString) {
  final document = htmlparser.parse(htmlString);
  final String parsedString =
      htmlparser.parse(document.body!.text).documentElement!.text;

  return parsedString;
}

List<String> getHtmlImageLinks(String body) {
  var document = htmlparser.parse(body);
  List<dom.Element> links = document.querySelectorAll('img');
  List<String> imageLinks = [];
  links.forEach((link) {
    String imageLink = link.attributes['src'] ?? '';
    imageLinks.add(imageLink);
  });

  return imageLinks;
}

Future<File> saveImageToDir(var _byteImage, String name) async {
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  File file = new File(join(documentDirectory.path, name));
  print('writing to file .................. .');
  return await file.writeAsBytes(_byteImage);
}

saveBase64(String base64, String name) async {
  print('saving base 64');
  print(base64);

  final _byteImage = Base64Decoder().convert(base64);
  File f = await saveImageToDir(_byteImage, name);
  print(f.path);
  if (await f.exists()) {
    print("file exists");
  } else {
    print("file does not exist");
  }
}

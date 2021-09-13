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

selectText(String text, bool selected,
    {required Function select, double? normalSize, double? selectedSize}) {
  return GestureDetector(
    onTap: () {
      select();
    },
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
          child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: selected ? (selectedSize ?? 40) : normalSize ?? 16),
        ),
      )),
    ),
  );
}

selectHtml(String text, bool selected,
    {required Function select, double? normalSize, double? selectedSize}) {
  print(text);
  return GestureDetector(
    onTap: () {
      print("tapping..");
      select();
    },
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
          child: Center(
        child: Html(data: text, style: {
          // tables will have the below background color
          "body": Style(
            color:  Colors.white,
            fontSize: selected
                ? FontSize(selectedSize ?? 40)
                : FontSize(normalSize ?? 16),
          ),
        }),
      )),
    ),
  );
}

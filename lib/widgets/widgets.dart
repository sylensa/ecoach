import 'package:flutter/material.dart';
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
      decimalDigits: 2,
      locale: "en_GH",
      name: currency != "" ? currency : "GHC");
  return format.format(amount);
}

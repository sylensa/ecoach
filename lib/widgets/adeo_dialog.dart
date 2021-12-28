import 'dart:io' show Platform;

import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/tex.dart';

class AdeoDialog extends StatelessWidget {
  const AdeoDialog({
    required this.title,
    required this.content,
    required this.actions,
    Key? key,
  }) : super(key: key);

  final String title;
  final String content;
  final List<AdeoDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(color: kDefaultBlack),
        ),
        content: Text(
          content,
          style: TextStyle(color: kDefaultBlack),
        ),
        actions: actions
            .map(
              (action) => CupertinoDialogAction(
                child: Text(action.label),
                onPressed: action.onPressed,
              ),
            )
            .toList(),
      );
    }
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: kDefaultBlack),
      ),
      content: Text(
        content,
        style: TextStyle(color: kDefaultBlack),
      ),
      actions: actions
          .map(
            (action) => TextButton(
              child: Text(action.label),
              onPressed: action.onPressed,
              style: TextButton.styleFrom(
                primary: kAdeoBlue,
              ),
            ),
          )
          .toList(),
    );
  }
}

class AdeoDialogAction {
  final String label;
  final onPressed;

  AdeoDialogAction({required this.label, required this.onPressed});
}

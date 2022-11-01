import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;

showDialogWithBlur(
    {required BuildContext context,
    required Widget child,
    Color backgroundColor = Colors.white}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          child: child,
          backgroundColor: backgroundColor,
        ),
      );
    },
  );
}

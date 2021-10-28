import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

ToastFuture? toast;
List<String> messages = [];
List<String> onlineMessages = [];

showFeedback(BuildContext context, String message,
    {duration = const Duration(seconds: 3),
    position = StyledToastPosition.top}) {
  if (toast == null) {
    toast = showToast(message,
        context: context,
        duration: duration,
        position: position, onDismiss: () {
      toast = null;
      if (messages.length > 0) {
        showFeedback(context, messages.removeAt(0));
      }
    });
  } else {
    messages.add(message);
  }
}

showNoConnectionToast(
  BuildContext context,
) {
  String message = "No Internet connection.";
  showToast(message,
      context: context,
      duration: Duration(seconds: 10),
      backgroundColor: Colors.red,
      position: StyledToastPosition.top,
      fullWidth: true,
      onDismiss: () {});
}

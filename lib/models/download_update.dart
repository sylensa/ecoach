import 'package:flutter/material.dart';

class DownloadUpdate with ChangeNotifier {
  DownloadUpdate(
      {this.message = "download beginning",
      this.percentage = 0,
      this.isDownloading = false});

  String? message;
  int percentage;
  bool isDownloading;
  List<String> doneDownloads = [];

  void setDownloading(bool state) {
    isDownloading = state;
    notifyListeners();
  }

  void updateMessage(String message) {
    this.message = message;
    notifyListeners();
  }

  void updatePercentage(int percentage) {
    this.percentage = percentage;
    notifyListeners();
  }

  void doneDownlaod(String downloaded) {
    doneDownloads.add(downloaded);
    notifyListeners();
  }
}

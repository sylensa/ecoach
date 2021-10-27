import 'package:ecoach/api/package_downloader.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:flutter/material.dart';

enum DownloadStatus { NONE, DOWNLOADING, DONE }

class DownloadUpdate with ChangeNotifier {
  DownloadUpdate(
      {this.message = "download beginning",
      this.percentage = 0,
      this.isDownloading = false,
      this.notificationUp = false});

  String? message;
  String? notificationMessage;
  int percentage;
  int newSubscriptions = 0;
  bool isDownloading;
  bool notificationUp;
  List<String> doneDownloads = [];

  List<Subscription>? plans = [];
  String downloadCount = "";
  String downloadStatus = "";
  int currentPlanId = -1;

  void setSubscriptions(List<Subscription>? plans) {
    this.plans = plans;
    notifyListeners();
  }

  Subscription? getPlan(int planId) {
    for (int i = 0; i < plans!.length; i++) {
      if (plans![i].id == planId) {
        return plans![i];
      }
    }
    return null;
  }

  setNotificationUp(bool state, int newSubs) {
    notificationUp = state;
    newSubscriptions = newSubs;
    notificationMessage = newSubs > 0
        ? "You have $newSubs new subscription${newSubs > 1 ? 's' : ''}"
        : newSubs < 0
            ? "You have lost a subscription"
            : "";
    notifyListeners();
  }

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

  String getDownloadStatus(int planId) {
    Subscription? plan = getPlan(planId);
    if (plan != null) {
      return "Downloading ...";
    }
    return "";
  }

  void setDownloadCount(int planId, int count) async {
    if (plans == null) return;

    currentPlanId = planId;

    int totalCount = 0;
    for (int i = 0; i < plans!.length; i++) {
      if (planId == plans![i].id) {
        List<SubscriptionItem>? items = plans![i].subscriptionItems;
        totalCount = items == null ? 0 : items.length;
      }
    }

    downloadCount = "$count/$totalCount";
    notifyListeners();
  }

  setState() {
    notifyListeners();
  }

  void clearDownloads() {
    currentPlanId = -1;
    doneDownloads.clear();
    notifyListeners();
  }
}

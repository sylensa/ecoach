import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/package_downloader.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/image.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/notification_service.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MainController {
  User user;
  BuildContext context;
  DownloadUpdate provider;

  MainController(this.context, this.provider, this.user) {
    print(context);
    print("----------------------------");
  }

  void setSubscriptions(List<Subscription> subscriptions) {
    provider.setSubscriptions(subscriptions);
  }

  List<Subscription> getSubscriptions() {
    return provider.plans!;
  }

  bool compareSubscriptions(
      List<Subscription> freshSubscriptions, List<Subscription> subscriptions) {
    print("${freshSubscriptions.length} ${subscriptions.length}");
    if (freshSubscriptions.length != subscriptions.length) {
      return false;
    }

    int same = 0;
    subscriptions.forEach((subscription) {
      for (int i = 0; i < freshSubscriptions.length; i++) {
        if (subscription.id == freshSubscriptions[i].id &&
            subscription.tag == freshSubscriptions[i].tag) {
          same++;
        }
      }
    });

    print("same = $same");
    if (same == subscriptions.length) {
      return true;
    }
    return false;
  }

  checkSubscription(Function(bool success) finallyCallback) {
    makeSubscriptionsCall().then((freshSubscriptions) async {
      if (freshSubscriptions == null) return;
      List<Subscription> subscriptions = user.subscriptions;
      if (!compareSubscriptions(freshSubscriptions, subscriptions)) {
        Future.delayed(Duration(seconds: 2));
        int newSubs = freshSubscriptions.length - subscriptions.length;

        for (int i = 0; i < subscriptions.length; i++) {
          await SubscriptionDB().delete(subscriptions[i].id!);
        }
        provider.setSubscriptions(freshSubscriptions);
        await SubscriptionDB().insertAll(freshSubscriptions);
        provider.setNotificationUp(true, newSubs);
        List<SubscriptionItem> items =
            await SubscriptionItemDB().undownloadedItems();

        if (items.length > 0) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Download Subscription",
                      style: TextStyle(color: Colors.black)),
                  content: Text(
                    "You have new subscriptions. Do you want to download them now?",
                    softWrap: true,
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          downloadSubscription(items, (success) => null);
                          Navigator.pop(context);
                        },
                        child: Text("Yes")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"))
                  ],
                );
              });
        }
      }
    });
  }

  Future<List<Subscription>> makeSubscriptionsCall() async {
    return await ApiCall<Subscription>(AppUrl.subscriptionData, create: (json) {
      return Subscription.fromJson(json);
    }).get(context);
  }

  downloadSubscription(List<SubscriptionItem> items,
      Function(bool success) finallyCallback) async {
    bool downloadSuccessful = false;
    SubscriptionItem? currentItem = null;
    try {
      provider.setDownloading(true);
      Wakelock.enable();
      showLoaderDialog(context, message: "starting downloads");
      Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      for (int i = 0; i < items.length; i++) {
        currentItem = items[i];
        currentItem.isDownloading = true;
        provider.setState();
        String filename = items[i].name!;
        // if (await packageExist(filename)) {
        //   continue;
        // }
        FileDownloader fileDownloader = FileDownloader(
            AppUrl.subscriptionItemDownload + '/${items[i].id}?',
            filename: filename);

        print(context);
        provider.updateMessage("downloading $filename");

        await fileDownloader.downloadFile((percentage) {
          print("download: ${percentage}%");
          print(context);
          provider.updatePercentage(percentage);
        });

        provider.updateMessage("saving $filename");

        String subItem = await readSubscriptionPlan(filename);
        Map<String, dynamic> response = jsonDecode(subItem);

        SubscriptionItem? subscriptionItem =
            SubscriptionItem.fromJson(response);

        print("saving ${subscriptionItem.name}\n data");

        await CourseDB().insert(subscriptionItem.course!);
        await QuizDB().insertAll(subscriptionItem.quizzes!);
        await TopicDB().insertAll(subscriptionItem.topics!);

        List<ImageFile> images = subscriptionItem.images!;

        for (int i = 0; i < images.length; i++) {
          ImageFile image = images[i];
          if (image.base64 == null) continue;
          await saveBase64(image.base64!, image.name);

          File file = user.getImageFile(image.name);
          if (await file.exists()) {
            print("--------------> File exists");
          } else {
            print("--------------> File does not exists");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("File does not save")));
          }
        }

        provider.doneDownlaod("$filename ...  done.");
        currentItem.isDownloading = false;
        provider.setState();
      }
      provider.setNotificationUp(false, 0);
      downloadSuccessful = true;
      NotificationService().showNotification('Download complete',
          'subscription items downloaded successfully', "download");
    } on SocketException catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showNoConnectionToast(context);
    } catch (m, e) {
      provider.updateMessage("$m");
      provider.setDownloading(false);
      if (currentItem != null) {
        currentItem.isDownloading = false;
        provider.setState();
      }
      NotificationService().showNotification('Download Failed',
          'subscription items could not download successfully', "download");
      print("Error>>>>>>>> download failed");
      print(m);
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Download failed")));
    } finally {
      Wakelock.disable();

      provider.setDownloading(false);
      provider.clearDownloads();

      finallyCallback(downloadSuccessful);
    }
  }
}

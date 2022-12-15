import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/package_downloader.dart';
import 'package:ecoach/controllers/glossary_controller.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/image.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/revamp/features/payment/views/screens/download_failed.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/notification_service.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MainController {
  User user;
  BuildContext context;
  DownloadUpdate provider;

  MainController(this.context, this.provider, this.user);

  void setSubscriptions(List<Subscription> subscriptions) {
    provider.setSubscriptions(subscriptions);
  }

  List<Subscription> getSubscriptions() {
    return provider.plans;
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
      print("freshSubscriptions:${freshSubscriptions.length}");
      if (freshSubscriptions.isNotEmpty){
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
          List<SubscriptionItem> items = await SubscriptionItemDB().undownloadedItems();
          print("items:${items.length}");
          if (items.isNotEmpty) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(Platform.isAndroid ? "Download Subscription" : "Download Courses",
                        style: TextStyle(color: Colors.black)),
                    content: Text(
                      Platform.isAndroid ? "You have new subscriptions. Do you want to download them now?" : "You have new courses. Do you want to download them now?",
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
      }
    });
  }

  Future<List<Subscription>> makeSubscriptionsCall() async {
    return await ApiCall<Subscription>(AppUrl.subscriptionData, create: (json) {
      return Subscription.fromJson(json);
    }).get(context);
  }

  Future<void> saveSubscriptionData(Course course) async {
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      Batch batch = txn.batch();
      batch.insert(
        'courses',
        course.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      List<Question> questions = course.questions!;
      if (questions.length > 0) {
        for (int i = 0; i < questions.length; i++) {
          Question question = questions[i];
          batch.insert(
            'questions',
            question.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          Topic? topic = question.topic;
          if (topic != null) {
            print(topic.toJson());
            batch.insert(
              'topics',
              topic.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          List<Answer> answers = question.answers!;
          if (answers.length > 0) {
            for (int i = 0; i < answers.length; i++) {
              batch.insert(
                'answers',
                answers[i].toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
          await Future.delayed(Duration(milliseconds: 90));
        }
      }
      batch.commit();
    });
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

        SubscriptionItem? subscriptionItem = SubscriptionItem.fromJson(response);

        print("saving ${subscriptionItem.name}\n data");

        final Database? db = await DBProvider.database;
        await db!.transaction((txn) async {
          Batch batch = txn.batch();
          print("subscriptionItem.course!:${subscriptionItem.course != null ? subscriptionItem.course!.toJson() : "null"}");
          await CourseDB().insert(batch, subscriptionItem.course!);
          await GlossaryController().getGlossariesList(batch,subscriptionItem.course!.id!);
          provider.updateMessage("saving $filename quizzes");
          await QuizDB().insertAll(batch, subscriptionItem.quizzes!);
          provider.updateMessage("saving $filename topics");
          await TopicDB().insertAll(batch, subscriptionItem.topics!);

          batch.commit(noResult: true);
        });

        provider.updateMessage("saving $filename images");
        List<ImageFile> images = subscriptionItem.images!;

        for (int i = 0; i < images.length; i++) {
          ImageFile image = images[i];
          if (image.base64 == null) continue;
          print("image.name:${image.name}");
          await saveBase64(image.base64!, image.name);

          File file = user.getImageFile(image.name);
          if (await file.exists()) {
            print("--------------> File exists");
          } else {
            print("--------------> File does not exists");
          }
        }

        provider.doneDownlaod("$filename ...  done.");
        currentItem.isDownloading = false;
        provider.setState();
      }
      provider.setNotificationUp(false, 0);
      downloadSuccessful = true;
      NotificationService().showNotification('Download complete', 'subscription items downloaded successfully', "download");
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
      // goTo(context, DownloadFailed(),replace: true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download failed")));
    } finally {
      Wakelock.disable();

      provider.setDownloading(false);
      provider.clearDownloads();

      finallyCallback(downloadSuccessful);
    }
  }
}

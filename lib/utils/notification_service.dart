import 'package:common_utils/common_utils.dart';
import 'package:ecoach/main.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/user_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<dynamic> selectNotification(String? payload) async {
    if (payload == "download") {
      // print("Notification printout $payload");
      User? user = await UserPreferences().getUser();
      navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => MainHomePage(
                    user!,
                    index: 4,
                  )),
          (Route<dynamic> route) => false);
    }
  }

  showNotification(title, text, payload) async {
    int nowDateStr = DateUtil.getNowDateMs();
    String nowDate = nowDateStr.toString();
    nowDate = nowDate.substring(4);
    int id = int.parse(nowDate);
    // print("This is your id $id");
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      text,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static const String groupKey = 'com.ecoach.adeo';
  static const String groupChannelId = 'grouped channel id';
  static const String groupChannelName = 'grouped channel name';
  static const String groupChannelDescription = 'grouped channel description';

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(groupChannelId, groupChannelName,
          setAsGroupSummary: true, groupKey: groupKey);

  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
}

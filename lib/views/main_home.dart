import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/api_response.dart';
import 'package:ecoach/api/file_downloader.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/quiz_db.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/providers/subscription_item_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/customize.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/views/more_view.dart';
import 'package:ecoach/widgets/adeo_bottom_navigation_bar.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class MainHomePage extends StatefulWidget {
  static const String routeName = '/main';
  User user;
  int index;
  MainHomePage(this.user, {this.index = 0});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with WidgetsBindingObserver {
  late List<Widget> _children;
  int currentIndex = 0;
  int percentage = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    print("main_home");
    _children = [
      HomePage(
        widget.user,
        callback: () {
          tapping(2);
        },
        percentage: percentage,
      ),
      CoursesPage(widget.user),
      StorePage(widget.user),
      AnalysisView(),
      MoreView(widget.user, key: UniqueKey()),
    ];
    currentIndex = widget.index;
    print("init");
    // checkSubscription();
    getSubscriptions().then((freshSubscriptions) async {
      if (freshSubscriptions == null) return;
      List<Subscription> subscriptions = widget.user.subscriptions;
      if (!compareSubscriptions(freshSubscriptions, subscriptions)) {
        showLoaderDialog(context,
            message: "downloading subscription\n data.....");
        List<Subscription>? subscriptions = await getSubscriptionData();
        if (subscriptions == null) {
          Navigator.pop(context);
          return;
        }

        await SubscriptionDB().insertAll(subscriptions);
        Navigator.pop(context);

        for (int i = 0; i < subscriptions.length; i++) {
          FileDownloader fileDownloader = FileDownloader(
              AppUrl.subscriptionDownload + '/${subscriptions[i].planId}?',
              filename: subscriptions[i].name!);

          await fileDownloader.downloadFile((percentage) {
            print("download: ${percentage}%");
            setState(() {
              this.percentage = percentage;
            });
          });
        }

        showLoaderDialog(context, message: "finalizing setup.....");
        for (int i = 0; i < subscriptions.length; i++) {
          String filename = subscriptions[i].name!;
          print("reading file $filename");
          String plan = await readSubscriptionPlan(filename);
          Map<String, dynamic> response = jsonDecode(plan);
          List<SubscriptionItem> items = [];
          response['subscription_items'].forEach((list) {
            items.add(SubscriptionItem.fromJson(list));
          });

          for (int i = 0; i < items.length; i++) {
            print("downloading ${items[i].name}\n data");
            SubscriptionItem? subscriptionItem = items[i];

            await CourseDB().insert(subscriptionItem.course!);
            await QuizDB().insertAll(subscriptionItem.quizzes!);
          }
        }
        Navigator.pop(context);
        UserPreferences().getUser().then((user) {
          setState(() {
            percentage = 0;
            widget.user = user!;
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Subscription data download successfully")));
      }
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // checkSubscription();
    }
  }

  Future<String> readSubscriptionPlan(String name) async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, name);

      final file = File(path);

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return "error";
    }
  }

  bool compareSubscriptions(
      List<Subscription> freshSubscriptions, List<Subscription> subscriptions) {
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

    if (same == subscriptions.length) {
      return true;
    }
    return false;
  }

  checkSubscription() {
    getSubscriptions().then((freshSubscriptions) async {
      if (freshSubscriptions == null) return;
      List<Subscription> subscriptions = widget.user.subscriptions;
      if (!compareSubscriptions(freshSubscriptions, subscriptions)) {
        showLoaderDialog(context,
            message: "downloading subscription\n data.....");
        List<Subscription>? subscriptions = await getSubscriptionData();
        if (subscriptions == null) {
          Navigator.pop(context);
          return;
        }

        await SubscriptionDB().insertAll(subscriptions);
        Navigator.pop(context);

        List<SubscriptionItem> items =
            await SubscriptionItemDB().allSubscriptionItems();
        print("all subcriptions items");
        for (int i = 0; i < items.length; i++) {
          print("downloading ${items[i].name}\n data");
          showDownloadDialog(context,
              message: "downloading..... ${items[i].name} data",
              current: i,
              total: items.length);
          SubscriptionItem? subscriptionItem =
              await getSubscriptionItem(items[i].id!);

          await CourseDB().insert(subscriptionItem!.course!);
          await QuizDB().insertAll(subscriptionItem.quizzes!);
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Subscription data download successfully")));
      }
    });
  }

  Future<List<Subscription>> getSubscriptions() async {
    return await ApiCall<Subscription>(AppUrl.subscriptions, create: (json) {
      return Subscription.fromJson(json);
    }).get(context);
  }

  Future<List<Subscription>?> getSubscriptionData() async {
    return await ApiCall<Subscription>(AppUrl.subscriptionData, params: {},
        create: (json) {
      return Subscription.fromJson(json);
    }).get(context);
  }

  getSubscriptionItem(id) async {
    return await ApiCall(AppUrl.subscriptionItem + '/$id?', isList: false,
        create: (json) {
      return SubscriptionItem.fromJson(json);
    }).get(context);
  }

  tapping(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(user: widget.user),
      body: [
        HomePage(
          widget.user,
          callback: () {
            tapping(2);
          },
          percentage: percentage,
        ),
        CoursesPage(widget.user),
        StorePage(widget.user),
        AnalysisView(),
        MoreView(widget.user, key: UniqueKey()),
      ][currentIndex],
      bottomNavigationBar: AdeoBottomNavigationBar(
        selectedIndex: currentIndex,
        onItemSelected: tapping,
        items: ['home', 'courses', 'adeo', 'analysis', 'account'],
      ),
    );
  }
}

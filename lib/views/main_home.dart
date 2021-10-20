import 'dart:async';
import 'dart:convert';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/package_downloader.dart';
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
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/views/more_view.dart';
import 'package:ecoach/widgets/adeo_bottom_navigation_bar.dart';
import 'package:ecoach/widgets/appbar.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  static const String routeName = '/main';
  User user;
  int index;
  MainHomePage(this.user, {this.index = 0});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> with WidgetsBindingObserver {
  late List<Widget> _children;
  int currentIndex = 0;
  int percentage = 0;
  String downloadMessage = "";
  bool isDownloading = false;

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
        isDownloading: isDownloading,
        percentage: percentage,
        downloadMessage: downloadMessage,
      ),
      CoursesPage(widget.user),
      StorePage(widget.user),
      AnalysisView(),
      MoreView(widget.user, key: UniqueKey()),
    ];
    currentIndex = widget.index;
    print("init");
    checkSubscription();
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

  checkSubscription() {
    getSubscriptions().then((freshSubscriptions) async {
      if (freshSubscriptions == null) return;
      List<Subscription> subscriptions = widget.user.subscriptions;
      if (!compareSubscriptions(freshSubscriptions, subscriptions)) {
        setState(() {
          isDownloading = true;
        });

        showLoaderDialog(context, message: "Initiating download....");
        Future.delayed(Duration(seconds: 2));

        for (int i = 0; i < subscriptions.length; i++) {
          await SubscriptionDB().delete(subscriptions[i].id!);
        }
        await SubscriptionDB().insertAll(freshSubscriptions);

        List<SubscriptionItem> items = await SubscriptionItemDB().allSubscriptionItems();

        Navigator.pop(context);
        try {
          for (int i = 0; i < items.length; i++) {
            String filename = items[i].name!;
            // if (await packageExist(filename)) {
            //   continue;
            // }
            FileDownloader fileDownloader = FileDownloader(
                AppUrl.subscriptionItemDownload + '/${items[i].id}?',
                filename: filename);

            setState(() {
              this.downloadMessage = "downloading $filename";
            });
            await fileDownloader.downloadFile((percentage) {
              print("download: ${percentage}%");
              setState(() {
                this.percentage = percentage;
              });
            });

            setState(() {
              this.downloadMessage = "saving $filename";
            });

            String subItem = await readSubscriptionPlan(filename);
            Map<String, dynamic> response = jsonDecode(subItem);

            SubscriptionItem? subscriptionItem = SubscriptionItem.fromJson(response);

            print("saving ${subscriptionItem.name}\n data");

            await CourseDB().insert(subscriptionItem.course!);
            await QuizDB().insertAll(subscriptionItem.quizzes!);
          }

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Subscription data download successfully")));
        } catch (m, e) {
          setState(() {
            isDownloading = false;
          });
          print("Error>>>>>>>> download failed");
          print(m);
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download failed")));
        } finally {
          UserPreferences().getUser().then((user) {
            setState(() {
              isDownloading = false;
              widget.user = user!;
            });
          });
        }
      }
    });
  }

  Future<List<Subscription>> getSubscriptions() async {
    return await ApiCall<Subscription>(AppUrl.subscriptionData, create: (json) {
      return Subscription.fromJson(json);
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
          isDownloading: isDownloading,
          percentage: percentage,
          downloadMessage: downloadMessage,
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

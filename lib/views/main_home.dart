import 'dart:async';
import 'dart:convert';

import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/quiz_db.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/providers/subscription_item_db.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/friends.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/logout.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'more_view.dart';

class MainHomePage extends StatefulWidget {
  static const String routeName = '/main';
  User user;
  int index;
  MainHomePage(this.user, {this.index = 0});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  late List<Widget> _children;
  final _navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex = 0;

  @override
  void initState() {
    _children = [
      HomePage(
        widget.user,
        callback: () {
          tapping(2);
        },
      ),
      CoursesPage(widget.user),
      StorePage(widget.user),
      FriendsView(),
      MoreView(),
    ];
    currentIndex = widget.index;
    print("init");
    checkSubscription();
    super.initState();
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
    getSubscriptions().then((api) {
      if (api == null) return;
      List<Subscription> freshSubscriptions = api.data as List<Subscription>;
      List<Subscription> subscriptions = widget.user.subscriptions;
      if (!compareSubscriptions(freshSubscriptions, subscriptions)) {
        showLoaderDialog(context,
            message: "downloading subscription\n data.....");
        getSubscriptionData().then((api) async {
          print("------------------------------------------------------");

          if (api == null) {
            Navigator.pop(context);
            return;
          }
          List<Subscription> subscriptions = api.data as List<Subscription>;
          await SubscriptionDB().insertAll(subscriptions);
          Navigator.pop(context);

          List<SubscriptionItem> items =
              await SubscriptionItemDB().allSubscriptionItems();
          print(items);
          print("all sub items");
          for (int i = 0; i < items.length; i++) {
            print("downloading ${items[i].name}\n data");
            showLoaderDialog(context,
                message: "downloading..... \n${items[i].name}\n data");
            SubscriptionItem? subscriptionItem =
                await getSubscriptionItem(items[i].id!);
            print(subscriptionItem!);

            await CourseDB().insert(subscriptionItem.course!);
            await QuizDB().insertAll(subscriptionItem.quizzes!);
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Subscription data download successfully")));
        });
      }
    });
  }

  Future<ApiResponse<Subscription>?> getSubscriptions() async {
    Map<String, dynamic> queryParams = {};
    print(AppUrl.questions + '?' + Uri(queryParameters: queryParams).query);
    http.Response response = await http.get(
      Uri.parse(
          AppUrl.subscriptions + '?' + Uri(queryParameters: queryParams).query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': widget.user.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        print("messages returned");
        print(response.body);

        return ApiResponse<Subscription>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          print(dataItem);
          return Subscription.fromJson(dataItem);
        });
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.statusCode);
      print(response.body);
    }
  }

  Future<ApiResponse<Subscription>?> getSubscriptionData() async {
    Map<String, dynamic> queryParams = {};
    print(queryParams);
    print(AppUrl.subscriptionData +
        '?' +
        Uri(queryParameters: queryParams).query);
    http.Response response = await http.get(
      Uri.parse(AppUrl.subscriptionData +
          '?' +
          Uri(queryParameters: queryParams).query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': widget.user.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        print("messages returned");
        return ApiResponse<Subscription>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          print(dataItem);
          return Subscription.fromJson(dataItem);
        });
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.statusCode);
      print(response.body);
    }
  }

  Future<SubscriptionItem?> getSubscriptionItem(int itemId) async {
    Map<String, dynamic> queryParams = {};
    http.Response response = await http.get(
      Uri.parse(AppUrl.subscriptionItem +
          '/$itemId?' +
          Uri(queryParameters: queryParams).query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': widget.user.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        print("messages returned");
        return SubscriptionItem.fromJson(responseData['data']);
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.statusCode);
      print(response.body);
    }
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
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: tapping,
        selectedItemColor: Colors.red,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Store"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(icon: Icon(Icons.more_vert), label: "More"),
        ],
      ),
    );
  }
}

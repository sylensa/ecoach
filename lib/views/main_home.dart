import 'dart:async';
import 'dart:convert';

import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/friends.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/logout.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/drawer.dart';
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
    // checkSubscription();
    super.initState();
  }

  checkSubscription() {
    List<Subscription> subscriptions = widget.user.subscriptions;

    if (subscriptions.length > 0) {
      int active = 0;
      subscriptions.forEach((subscription) {
        if (subscription.endsAt!.isBefore(DateTime.now())) {
          active++;
        }
      });
      if (active == 0) {}
      // setState(() {
      //   futureSubs = TestTakenDB().testsTaken();
      // });
    } else {
      // setState(() {
      //   futureSubs = null;
      // });
    }

    getSubscriptions().then((api) {
      if (api == null) return;
      List<Subscription> subscriptions = api.data as List<Subscription>;
      SubscriptionDB().insertAll(subscriptions);

      // setState(() {
      //   futureSubs = SubscriptionDB().subscriptions();
      // });
    });
  }

  Future<ApiResponse<Subscription>?> getSubscriptions() async {
    Map<String, dynamic> queryParams = {};
    print(queryParams);
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

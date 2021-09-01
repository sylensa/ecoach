import 'dart:async';

import 'package:ecoach/models/user.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/friends.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:flutter/material.dart';

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
        navigatorKey: _navigatorKey,
      ),
      CoursesPage(),
      StorePage(widget.user),
      FriendsView(),
      MoreView(),
    ];
    currentIndex = widget.index;
    print("init");

    super.initState();
  }

  tapping(int index) {
    setState(() {
      currentIndex = index;
    });
    switch (index) {
      case 0:
        _navigatorKey.currentState!.pushNamed(HomePage.routeName);
        break;
      case 1:
        _navigatorKey.currentState!.pushNamed(CoursesPage.routeName);
        break;
      case 2:
        _navigatorKey.currentState!.pushNamed(StorePage.routeName);
        break;
      case 3:
        _navigatorKey.currentState!.pushNamed(FriendsView.routeName);
        break;
      case 4:
        _navigatorKey.currentState!.pushNamed(MoreView.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(user: widget.user),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;

          var index = settings.arguments;
          if (index != null) {
            currentIndex = index as int;
          }
          switch (settings.name) {
            case Routes.home:
              builder = (BuildContext context) => _children[0];
              break;
            case Routes.courses:
              builder = (BuildContext context) => _children[1];

              break;
            case Routes.store:
              builder = (BuildContext context) => _children[2];

              break;
            case Routes.friends:
              builder = (BuildContext context) => _children[3];

              break;
            case "/more":
              builder = (BuildContext context) => _children[4];

              break;
            default:
              builder = (BuildContext context) => _children[0];
          }
          Timer.run(() {
            setState(() {});
          });
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: tapping,
        selectedItemColor: Colors.red,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(icon: Icon(Icons.more_vert), label: "More"),
        ],
      ),
    );
  }
}

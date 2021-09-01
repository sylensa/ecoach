import 'dart:async';

import 'package:ecoach/models/user.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/friends.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/logout.dart';
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
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(icon: Icon(Icons.more_vert), label: "More"),
        ],
      ),
    );
  }
}

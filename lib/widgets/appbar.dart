import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends AppBar {
  // final AppBar appBar;
  // final List<Widget> widgets;
  User user;
  BaseAppBar(BuildContext context, title, {required this.user})
      : super(
          title: Text(title),
          elevation: 0.1,
          actionsIconTheme:
              IconThemeData(size: 30.0, color: Colors.black, opacity: 10.0),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.notifications),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: PopupMenuButton<Choice>(
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: CachedNetworkImage(
                        width: 36,
                        height: 36,
                        fit: BoxFit.fill,
                        imageUrl: "imageUrl goes here",
                      ),
                    ),
                  ],
                ),
                onSelected: (value) {
                  Navigator.pushReplacementNamed(context, value.route);
                },
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return PopupMenuItem<Choice>(
                        value: choice,
                        child: Row(children: <Widget>[
                          Icon(choice.icon),
                          Text(choice.title)
                        ]));
                  }).toList();
                },
              ),
            ),
          ],
        );
}

class Choice {
  const Choice({required this.title, required this.icon, required this.route});

  final String title;
  final IconData icon;
  final String route;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title: 'My Accounts', icon: Icons.account_box, route: Routes.home),
  // const Choice(
  //     title: 'My Contents', icon: Icons.content_copy, route: Routes.home),
  // const Choice(
  //     title: 'My Subscriptions', icon: Icons.subject, route: Routes.home),
  // const Choice(
  //     title: 'Exams Management', icon: Icons.edit_rounded, route: Routes.home),
  const Choice(title: 'Logout', icon: Icons.logout, route: "/logout"),
];

class Result {}

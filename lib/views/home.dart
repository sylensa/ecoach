import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/appbar.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  User user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(context, "Home"),
        drawer: AppDrawer(user: widget.user),
        body: Container(
          color: Colors.white,
        ));
  }
}

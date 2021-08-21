import 'package:ecoach/controllers/auth_controller.dart';
import 'package:ecoach/widgets/appbar.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Scaffold(
        appBar: BaseAppBar(context, "Home"),
        drawer: AppDrawer(),
        body: Container(
          color: Colors.white,
        ));
  }
}

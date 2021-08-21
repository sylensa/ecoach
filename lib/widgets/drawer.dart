import 'package:ecoach/controllers/auth_controller.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach_editor/controller/auth_controller.dart';
import 'package:ecoach_editor/routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createUserAccountHeader(authController),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.home)),
          _createDrawerItem(
              icon: Icons.new_releases,
              text: 'News',
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.news);
              }),
          _createDrawerItem(
              icon: Icons.library_books,
              text: 'Library',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.library)),
          _createDrawerItem(
              icon: Icons.school,
              text: 'Exams & Test',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.exams)),
          Divider(),
          _createDrawerItem(
              icon: Icons.store,
              text: 'Store',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.store)),
          Divider(),
          _createDrawerItem(icon: Icons.group, text: 'Friends'),
          _createDrawerItem(icon: Icons.report, text: 'Reports'),
          Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createUserAccountHeader(AuthController authController) {
    return UserAccountsDrawerHeader(
      accountName: Text(authController.user().name),
      accountEmail: Text(authController.user().phone),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(authController.user().name.substring(0, 1)),
      ),
      decoration: BoxDecoration(color: Colors.orange),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

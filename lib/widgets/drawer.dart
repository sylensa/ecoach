import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  User user;

  AppDrawer({required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createUserAccountHeader(user),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.pushReplacementNamed(context, Routes.home,
                  arguments: user)),
          // _createDrawerItem(
          //     icon: Icons.new_releases,
          //     text: 'News',
          //     onTap: () {
          //       Navigator.pushReplacementNamed(context, Routes.news);
          //     }),
          // _createDrawerItem(
          //     icon: Icons.library_books,
          //     text: 'Library',
          //     onTap: () =>
          //         Navigator.pushReplacementNamed(context, Routes.library)),
          // _createDrawerItem(
          //     icon: Icons.school,
          //     text: 'Exams & Test',
          //     onTap: () =>
          //         Navigator.pushReplacementNamed(context, Routes.exams)),
          // Divider(),
          _createDrawerItem(
              icon: Icons.store,
              text: 'Store',
              onTap: () => Navigator.pushReplacementNamed(context, Routes.store,
                  arguments: user)),
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

  Widget _createUserAccountHeader(User user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.name),
      accountEmail: Text(user.phone!),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.black,
        child: user.avatar != null
            ? CachedNetworkImage(imageUrl: user.avatar!)
            : Text(user.initials),
      ),
      decoration: BoxDecoration(color: Colors.orange),
    );
  }

  Widget _createDrawerItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text!),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:flutter/material.dart';

import 'main_home.dart';

class UserSetup extends StatefulWidget {
  const UserSetup(
    this.user, {
    Key? key,
  }) : super(key: key);
  final User user;

  @override
  _UserSetupState createState() => _UserSetupState();
}

class _UserSetupState extends State<UserSetup> {
  @override
  void initState() {
    UserPreferences().getUser().then((user) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainHomePage(user ?? widget.user)),
          (Route<dynamic> route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Setting up user ..."),
            Center(
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}

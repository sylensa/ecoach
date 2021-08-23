import 'package:ecoach/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Logout extends StatefulWidget {
  static const String routeName = '/news';

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed("/login");
    });
    // it will navigate to login page as soon as this state is built
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences().removeUser();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(child: Text("Thank you")),
          SizedBox(height: 100),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
              child: Text('Login again'))
        ],
      ),
    );
  }
}

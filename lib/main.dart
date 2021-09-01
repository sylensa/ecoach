import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/otp_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/user.dart';
import 'views/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Adeo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: UserPreferences().getUser(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.data != null) {
            User user = snapshot.data as User;
            if (user.activated == null || !user.activated!) {
              return OTPView(user);
            }
            return MainHomePage(user);
          } else if (snapshot.data == null) {
            return LoginPage();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      routes: routes,
    );
  }
}

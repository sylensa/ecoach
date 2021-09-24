import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/otp_view.dart';
import 'package:ecoach/views/welcome_adeo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/user.dart';
import 'views/login_view.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adeo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
                fontFamily: 'Poppins',
              )),
      home: FutureBuilder(
          future: UserPreferences().getUser(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                print('its default');
                if (snapshot.hasError) {
                  print('user is wrong');
                  return Text("${snapshot.error}");
                } else if (snapshot.data != null) {
                  print('data is not null');
                  User user = snapshot.data as User;
                  print('is user activated');
                  if (!user.activated) {
                    return OTPView(user);
                  }
                  print('is user subscribed to a bundle');
                  if (user.subscriptions.length == 1) {
                    return WelcomeAdeo(user);
                  }
                  print('lets go home');
                  return MainHomePage(user);
                } else if (snapshot.data == null) {
                  return LoginPage();
                } else {
                  return CircularProgressIndicator();
                }
            }
          }),
      routes: routes,
    );
  }
}

import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';
import 'views/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<User?> getLoggedInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("id");
    String name = prefs.getString("name");
    String email = prefs.getString("email");
    String phone = prefs.getString("phone");
    String token = prefs.getString("access-token");
    String secret = prefs.getString("session-id");

    if (id == null) return null;

    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      token: token,
    );
  }

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
        future: getLoggedInUser(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.data != null) {
            User user = snapshot.data as User;
            return HomePage(user);
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

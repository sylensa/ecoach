import 'package:ecoach/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> setUser(User? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user!.id);
    prefs.setString("fname", user.fname);
    prefs.setString("lname", user.lname);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);

    return prefs.setString("api-token", user.token);
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("id");
    String fname = prefs.getString("fname");
    String lname = prefs.getString("lname");
    String email = prefs.getString("email");
    String phone = prefs.getString("phone");
    String token = prefs.getString("access-token");

    if (id == null) return null;

    return User(
      id: id,
      fname: fname,
      lname: lname,
      email: email,
      phone: phone,
      token: token,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String> getStringValue(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(args);
    return value;
  }

  Future<int> getIntValue(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(args);
    return value;
  }
}

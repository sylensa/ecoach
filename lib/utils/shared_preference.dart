import 'package:ecoach/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> setUser(User? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user!.id!);
    prefs.setString("fname", user.fname!);
    prefs.setString("lname", user.lname!);
    prefs.setString("email", user.email!);
    prefs.setString("phone", user.phone!);
    prefs.setBool("activated", user.activated ?? false);
    prefs.setString("api_token", user.token!);

    print("${prefs.getString("api_token")}");
    return true;
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt("id");
    String? fname = prefs.getString("fname");
    String? lname = prefs.getString("lname");
    String? email = prefs.getString("email");
    String? phone = prefs.getString("phone");
    String? token = prefs.getString("api_token");
    bool? activated = prefs.getBool("activated");

    print("shared pref: token=$token");
    if (id == null) return null;

    return User(
        id: id,
        fname: fname,
        lname: lname,
        email: email,
        phone: phone,
        token: token,
        activated: activated);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String?> getStringValue(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(args);
    return value;
  }

  Future<int?> getIntValue(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt(args);
    return value;
  }

  setActivated(bool activate) async {
    getUser().then((user) {
      if (user != null) {
        user.setActivated(activate);
        setUser(user);
      }
    });
  }
}

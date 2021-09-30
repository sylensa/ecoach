import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/providers/test_taken_db.dart';
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
    prefs.setBool("activated", user.activated);
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
    bool activated = prefs.getBool("activated") ?? false;

    print("shared pref: token=$token");
    if (id == null) return null;

    User user = User(
        id: id,
        fname: fname,
        lname: lname,
        email: email,
        phone: phone,
        token: token,
        activated: activated);
    List<Subscription> plans = await SubscriptionDB().subscriptions();
    user.subscriptions = plans;
    List<TestTaken> tests = await TestTakenDB().testsTaken();
    user.hasTakenTest = tests.length > 0 ? true : false;

    return user;
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String?> getUserValue(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(args);
    return value;
  }

  Future<bool> setUserLastTest(String testName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('last_test', testName);
  }

  Future<String?> getUserLastTest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('last_test');
    return value ?? "No Test Yet";
  }

  Future<bool> setUserLastNote(String testName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('last_note', testName);
  }

  Future<String?> getUserLastNote() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('last_note');
    return value ?? "No Notes Yet";
  }

  Future<bool> setUserLastStudy(String testName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('last_study', testName);
  }

  Future<bool> setUserLastStudyTopic(String testName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('last_study_topic', testName);
  }

  Future<String?> getUserLastStudy() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('last_study');
    return value ?? "No Study Yet";
  }

  Future<String?> getUserLastStudyTopic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('last_study_topic');
    return value ?? "----";
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

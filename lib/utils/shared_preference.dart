import 'dart:io';

import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future setSeenOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seenOnboard', true);
    return true;
  }

  Future<bool> setUser(User? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user!.id!);
    prefs.setString("name", user.name!);
    prefs.setString("email", user.email!);
    prefs.setString("phone", user.phone ?? "");
    prefs.setBool("activated", user.activated);
    prefs.setString("api_token", user.token!);
    prefs.setBool("is_agent", user.isAgent!);
    prefs.setBool("is_editor", user.isEditor!);
    prefs.setString("signup_date", user.signupDate!.toIso8601String());

    print("pref activated: ${prefs.getBool("activated")}");
    return true;
  }
   setLoginWith({bool status = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("status", status);
    print("get status: ${prefs.getBool("status")}");
  }
  Future<bool> getLoginWith() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status =  prefs.getBool("status");
    status == null ? status = false : status = status;
    print("get status: $status");
    return status;
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt("id");
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? phone = prefs.getString("phone");
    String? token = prefs.getString("api_token");
    bool is_agent = prefs.getBool("is_agent") ?? false;
    bool is_editor = prefs.getBool("is_editor") ?? true;
    bool activated = prefs.getBool("activated") ?? false;
    String? signupDate = prefs.getString("signup_date");

    // print("shared pref: token=$token");
    print("activated= $activated");
    if (id == null) return null;

    User user = User(
        id: id,
        name: name,
        email: email,
        phone: phone,
        token: token,
        isAgent: is_agent,
        isEditor: is_editor,
        activated: activated,
        signupDate: signupDate != null ? DateTime.parse(signupDate) : null);

    List<Subscription> plans = await SubscriptionDB().subscriptions();
    user.subscriptions = plans;
    List<TestTaken> tests = await TestTakenDB().testsTaken();
    user.hasTakenTest = tests.length > 0 ? true : false;
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    print("documentDirectory.path:${documentDirectory.path}");
    user.applicationDirPath = documentDirectory.path;

    return user;
  }

   removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String?> getUserToken() async {
    return getUserValue("api_token");
  }

  Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt("id");
    return value;
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

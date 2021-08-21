import 'dart:async';
import 'dart:convert' show json;
import 'package:ecoach_editor/models/user.dart';
import 'package:ecoach_editor/providers/auth_db.dart';
import 'package:ecoach_editor/util/app_url.dart' show AppUrl;
import 'package:ecoach_editor/util/shared_preference.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthController extends GetxController {
  final user = new User().obs;
  final isOffline = false.obs;

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  loadData() async {
    var user = await getCurrentUser();
    if (user != null) {
      setUser(user);
    }
  }

  void saveUser() {
    saveCurrentUser(this.user.value);
  }

  Future<Map<String, dynamic>> signupUser(String name, String phone,
      String email, String password, String passwordConfirmation) async {
    final Map<String, dynamic> registrationData = {
      'name': name,
      'email': email,
      'phone_number': phone,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    _registeredInStatus = Status.Registering;

    return await http.post(AppUrl.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'}).then((response) {
      var result;
      final Map<String, dynamic> responseData = json.decode(response.body);

      var rcode = responseData['code'];
      if (responseData['status'] == 'success') {
        var userData = responseData['data'];
        print("$userData");

        User authUser = User.fromJson(userData);
        saveCurrentUser(authUser);
        // AuthDB.db.insertUser(authUser);

        result = {
          'status': true,
          'message': 'Successfully registered',
          'data': authUser
        };

      } else {
        result = {
          'status': false,
          'message': 'Registration failed',
          'data': responseData['message']
        };
      }

      return result;
    }).catchError((error) {
      _registeredInStatus = Status.NotRegistered;
      print("the error is $error");
      return {
        'status': false,
        'message': 'Unsuccessful Request',
        'data': error.errorInfo
      };
    });
  }

  Future<Map<String, dynamic>> localLogin(String email, String password) async {
    var result;

    _loggedInStatus = Status.Authenticating;

    List<User> users = await AuthDB.db.localLogin(email, password);

    if (users != null && users.length > 0) {
      User authUser = users.first;

      setUser(authUser);
      _loggedInStatus = Status.LoggedIn;

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      result = {'status': false, 'message': 'could not log in locally'};
    }
    return result;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;

    http.Response response = await http.post(
      AppUrl.login,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    var code = responseData['code'];

    if (responseData['status'] == 'success') {
      Map<String, dynamic> userData = responseData['subUserInfo']['profile'];
      print('+++++++++++++++++++++++++++');
      print(userData.toString());

      User authUser = User.fromMap(userData);
      saveCurrentUser(authUser);

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
  }

  getUser() async {
    return UserPreferences().getUser();
  }

  setUser(User user) {
    if (!kIsWeb) {
      // AuthDB.db.insertUser(user);
    }
    this.user.update((val) {
      val.fromMap(user.toMap());
    });
  }

  Future<bool> saveCurrentUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("uuid", user.uuid);
    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("type", user.type);
    prefs.setString("token", user.token);
    prefs.setString("renewalToken", user.renewalToken);

    print("object prefere");
    print(user.renewalToken);

    setUser(user);
    return prefs.commit();
  }

  Future<User> getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String uuid = prefs.getString("uuid");
    String name = prefs.getString("name");
    String email = prefs.getString("email");
    String phone = prefs.getString("phone");
    String type = prefs.getString("type");
    String token = prefs.getString("token");
    String renewalToken = prefs.getString("renewalToken");

    if (uuid == null) return null;

    return User(
        uuid: uuid,
        name: name,
        email: email,
        phone: phone,
        type: type,
        token: token,
        renewalToken: renewalToken);
  }

  void removeCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("type");
    prefs.remove("token");

    prefs.clear();
  }

  Future<Map<String, dynamic>> verifyUserEmail(String email) async {
    var result;

    final Map<String, dynamic> data = {
      'ecoachsignin':'1',
      'request_type':'GET',
      'email':email,
      'source':'ecoach_app.secure',
      'API_key':'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    };

    return result;
  }

  Future<Map<String, dynamic>> verifyUserPhone(String phone) async {
    var result;

    final Map<String, dynamic> data = {
      'ecoachsignin':'1',
      'request_type':'GET',
      'phone':phone,
      'source':'ecoach_app.secure',
      'API_key':'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    };

    return result;
  }

  Future<Map<String, dynamic>> resetPassword(String identifier) async {
    var result;

    String identifierVar="email";
    RegExp phoneNumberExp = RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
    if(phoneNumberExp.hasMatch(identifier)){
      identifierVar="phone";
    }
    final Map<String, dynamic> data = {
      'ecoachsignin':'1',
      'request_type':'GET',
      identifierVar:identifier,
      'source':'ecoach_app.secure',
      'API_key':'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    };

    return result;
  }

  Future<Map<String, dynamic>> changePassword(String password, String password2) async {
    var result;

    final Map<String, dynamic> data = {
      'ecoachsignin':'1',
      'request_type':'GET',
      'password': password,
      'password2': password2,
      'source':'ecoach_app.secure',
      'API_key':'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    };

    return result;
  }

  bool hasSubscription() {
    return true;
  }

}

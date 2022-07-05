import 'dart:io';

import 'dart:convert';
import 'subscription.dart';

import 'package:path/path.dart';

class User {
  int? id;
  String? uuid;
  String? name;
  String? email;
  String? password;
  String? passwordConfirm;
  String? phone;
  String? type;
  String? gender;
  String? token;
  DateTime? lastLoggedIn;
  String? nickname;
  String? avatar;
  bool activated;
  bool? isAgent;
  bool? isEditor;
  DateTime? signupDate;

  Wallet wallet = Wallet();
  List<Subscription> subscriptions = [];
  bool hasTakenTest = false;
  String applicationDirPath = "";

  User(
      {this.id,
      this.uuid,
      this.name,
      this.nickname,
      this.email,
      this.phone,
      this.password,
      this.passwordConfirm,
      this.type,
      this.gender,
      this.avatar,
      this.token,
      this.isAgent,
      this.isEditor,
      this.lastLoggedIn,
      this.activated = false,
      this.signupDate});

  User.fromGoogle({this.name, this.email, this.avatar, this.activated = false});
  static void UserFromGoogle(
      {String? displayName, String? email, String? photoURL}) {
    User(name: displayName, email: email, avatar: photoURL);
  }

  String get initials {
    String fname;
    String lname;
    try{
     fname = name!.split(" ")[0];
    }catch(e){
      fname = "";
    }
    try{
     lname = name!.split(" ")[1];
    }catch(e){
      lname = "";
    }

    return "${fname.isNotEmpty ? fname.substring(0, 1).toUpperCase() : "" }${lname.isNotEmpty ? lname.substring(0, 1).toUpperCase() : ""}";
  }

  File getImageFile(String name) {
    File file = new File(join(applicationDirPath, name));
    return file;
  }

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User.fromMap(responseData);
  }

  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      nickname: json['nickname'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
      gender: json['gender'],
      token: json['api_token'],
      isAgent: json['is_agent'] ?? false,
      isEditor: json['is_editor'] ?? true,
      avatar: json['avatar'],
      // activated:
      //     json['activated'] is int && json['activated'] == 1 ? true : false,
      activated: json['activated'] ,
      signupDate: DateTime.parse(json['signup_date']));

  fromMap(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    nickname = json['nickname'];
    email = json['email'];
    phone = json['phone'];
    type = json['type'];
    gender = json['gender'];
    token = json['api_token'];
    isAgent = json['is_agent'] ?? false;
    isEditor = json['is_editor'] ?? false;
    avatar = json['avatar'];
    signupDate = json['signup_date'];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "nickname": nickname,
        "email": email,
        "phone": phone,
        "type": type,
        "gender": gender,
        "api_token": token,
        "is_agent": isAgent ?? false,
        "is_editor": isEditor ?? false,
        "avatar": avatar,
        "signup_date": signupDate!.toIso8601String(),
      };

  setActivated(bool activate) {
    activated = activate;
  }

  updateWallet(Wallet wallet) {
    wallet.amount = wallet.amount;
    wallet.updated_at = wallet.updated_at;
  }
}

class Wallet {
  double amount = 0;
  DateTime? updated_at;
}

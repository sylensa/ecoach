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
      this.lastLoggedIn,
      this.activated = false,
      this.signupDate});

  String get initials {
    String fname = name!.split(" ")[0];
    String lname = name!.split(" ")[1];
    return fname.substring(0, 1).toUpperCase() +
        lname.substring(0, 1).toUpperCase();
  }

  File getImageFile(String name) {
    File file = new File(join(applicationDirPath + '/images', name));
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
      avatar: json['avatar'],
      activated:
          json['activated'] is int && json['activated'] == 1 ? true : false,
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

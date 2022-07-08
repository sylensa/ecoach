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
  PromoCode? promoCode;

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
      this.promoCode,
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
      promoCode: json["promo_code"] == null ? null : PromoCode.fromJson(json["promo_code"]),
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
    promoCode = json["promo_code"] == null ? null : PromoCode.fromJson(json["promo_code"]);
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
        "promo_code": promoCode == null ? null : promoCode!.toJson(),
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


class PromoCode {
  PromoCode({
    this.id,
    this.userId,
    this.agentId,
    this.agentPromoCodeId,
    this.promoCode,
    this.isActive,
    this.rate,
    this.agentRate,
    this.createdAt,
    this.updatedAt,
    this.discount,
    this.validityPeriod,
  });

  int? id;
  int? userId;
  int? agentId;
  int? agentPromoCodeId;
  String? promoCode;
  bool? isActive;
  double? rate;
  double? agentRate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? discount;
  String? validityPeriod;

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    agentId: json["agent_id"] == null ? null : json["agent_id"],
    agentPromoCodeId: json["agent_promo_code_id"] == null ? null : json["agent_promo_code_id"],
    promoCode: json["promo_code"] == null ? null : json["promo_code"],
    isActive: json["is_active"] == null ? null : json["is_active"],
    rate: json["rate"] == null ? null : json["rate"].toDouble(),
    agentRate: json["agent_rate"] == null ? null : json["agent_rate"].toDouble(),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    discount: json["discount"] == null ? null : json["discount"],
    validityPeriod: json["validity_period"] == null ? null : json["validity_period"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "agent_id": agentId == null ? null : agentId,
    "agent_promo_code_id": agentPromoCodeId == null ? null : agentPromoCodeId,
    "promo_code": promoCode == null ? null : promoCode,
    "is_active": isActive == null ? null : isActive,
    "rate": rate == null ? null : rate,
    "agent_rate": agentRate == null ? null : agentRate,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "discount": discount == null ? null : discount,
    "validity_period": validityPeriod == null ? null : validityPeriod,
  };
}
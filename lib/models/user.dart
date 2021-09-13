import 'subscription.dart';

class User {
  int? id;
  String? uuid;
  String? fname;
  String? lname;
  String? email;
  String? password;
  String? passwordConfirm;
  String? phone;
  String? type;
  String? gender;
  String? token;
  DateTime? lastLoggedIn;
  String? username;
  String? avatar;
  bool activated;

  Wallet wallet = Wallet();
  List<Subscription> subscriptions = [];

  User(
      {this.id,
      this.uuid,
      this.fname,
      this.lname,
      this.username,
      this.email,
      this.phone,
      this.password,
      this.passwordConfirm,
      this.type,
      this.gender,
      this.avatar,
      this.token,
      this.lastLoggedIn,
      this.activated = false});

  String get name {
    return fname! + " " + lname!;
  }

  String get initials {
    return fname!.substring(0, 1).toUpperCase() +
        lname!.substring(0, 1).toUpperCase();
  }

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User.fromMap(responseData);
  }

  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json['id'],
      uuid: json['uuid'],
      fname: json['fname'],
      lname: json['lname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
      gender: json['gender'],
      token: json['api_token'],
      avatar: json['avatar']);

  fromMap(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    fname = json['fname'];
    lname = json['lname'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    type = json['type'];
    gender = json['gender'];
    token = json['api_token'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "uuid": uuid,
        "fname": fname,
        "lname": lname,
        "username": username,
        "email": email,
        "phone": phone,
        "type": type,
        "gender": gender,
        "api_token": token,
        "avatar": avatar,
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

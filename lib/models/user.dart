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
  String? renewalToken;
  DateTime? lastLoggedIn;
  String? username;

  User(
      {this.id,
      this.uuid,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.password,
      this.passwordConfirm,
      this.type,
      this.gender,
      this.token,
      this.renewalToken,
      this.lastLoggedIn});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User.fromMap(responseData);
  }

  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
      gender: json['gender'],
      token: json['access_token'],
      renewalToken: json['renewal_token']);

  fromMap(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    type = json['type'];
    gender = json['gender'];
    token = json['access_token'];
    renewalToken = json['renewal_token'];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "type": type,
        "gender": gender,
        "token": token,
        "renewalToken": renewalToken,
      };
}

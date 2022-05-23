import 'package:ecoach/models/user.dart';

class UserFromGoogle extends User {
  String? displayName;
  String? email;
  String? photoURL;

  UserFromGoogle({this.displayName, this.email, this.photoURL});

// call super and pass the values
//override super fromJson with all google has to offer
  UserFromGoogle.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    photoURL = json['photoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> mapData = new Map<String, dynamic>();

    mapData["displayName"] = this.displayName;
    mapData["Email"] = this.email;
    mapData["photoURL"] = this.photoURL;

    return mapData;
  }
}

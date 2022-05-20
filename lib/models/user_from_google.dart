import 'package:ecoach/models/user.dart';

class UserFromGoogle extends User {
  String? displayName;
  String? email;
  String? photoURL;

  UserFromGoogle({this.displayName, this.email, this.photoURL})
      : super(
          name: displayName,
          email: email,
          avatar: photoURL,
        );
}

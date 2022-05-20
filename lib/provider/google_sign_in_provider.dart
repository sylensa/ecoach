import 'dart:convert';

import 'package:ecoach/models/user.dart' as adeoUser;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider with ChangeNotifier {
  var googleSignInNow = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  adeoUser.User? userDetailModel;

  allowUserToLogin() async {
    this.googleSignInAccount = await googleSignInNow.signIn();

    userDetailModel = adeoUser.User.fromGoogle(
      name: this.googleSignInAccount!.displayName,
      email: this.googleSignInAccount!.email,
      avatar: this.googleSignInAccount!.photoUrl,
    );
    // var json = JsonEncoder(googleSignInAccount);

    //print('headers from google account: ' + json);
    // userDetailsModel. = UserDetailsModel(
    //   displayName: this.googleSignInAccount!.displayName,
    //   email: this.googleSignInAccount!.email,
    //   photoURL: this.googleSignInAccount!.photoUrl,
    // );
    notifyListeners();
  }

  allowUserToLogout() async {
    this.googleSignInAccount = await googleSignInNow.signOut();
    print('singed out');
    userDetailModel = null;

    notifyListeners();
  }
}

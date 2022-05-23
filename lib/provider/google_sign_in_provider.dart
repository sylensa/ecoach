//import 'dart:convert';

//import 'package:ecoach/models/user.dart' as adeoUser;
import 'package:ecoach/models/user_from_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider with ChangeNotifier {
  var googleSignInNow = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount? googleSignInAccount;
  GoogleSignInAuthentication? googleSignInAuthentication;
  AuthCredential? credential;

  UserFromGoogle? userDetailsModel;

  //adeoUser.User? userDetailModel;

  Future<void> allowUserToLogin() async {
    try {
      this.googleSignInAccount = await googleSignInNow.signIn();

      if (googleSignInAccount != null) {
        googleSignInAuthentication = await googleSignInAccount!.authentication;

        credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication!.accessToken,
          idToken: googleSignInAuthentication!.idToken,
        );
        print('user aToken is: ${googleSignInAuthentication!.accessToken}');
        print('user idToken is: ${googleSignInAuthentication!.idToken}');
      }
      userDetailsModel = UserFromGoogle(
        displayName: this.googleSignInAccount!.displayName,
        email: this.googleSignInAccount!.email,
        photoURL: this.googleSignInAccount!.photoUrl,
      );
    } catch (error) {
      print(error);
    }

    // userDetailModel = adeoUser.User.fromGoogle(
    //   name: this.googleSignInAccount!.displayName,
    //   email: this.googleSignInAccount!.email,
    //   avatar: this.googleSignInAccount!.photoUrl,
    // );
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
    userDetailsModel = null;

    notifyListeners();
  }
}

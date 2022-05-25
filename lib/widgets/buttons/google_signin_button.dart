import 'dart:convert';

import 'package:ecoach/provider/google_sign_in_provider.dart';
import 'package:ecoach/widgets/widgets.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../utils/app_url.dart';

class GoogleSigninButton extends StatefulWidget {
  final BuildContext loginViewContext;
  const GoogleSigninButton({Key? key, required this.loginViewContext})
      : super(key: key);

  @override
  State<GoogleSigninButton> createState() => _GoogleSigninButtonState();
}

class _GoogleSigninButtonState extends State<GoogleSigninButton> {
  //bool _isSigningIn = false;
  signIn() {
    Provider.of<GoogleSignInProvider>(context, listen: false)
        .allowUserToLogin()
        .then((_) async {
      http.Response response = await http.post(
        Uri.parse(AppUrl.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'identifier':
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .userDetailsModel!
                  .email,
          "password": ""
        }),
      );
      print('sign in called');
    });
    print('sign in clicked');
    // showLoaderDialog(widget.loginViewContext, message: "logging in...");
  }

  loginUIController() {
    Provider.of<GoogleSignInProvider>(context, listen: false)
        .allowUserToLogout();
    return Consumer<GoogleSignInProvider>(
      builder: (context, model, child) {
        //if user is already logged in
        if (model.userDetailsModel != null) {
          return alreadyLoggedInScreen(model);
        } else {
          //show signInButton in button
          return signInButton();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loginUIController();
  }

  Widget alreadyLoggedInScreen(GoogleSignInProvider model) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(model.userDetailsModel!.photoURL ?? "").image,
          radius: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: Colors.black,
            ),
            SizedBox(height: 2),
            Text(
              model.userDetailsModel!.email ?? "",
            ),
            SizedBox(height: 2),
            ActionChip(
              label: Text("logout"),
              onPressed: () {
                Provider.of<GoogleSignInProvider>(context, listen: false)
                    .allowUserToLogout();
              },
            ),
          ],
        ),
      ],
    ));
  }

  Widget signInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 2,
        onPressed: signIn,
        icon: Image.asset(
          'assets/icons/google_logo.png',
          height: 32,
          width: 32,
        ),
        label: Text("Sign in with Google"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}

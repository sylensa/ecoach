import 'package:ecoach/provider/google_sign_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleSigninButton extends StatefulWidget {
  const GoogleSigninButton({Key? key}) : super(key: key);

  @override
  State<GoogleSigninButton> createState() => _GoogleSigninButtonState();
}

class _GoogleSigninButtonState extends State<GoogleSigninButton> {
  bool _isSigningIn = false;

  signIn() {
    Provider.of<GoogleSignInProvider>(context, listen: false)
        .allowUserToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          )
        : SizedBox(
            width: double.infinity,
            height: 50,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              elevation: 2,
              onPressed: signIn,

              // setState(() {
              //   _isSigningIn = true;
              // });

              // User? user = await GoogleSignInProvider.signInWithGoogle(
              //     context: context);

              // setState(() {
              //   _isSigningIn = true;
              // });

              // if (user != null) {
              //   Navigator.of(context).pushReplacement(MaterialPageRoute(
              //     builder: (context) => UserInfoScreen(user: user),
              //   ));
              // }
              // },
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

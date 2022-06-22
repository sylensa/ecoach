import 'dart:io';
import 'dart:io' show Platform;

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/google_signin_call.dart';
import 'package:ecoach/revamp/features/account/view/screen/create_account.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/forgot_password.dart';
import 'package:ecoach/views/auth/register_view.dart';

import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/onboard/welcome_adeo.dart';

import 'package:ecoach/views/auth/otp_view.dart';

import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  TextEditingController mail = TextEditingController();
  bool isLoading = false;
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  void loginUser(BuildContext context) async {
    if (_formKey.currentState!.validate() == false) return null;
    _formKey.currentState!.save();

    showLoaderDialog(context, message: "logging in...");

    http.Response response = await http.post(
      Uri.parse(AppUrl.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'identifier': mail.text.trim(),
        "password": password
      }),
    );

    print(response.statusCode);
    print("AppUrl.login:${AppUrl.login}");
    if (response.statusCode == 200 && response.body != "") {
      print("response.body:${response.body}");
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData["status"] == true) {
        var user = User.fromJson(responseData["data"]);
        print("login: token=${user.token}");
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        user.applicationDirPath = documentDirectory.path;
        UserPreferences().setUser(user);
        Navigator.pop(context);
        if (!user.activated) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OTPView(user)),
          );
        } else if (user.subscriptions.length == 0) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WelcomeAdeo(user)),
              (Route<dynamic> route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainHomePage(user)),
              (Route<dynamic> route) => false);
        }
        return;
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
        return;
      }
    } else {
      Navigator.pop(context);
      Map<String, dynamic> responseData = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['message'] ?? "Server Error"),
      ));
      return;
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _handleSignIn(context) async {
    await GoogleSignInApi().signIn((idToken) async {
      await loginGoogleSign(context, idToken);
    });
  }

  loginGoogleSign(context, String? idToken) async {
    if (mounted) {
      print(context);
      showLoaderDialog(context, message: "logging in...");
    }

    await ApiCall<User>(AppUrl.googleLogin,
        params: {'id_token': idToken}, isList: false, create: (json) {
      return User.fromJson(json);
    }, onMessage: (message) {
      print(message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    }, onCallback: (user) async {
      if (mounted) {
        Navigator.pop(context);
      }
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      user.applicationDirPath = documentDirectory.path;
      UserPreferences().setUser(user);

      if (user.subscriptions.length == 0) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(user)),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(user)),
            (Route<dynamic> route) => false);
      }
    }, onError: (err) {
      print(err);
      if (mounted) {
        Navigator.pop(context);
      }
    }).post(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight(context),
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                     children: [
                       Padding(
                         padding: const EdgeInsets.fromLTRB(40, 20.0, 40, 20),
                         child: Form(
                           key: _formKey,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SizedBox(
                                 height: 50,
                               ),
                               Image(
                                 image: AssetImage("assets/images/adeo.png"),
                                 width: 130.0,
                               ),
                               SizedBox(
                                 height: 40,
                               ),
                               TextFormField(
                                 style: TextStyle(color: Colors.black),
                                 controller: mail,
                                   autofocus: true,
                                   keyboardType: TextInputType.emailAddress,
                                   focusNode:emailNode,
                                 onFieldSubmitted: (term){
                                   _fieldFocusChange(context, emailNode, passwordNode);
                                 },
                                 textInputAction: TextInputAction.next,
                                 decoration: InputDecoration(
                                     labelText: 'Email or Phone',
                                     border: OutlineInputBorder()),

                                 validator: (value) {
                                   bool emailValid = RegExp(
                                       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                       .hasMatch(mail.text.trim());

                                   if (value!.isEmpty) {
                                     return 'Please enter your email or phone';
                                   } else if (!emailValid) {
                                     return 'Please enter a valid email or phone';
                                   }
                                   return null;
                                 },
                                 // validator: (mail) {
                                 //   String? _msg;
                                 //   RegExp regex = new RegExp(
                                 //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                 //   if (mail!.isEmpty) {
                                 //     _msg = "Your email is required";
                                 //   } else if (!regex.hasMatch(mail.trimLeft())) {
                                 //     print(mail.length);
                                 //     _msg =
                                 //         "Please provide a valid email or phone number";
                                 //   }
                                 //   return _msg;
                                 // },
                               ),
                               SizedBox(
                                 height: 25,
                               ),
                               TextFormField(
                                 style: TextStyle(color: Colors.black),
                                 focusNode: passwordNode,
                                 decoration: InputDecoration(
                                     labelText: 'Password',
                                     border: OutlineInputBorder()),
                                 obscureText: true,
                                 onSaved: (value) {
                                   password = value!;
                                 },
                                 validator: (text) {
                                   String? _msg;

                                   if (text!.isEmpty) {
                                     _msg = "Your password is required";
                                   }
                                   return _msg;
                                 },
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   TextButton(
                                       onPressed: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) =>
                                                   ForgotPasswordPage()),
                                         );
                                       },
                                       child: Text(
                                         "Forgot Password?",
                                         style: TextStyle(),
                                       )),
                                 ],
                               ),
                               SizedBox(
                                 height: 20,
                               ),
                               SizedBox(
                                 width: double.infinity,
                                 height: 50,
                                 child: ElevatedButton(
                                     style: greenButtonStyle,
                                     onPressed: () {
                                       loginUser(context);
                                     },
                                     child: Text(
                                       "Login",
                                       style: TextStyle(
                                           fontWeight: FontWeight.bold, fontSize: 16),
                                     )),
                               ),
                               if (Platform.isAndroid) SizedBox(height: 20),
                               if (Platform.isAndroid)
                                 signInButton(() async {
                                   await _handleSignIn(context);
                                 }),
                               SizedBox(
                                 height: 20,
                               ),
                               TextButton(
                                 onPressed: () {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => CreateAccountPage()),
                                   );
                                 },
                                 child: RichText(
                                   text: TextSpan(children: [
                                     TextSpan(
                                         text: "Not registered yet? ",
                                         style: TextStyle(color: Colors.black)),
                                     TextSpan(
                                         text: "Create Account",
                                         style: TextStyle(
                                             color: Colors.green,
                                             decoration: TextDecoration.underline))
                                   ]),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: -150,
                  right: -280,
                  child: Image(
                    image: AssetImage('assets/images/square.png'),
                  )),
              Positioned(
                  bottom: -150,
                  left: -310,
                  child: Image(
                    image: AssetImage('assets/images/square.png'),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  Widget signInButton(Function() signIn) {
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
        label: Text("Sign in/up with Google"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}

import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/forgot_password.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/otp_view.dart';
import 'package:ecoach/views/register_view.dart';
import 'package:ecoach/views/welcome_adeo.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  bool isLoading = false;

  void loginUser(BuildContext context) async {
    if (_formKey.currentState!.validate() == false) return null;
    _formKey.currentState!.save();

    showLoaderDialog(context, message: "logging in...");

    http.Response response = await http.post(
      Uri.parse(AppUrl.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          <String, dynamic>{'identifier': email, "password": password}),
    );

    print(response.statusCode);
    if (response.statusCode == 200 && response.body != "") {
      print(response.body);
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData["status"] == true) {
        var user = User.fromJson(responseData["data"]);
        print("login: token=${user.token}");
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight(context),
            child: Center(
              child: Stack(children: [
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
                          decoration: InputDecoration(
                              labelText: 'Email or Phone',
                              border: OutlineInputBorder()),
                          onSaved: (value) {
                            email = value!;
                          },
                          validator: (text) {
                            String? _msg;
                            RegExp regex = new RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                            if (text!.isEmpty) {
                              _msg = "Your email is required";
                            } else if (!regex.hasMatch(text)) {
                              _msg =
                                  "Please provide a valid email or phone number";
                            }
                            return _msg;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
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
                          height: 40,
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
                        SizedBox(
                          height: 50,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
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
      ),
    );
  }
}

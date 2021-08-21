import 'dart:developer';

import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.post(
      Uri.parse("https://dev.shammahapp.com/api/signin"),
      headers: {'Content-Type': 'application/json'},
      body: json
          .encode(<String, dynamic>{'identifier': email, "password": password}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData["status"] == true) {
        var user = User.fromJson(responseData["data"]);
        setLoggedInUser(user);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(user)),
            (Route<dynamic> route) => false);
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        setState(() {
          isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
        return;
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Server Error"),
      ));
      return;
    }
  }

  setLoggedInUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user.id);
    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("access-token", user.token);
    // prefs.setString("session-id", user.sessionId);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Enter your email'),
                      onSaved: (value) {
                        email = value!;
                      },
                      validator: (text) {
                        String _msg = "";
                        RegExp regex = new RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (text!.isEmpty) {
                          _msg = "Your email is required";
                        } else if (!regex.hasMatch(text)) {
                          _msg = "Please provide a valid email address";
                        }
                        return _msg;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Enter your password'),
                      obscureText: true,
                      onSaved: (value) {
                        password = value!;
                      },
                      validator: (text) {
                        String _msg = "";

                        if (text!.isEmpty) {
                          _msg = "Your password is required";
                        }
                        return _msg;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Builder(
                      builder: (context) {
                        return ElevatedButton(
                            onPressed: () {
                              if (isLoading == true) {
                                return;
                              }
                              loginUser(context);
                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text("Login"));
                      },
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
                        child: Text("Select to Register",
                            style: TextStyle(
                                decoration: TextDecoration.underline)))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

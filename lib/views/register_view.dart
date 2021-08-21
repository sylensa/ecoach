import 'dart:convert';
import 'dart:async';

import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "";
  String email = "";
  String password = "";
  List departments = [];
  bool isLoading = false;

  doRegister(BuildContext context) async {
    if (_formKey.currentState!.validate() == false) return null;
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.post(
      Uri.parse(AppUrl.register),
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

  initState() {
    super.initState();
  }

  String? _selectedGender = 'Gender';
  List<String> _gender = ['Gender', 'Male', 'Female'];

  String? _selectedAge = "Age";
  List<String> _ages = ['Age', 'Adult', 'Youth', 'Teen', 'Children'];

  setLoggedInUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user.id);
    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("access-token", user.token);
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
                      height: 70,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Full Name'),
                      onSaved: (value) {
                        name = value!;
                      },
                      validator: (text) {
                        String _msg = "";
                        if (text!.isEmpty) {
                          _msg = "Your name is required";
                        }
                        return _msg;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email Address'),
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
                      height: 20,
                    ),
                    DropdownButtonFormField(
                        isExpanded: true,
                        value: _selectedGender,
                        validator: (value) => value == null
                            ? 'Please select in your gender'
                            : null,
                        items: _gender.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text("Gender"),
                        onChanged: (String? newVal) {
                          setState(
                            () {
                              _selectedGender = newVal;
                            },
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton(
                        isExpanded: true,
                        value: _selectedAge,
                        items: _ages.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text("Age"),
                        onChanged: (String? newVal) {
                          setState(() {
                            _selectedAge = newVal;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
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
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      onSaved: (value) {},
                      validator: (text) {
                        String _msg = "";

                        if (text!.isEmpty) {
                          _msg = "Your password is required";
                        }
                        // else if (text != password) {
                        //   return "Password must be same as above";
                        // }
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
                              doRegister(context);
                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text("Register"));
                      },
                    ),
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

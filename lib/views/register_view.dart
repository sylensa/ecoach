import 'dart:convert';

import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/login_view.dart';
import 'package:ecoach/views/otp_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  String password = "";
  bool isLoading = false;

  doRegister(BuildContext context) async {
    if (_formKey.currentState!.validate() == false) {
      return null;
    }
    _formKey.currentState!.save();

    showLoaderDialog(context, message: "signing up ...");

    http.Response response = await http.post(
      Uri.parse(AppUrl.register),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'fname': firstName,
        'lname': lastName,
        'gender': _selectedGender!.substring(0, 1),
        'email': email,
        'phone': phone,
        "password": password,
        "password_confirmed": password
      }),
    );

    print(response.body);
    print("response got here");
    print(response.statusCode);
    if (response.statusCode == 200 && response.body != "") {
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData["status"] == true) {
        var user = User.fromJson(responseData["data"]);
        UserPreferences().setUser(user);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OTPView(user);
        }));

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));

        return;
      } else {
        Navigator.pop(context);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
        return;
      }
    } else {
      Navigator.pop(context);
      if (response.body != "") {
        Map<String, dynamic> responseData = json.decode(response.body);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      }

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Server Error"),
      ));
      return;
    }
  }

  initState() {
    super.initState();
  }

  TextEditingController passwordController = new TextEditingController();
  String? _selectedGender = 'Gender';
  List<String> _gender = ['Gender', 'Male', 'Female'];

  String? selectedUserType = "student";
  List<String> userType = ['student', 'teacher', 'parent'];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'First Name'),
                      onSaved: (value) {
                        firstName = value!;
                      },
                      validator: (text) {
                        String? _msg;
                        if (text!.isEmpty) {
                          _msg = "Your first name is required";
                        }
                        return _msg;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Last Name'),
                      onSaved: (value) {
                        lastName = value!;
                      },
                      validator: (text) {
                        String? _msg;
                        if (text!.isEmpty) {
                          _msg = "Your last name is required";
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
                        String? _msg;
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
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone'),
                      onSaved: (value) {
                        phone = value!;
                      },
                      validator: (text) {
                        String? _msg;
                        RegExp regex = new RegExp(
                            r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
                        if (text!.isEmpty) {
                          _msg = "Your phone number is required";
                        } else if (!regex.hasMatch(text)) {
                          _msg = "Please provide a valid phone";
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
                        value: selectedUserType,
                        items: userType.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        hint: Text("User Type"),
                        onChanged: (String? newVal) {
                          setState(() {
                            selectedUserType = newVal;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
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
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      onSaved: (value) {},
                      validator: (text) {
                        String? _msg;

                        if (text!.isEmpty) {
                          _msg = "Your password is required";
                        } else if (text != passwordController.text) {
                          return "Password must be same as above";
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
                              doRegister(context);
                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text("Register"));
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text("Select to Login",
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

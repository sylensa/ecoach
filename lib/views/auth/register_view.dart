import 'dart:convert';
import 'dart:io';

import 'package:ecoach/revamp/features/account/view/screen/log_in.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/forgot_password.dart';
import 'package:ecoach/views/auth/login_view.dart';
import 'package:ecoach/views/auth/otp_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:phone_form_field/phone_form_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String firstName = "";
  String lastName = "";
  String name = "";
  String email = "";
  String phone = "";
  String password = "";
  TextEditingController mail = TextEditingController();
  bool isLoading = false;

  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
        'name': name,
        'gender': "----",
        'email': mail.text.trim(),
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
        print("registering: token=${user.token}");
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        user.applicationDirPath = documentDirectory.path;
        UserPreferences().setUser(user);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OTPView(user);
        }));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));

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
      if (response.body != "") {
        Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server Error"),
        ));
      }

      return;
    }
  }

  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Get started with Adeo",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'First Name and Last Name',
                              border: OutlineInputBorder()),
                          onSaved: (value) {
                            name = value!.trim();
                          },
                          validator: (text) {
                            String? _msg;
                            if (text!.isEmpty) {
                              _msg = "Your name is required";
                            }
                            if (text.trim().split(" ").length < 2) {
                              _msg =
                                  "Please enter First name and Surname. Exactly 2 names";
                            }
                            return _msg;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder()),
                          controller: mail,

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
                          // validator: (text) {
                          //   String? _msg;
                          //   text = text!.trim();
                          //   RegExp regex = new RegExp(
                          //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          //   if (text.isEmpty) {
                          //     _msg = "Your email is required";
                          //   } else if (!regex.hasMatch(text)) {
                          //     _msg = "Please provide a valid email address";
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // IntlPhoneField(
                        //   style: TextStyle(color: Colors.black),
                        //   decoration: InputDecoration(
                        //       labelText: 'Phone', border: OutlineInputBorder()),
                        //   onSaved: (value) {
                        //     phone = value!.completeNumber.trim();
                        //   },
                        //   initialCountryCode: 'GH',
                        // ),
                        // PhoneNumberFormField(
                        //   autovalidateMode: AutovalidateMode.always,
                        //   style: TextStyle(color: Colors.black),
                        //   controller: phoneNumberEditingController,
                        //   decoration: InputDecoration(
                        //       border: UnderlineInputBorder(),
                        //       labelStyle: TextStyle(
                        //           color: Colors.black,
                        //           backgroundColor: Colors.black),
                        //       fillColor: Colors.black,
                        //       helperStyle: TextStyle(color: Colors.black),
                        //       floatingLabelStyle:
                        //           TextStyle(color: Colors.black)),
                        // ),
                        PhoneFormField(
                          key: Key('phone-field'),
                          style: TextStyle(color: Colors.black),
                          controller: null, // controller & initialValue value
                          initialValue:
                              null, // can't be supplied simultaneously
                          shouldFormat: true, // default
                          defaultCountry: IsoCode.GH, // default
                          decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(
                                  color: Colors.black), // default to null
                              border:
                                  OutlineInputBorder() // default to UnderlineInputBorder(),
                              // ...
                              ),
                          validator: PhoneValidator
                              .validMobile(), // default PhoneValidator.valid()

                          showFlagInInput: true, // default
                          flagSize: 16, // default
                          autofillHints: [
                            AutofillHints.telephoneNumber
                          ], // default to null
                          enabled: true, // default
                          autofocus: false, // default
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction, // default
                          onSaved: (PhoneNumber? p) {}, // default null
                          onChanged: (PhoneNumber? p) {
                            phone = p!.international;
                          }, // default null
                          // ... + other textfield params
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: passwordController,
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
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder()),
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
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: greenButtonStyle,
                              onPressed: () {
                                doRegister(context);
                              },
                              child: Text("Create Account")),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInPage()),
                            );
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "Log In",
                                  style: TextStyle(
                                      color: Colors.green,
                                      decoration: TextDecoration.underline))
                            ]),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Text("Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                ))),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -160,
                    right: -70,
                    child: Image(
                      image: AssetImage('assets/images/leave.png'),
                    )),
                Positioned(
                    bottom: -150,
                    left: -110,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: Image(
                        image: AssetImage('assets/images/leave.png'),
                      ),
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

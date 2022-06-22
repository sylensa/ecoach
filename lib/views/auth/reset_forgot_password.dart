import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/revamp/features/account/view/screen/log_in.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/forgot_password.dart';
import 'package:ecoach/views/auth/login_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ResetForgotPassword extends StatefulWidget {
  const ResetForgotPassword(this.phone, {Key? key}) : super(key: key);
  final String phone;

  @override
  _ResetForgotPasswordState createState() => _ResetForgotPasswordState();
}

class _ResetForgotPasswordState extends State<ResetForgotPassword> {
  String password = "";
  bool isLoading = false;
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  resetPassword(BuildContext context) {
    if (_formKey.currentState!.validate() == false) return null;
    _formKey.currentState!.save();
    showLoaderDialog(context, message: "Resetting password....");
    ApiCall(AppUrl.forgotPasswordReset, params: {
      'phone': widget.phone,
      'password': password,
      'confirm_password': password
    }, create: (Map<String, dynamic> dataItem) {
      return null;
    }, onCallback: (data) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LogInPage();
      }));
    }, onError: (err) {
      print(err);
      Navigator.pop(context);
    }, onMessage: (message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
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
            child: Center(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20.0, 40, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Reset your Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          "Enter your new password",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        SizedBox(
                          height: 150,
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
                                resetPassword(context);
                              },
                              child: Text(
                                "Complete",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                                (route) {
                              return true;
                            });
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Start process all over again? ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "Forgot password",
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

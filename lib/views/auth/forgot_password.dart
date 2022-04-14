import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/login_view.dart';
import 'package:ecoach/views/auth/forgot_password_otp.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String phone = "";
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  resetPassword(BuildContext context) {
    if (_formKey.currentState!.validate() == false) return null;
    _formKey.currentState!.save();

    showLoaderDialog(context, message: "logging in...");

    ApiCall(AppUrl.forgotPassword, params: {'phone': phone},
        create: (Map<String, dynamic> dataItem) {
      return null;
    }, onCallback: (data) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ForgotPasswordOtp(phone);
      }));
    }, onError: (err) {
      print(err);
      Navigator.pop(context);
    }, onMessage: (message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }).post(context).then((value) {});
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
                          "Enter your phone number",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        SizedBox(
                          height: 150,
                        ),
                        IntlPhoneField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Phone', border: OutlineInputBorder()),
                          onSaved: (value) {
                            phone = value!.number;
                          },
                          initialCountryCode: 'GH',
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                              style: greenButtonStyle,
                              onPressed: () {
                                resetPassword(context);
                              },
                              child: Text(
                                "Reset Password",
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
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "No longer require password reset? ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "Log in",
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

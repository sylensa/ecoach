import 'dart:async';
import 'dart:convert';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/revamp/features/account/view/screen/log_in.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/forgot_password.dart';
import 'package:ecoach/views/auth/login_view.dart';
import 'package:ecoach/views/auth/reset_forgot_password.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOtp extends StatefulWidget {
  const ForgotPasswordOtp(this.phone, {Key? key}) : super(key: key);
  final String phone;

  @override
  _ForgotPasswordOtpState createState() => _ForgotPasswordOtpState();
}

class _ForgotPasswordOtpState extends State<ForgotPasswordOtp> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        resendPin();
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  resendPin() async {
    showLoaderDialog(context, message: "resending token ...");

    ApiCall(AppUrl.forgotPassword, params: {'phone': widget.phone},
        create: (Map<String, dynamic> dataItem) {
      return null;
    }, onCallback: (data) {
      Navigator.pop(context);
    }, onError: (err) {
      print(err);
      Navigator.pop(context);
    }, onMessage: (message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }).post(context);
  }

  verifyOtpCode() async {
    showLoaderDialog(context, message: "Verifying user....");
    ApiCall(AppUrl.forgotPasswordVerify,
        params: {'phone': widget.phone, 'pin': currentText},
        create: (Map<String, dynamic> dataItem) {
      return null;
    }, onCallback: (data) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ResetForgotPassword(widget.phone);
      }));
    }, onError: (err) {
      print('onError');
      print(err);
      Navigator.pop(context);
    }, onMessage: (message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }).post(context).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: screenHeightExcludingToolbar(context),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Reset your Password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phone,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      autovalidateMode: AutovalidateMode.always,
                      enablePinAutofill: true,
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 6) {
                          return "Incomplete otp";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(
                          fontSize: 20, height: 1.6, color: Colors.black),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,

                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                        print(v);
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color(0xFF91D3B3),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ElevatedButton(
                  style: greenButtonStyle,
                  onPressed: () {
                    formKey.currentState!.validate();
                    // conditions for validating
                    if (currentText.length < 6) {
                      errorController!.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() {
                        hasError = true;
                      });
                    } else {
                      verifyOtpCode();
                    }
                  },
                  child: Center(
                      child: Text(
                    "VERIFY".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => LogInPage()),
                      (route) {
                    return true;
                  });
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
    );
  }
}

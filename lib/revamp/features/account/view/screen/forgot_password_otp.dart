import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/account/view/screen/reset_forgot_password.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pinput/pinput.dart';
import 'package:ecoach/views/auth/register_view.dart';
import 'package:ecoach/views/onboard/welcome_adeo.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordOTP extends StatefulWidget {
  final String phone;
  ForgotPasswordOTP(this.phone);

  @override
  State<ForgotPasswordOTP> createState() => _ForgotPasswordOTPState();
}

class _ForgotPasswordOTPState extends State<ForgotPasswordOTP> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController currentTextController = TextEditingController();
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
        params: {'phone': widget.phone, 'pin': currentTextController.text},
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
      backgroundColor: kHomeBackgroundColor,
      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Platform.isIOS
              ? Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )
              : Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            left: 18,
            right: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your pin ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter the 6 digit pin you have received via sms",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 82,
              ),
              Pinput(
                controller: currentTextController,
                length: 6,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Code not received ?",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      resendPin();
                    },
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(
                          0xFF007FC1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 56,
              ),
              InkWell(
                onTap: () {
                  print("currentTextController:${currentTextController.text}");
                  verifyOtpCode();
                  // Get.to(() => const MainHomePage());
                },
                child: Container(
                  height: 66,
                  child: const Center(
                    child: Text(
                      "Verify and Create Account",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

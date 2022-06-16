
import 'dart:convert';
import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/google_signin_call.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/lib/core/widget/google_button.dart';
import 'package:ecoach/lib/features/account/view/screen/create_account.dart';
import 'package:ecoach/lib/features/account/view/screen/log_in.dart';
import 'package:ecoach/lib/features/account/view/screen/phone_number_verification.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/auth/forgot_password.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;


import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_styles.dart';

class ResetForgotPassword extends StatefulWidget {
  String phone;
   ResetForgotPassword(this.phone);

  @override
  State<ResetForgotPassword> createState() => _ResetForgotPasswordState();
}

class _ResetForgotPasswordState extends State<ResetForgotPassword> {
  String password = "";
  bool isLoading = false;
  TextEditingController confirmPasswordController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  resetPassword(BuildContext context) {
    // if (_formKey.currentState!.validate() == false) return null;
    // _formKey.currentState!.save();
    showLoaderDialog(context, message: "Resetting password....");
    ApiCall(AppUrl.forgotPasswordReset, params: {
      'phone': widget.phone,
      'password': passwordController.text,
      'confirm_password': passwordController.text
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
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: Image.asset(
                  'assets/images/adeo_logo.png',
                  height: 76,
                  width: 126,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              const Text(
                "Password Reset",
                style: TextStyle(fontSize: 27),
              ),

              SizedBox(
                height: 3.h,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    color: Color(0xFFB9B9B9),
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              TextField(
                controller:confirmPasswordController  ,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(
                    color: Color(0xFFB9B9B9),
                    fontSize: 16,
                  ),
                ),
              ),


              SizedBox(
                height: 4.h,
              ),
              SizedBox(
                height: 66,
                child: Material(
                  color: const Color(0xFF00C9B9),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      if(confirmPasswordController.text.isNotEmpty && passwordController.text.isNotEmpty){
                        if(confirmPasswordController.text ==  passwordController.text){
                          resetPassword(context);
                        }else{
                          toastMessage("Password does not match");

                        }
                      }else{
                        toastMessage("All fields are required");
                      }

                    },
                    child: const Center(
                      child: Text(
                        "Reset Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAll(() => const CreateAccountPage());
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

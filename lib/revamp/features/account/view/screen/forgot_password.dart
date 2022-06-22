
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/account/view/screen/forgot_password_otp.dart';
import 'package:ecoach/revamp/features/account/view/screen/phone_number_verification.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';

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

class ForgotPassword extends StatefulWidget {

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  Country? country;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumbersController = TextEditingController();

  String phone = "";


  resetPassword(BuildContext context) {


    showLoaderDialog(context, message: "Sending code...");

    ApiCall(AppUrl.forgotPassword, params: {'phone': "${country != null ? country!.phoneCode : "233"}${phoneNumbersController.text.substring(1,10)}"},
        create: (Map<String, dynamic> dataItem) {
          return null;
        }, onCallback: (data) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ForgotPasswordOTP("${country != null ? country!.phoneCode : "233"}${phoneNumbersController.text.substring(1,10)}");
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
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your number ",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "You will receive a 6 digit code for phone \nnumber verification",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 42,
              ),
              Container(
                height: 132,
                child: Column(
                  children: [
                    Expanded(
                      child: ListTile(
                        onTap: () {
                          pickCountry();
                        },
                        leading: Text(
                          country?.flagEmoji ?? '',
                          style: const TextStyle(fontSize: 27),
                        ),
                        title: Text(
                          country?.displayNameNoCountryCode ?? "Ghana",
                          style: const TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 17.0,
                                  top: 19,
                                  bottom: 20,
                                ),
                                child: Text(
                                  "+ ${country?.phoneCode ?? 233}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const SizedBox(
                                height: 30,
                                width: 1,
                                child: VerticalDivider(
                                  color: Color(0xFF707070),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: phoneNumbersController ,
                                  decoration: InputDecoration(
                                      focusedBorder: InputBorder.none,
                                      hintText: "Phone number",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(
                height: 38,
              ),
              InkWell(
                onTap: () {
                  if(phoneNumbersController.text.length > 9){
                    print("${country != null ? country!.phoneCode : "233"}${phoneNumbersController.text.substring(1,10)}");
                    resetPassword(context);
                  }else{
                    toastMessage("Expecting 10 numbers");
                  }



                },
                child: Container(
                  height: 66,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 17,
                        )
                      ],
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

  pickCountry() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500, // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country selectedCountry) {
        setState(() {
          country = selectedCountry;
        });
      },
    );
  }
}

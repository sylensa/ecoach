import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
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

class PhoneNumberVerification extends StatefulWidget {
  final User user;
   PhoneNumberVerification(this.user);

  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {

  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController currentTextController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  loadTrtTest(User user)async{
    ApiCall<Data>(AppUrl.new_user_data, isList: false,
        create: (Map<String, dynamic> json) {
          return Data.fromJson(json);
        }, onCallback: (data) async{
          if (data != null) {
            await LevelDB().insertAll(data!.levels!);
            await CourseDB().insertAll(data!.courses!);
          }
          // await getPlan(user);
          if (mounted) {
            Navigator.pop(context);
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainHomePage(widget.user)),
                  (Route<dynamic> route) => false);

        }, onError: (e) {
          Navigator.pop(context);
        }).get(context);
  }
  @override
  void initState() {
    // PlanController().getPlan();
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
    showLoaderDialog(context, message: "resending pin ...");

    http.Response response = await http.get(
      Uri.parse(AppUrl.resend_pin),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': widget.user.token!
      },
    );

    print(response.body);
    print(response.statusCode);
    try {
      if (response.statusCode == 200 && response.body != "") {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message']),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message']),
          ));
        }
      } else {
        if (response.body != "") {
          Map<String, dynamic> responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message'] ?? "Server Error"),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      Navigator.pop(context);
    }
  }

  verifyOtpCode() async {
    // post(AppUrl.otp_verify).then((value) => {}).catchError((error) {});
    String? token = widget.user.token;
    print("token=$token");
    if (token == null) {
      return;
    }
    showLoaderDialog(context, message: "Verifying user....");
    http.Response response = await http.post(
      Uri.parse(AppUrl.otp_verify),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': token
      },
      body: jsonEncode(<String, dynamic>{
        'pin': int.parse(currentTextController.text),
      }),
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 && response.body != "") {
      Map<String, dynamic> responseData = json.decode(response.body);
      inspect(widget.user);

      if (responseData["status"] == true) {
        UserPreferences().setActivated(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      }
      await loadTrtTest(widget.user);

    } else {
      Navigator.pop(context);
      if (response.body != "") {
        Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message'] ?? "Server Error"),
        ));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 63,
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
                children:  [
                  Text(
                    "Code not received ?",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: (){
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

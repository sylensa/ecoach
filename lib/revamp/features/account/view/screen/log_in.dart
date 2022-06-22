
import 'dart:convert';
import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/google_signin_call.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/revamp/core/widget/google_button.dart';
import 'package:ecoach/revamp/features/accessment/views/screens/choose_level.dart';
import 'package:ecoach/revamp/features/account/view/screen/create_account.dart';
import 'package:ecoach/revamp/features/account/view/screen/forgot_password.dart';
import 'package:ecoach/revamp/features/account/view/screen/phone_number_verification.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
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

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  loadTryTest(User user,bool isGoogleLogin)async{
    ApiCall<Data>(AppUrl.new_user_data, isList: false,
        create: (Map<String, dynamic> json) {
          return Data.fromJson(json);
        }, onCallback: (data) async{
          if (data != null) {
            await LevelDB().insertAll(data!.levels!);
            await CourseDB().insertAll(data!.courses!);
          }

          if (mounted) {
            Navigator.pop(context);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Login successfully"),
            ));
          }
          if(isGoogleLogin){
            if (user.subscriptions.length == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainHomePage(user)),
                      (Route<dynamic> route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainHomePage(user)),
                      (Route<dynamic> route) => false);
            }
          }else{
            if (!user.activated) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhoneNumberVerification(user)),
              );
            }
            else if (user.subscriptions.length == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainHomePage(user)),
                      (Route<dynamic> route) => false);
            }
            else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainHomePage(user)),
                      (Route<dynamic> route) => false);
            }
          }


        }, onError: (e) {
          Navigator.pop(context);
        }).get(context);
  }

  loginGoogleSign(context, String? idToken) async {
    if (mounted) {
      print(context);
      showLoaderDialog(context, message: "logging in...");
    }

    await ApiCall<User>(AppUrl.googleLogin,
        params: {'id_token': idToken}, isList: false, create: (json) {
          return User.fromJson(json);
        }, onMessage: (message) {
          print(message);
        }, onCallback: (user) async {
          Directory documentDirectory = await getApplicationDocumentsDirectory();
          user.applicationDirPath = documentDirectory.path;
          await UserPreferences().setUser(user);
          await UserPreferences().setLoginWith(status: true);
          await loadTryTest(user,true);
        }, onError: (err) {
          print(err);
          if (mounted) {
            Navigator.pop(context);
          }
        }).post(context);
  }
  Future<void> _handleSignIn(context) async {
    await GoogleSignInApi().signIn((idToken) async {
      print("idToken:$idToken");
      await loginGoogleSign(context, idToken);
    });
  }
  void loginUser(BuildContext context) async {
    // if (_formKey.currentState!.validate() == false) return null;
    // _formKey.currentState!.save();

    showLoaderDialog(context, message: "logging in...");

    http.Response response = await http.post(
      Uri.parse(AppUrl.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'identifier': _emailController.text.trim(),
        "password": _passwordController.text
      }),
    );

    print(response.statusCode);
    print("AppUrl.login:${AppUrl.login}");
    if (response.statusCode == 200 && response.body != "") {
      print("response.body:${response.body}");
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData["status"] == true) {
        var user = User.fromJson(responseData["data"]);
        print("login: token=${user.token}");
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        user.applicationDirPath = documentDirectory.path;
        UserPreferences().setUser(user);
        await loadTryTest(user,false);

      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
        return;
      }
    } else {
      Navigator.pop(context);
      Map<String, dynamic> responseData = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['message'] ?? "Server Error"),
      ));
      return;
    }
  }

  @override
  void initState(){
    // PlanController().getPlan();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                "Welcome Back",
                style: TextStyle(fontSize: 27),
              ),
              const Text(
                "You've been missed!",
                style: TextStyle(fontSize: 27),
              ),
              SizedBox(
                height: 3.h,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    hintText: "email",
                    hintStyle: const TextStyle(
                        color: Color(0xFFB9B9B9), fontSize: 16)),
              ),
              SizedBox(
                height: 3.h,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  hintText: "password",
                  hintStyle: const TextStyle(
                    color: Color(0xFFB9B9B9),
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              InkWell(
                onTap: () {
                  goTo(context,  ForgotPassword());
                },
                child: const Text(
                  'forgotten password ?',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12),
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
                      if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                        loginUser(context);
                      }else{
                        toastMessage("All fields are required");
                      }

                    },
                    child: const Center(
                      child: Text(
                        "Access Account",
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
              if (Platform.isAndroid)
              Column(
                children: [
                  Text(
                    "or",
                    textAlign: TextAlign.center,
                    style: TextStyles.medium(context)
                        .copyWith(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: ()async{
                      await _handleSignIn(context);
                    },
                    child: GoogleButton(),
                  ),
                ],
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


import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/api/google_signin_call.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/revamp/core/utils/text_styles.dart';
import 'package:ecoach/revamp/core/widget/custom_text_field_form.dart';
import 'package:ecoach/revamp/core/widget/google_button.dart';
import 'package:ecoach/revamp/features/account/view/screen/phone_number.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/account/view/screen/phone_number_verification.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'log_in.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  loadTrtTest(User user,bool isGoogleLogin)async{
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
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
            ));
          }
        }, onCallback: (user) async {
          Directory documentDirectory = await getApplicationDocumentsDirectory();
          user.applicationDirPath = documentDirectory.path;
          await UserPreferences().setUser(user);
          await UserPreferences().setLoginWith(status: true);
          await loadTrtTest(user,true);
        }, onError: (err) {
          print(err);
          if (mounted) {
            Navigator.pop(context);
          }
        }).post(context);
  }
  Future<void> _handleSignIn(context) async {
    await GoogleSignInApi().signIn((idToken) async {
      await loginGoogleSign(context, idToken);
    });
  }

  @override
  void initState() {
    super.initState();
    // PlanController().getPlan();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
            CustomTextField(
                obscureText: false,
                textInputType: TextInputType.text,
                title: "Name",
                controller: fullNameController,
                hintText: "Eg. John Doe",
                labelText: ""),
            SizedBox(
              height: 3.h,
            ),
            CustomTextField(
                obscureText: false,
                title: "Email",
                textInputType: TextInputType.emailAddress,
                controller: emailController,
                hintText: "Eg. doe@gmail.com",
                labelText: ""),
            SizedBox(
              height: 3.h,
            ),
            CustomTextField(
              obscureText: true,
                textInputType: TextInputType.text,
                title: "Password",
                controller: passwordController,
                hintText: "Pick a strong password",
                labelText: ""),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              height: 66,
              child: Material(
                color: Color(0xFF00C9B9),
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  onTap: () {
                    if(fullNameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                      Get.to(() =>  GetPhoneNumber(fullName: fullNameController.text,email: emailController.text,password: passwordController.text,));
                    }else{
                      toastMessage("All fields are required");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Create Account",
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
                Text(
                  "Alredy a member?",
                  style: TextStyles.body2(context).copyWith(
                    color: Colors.grey.shade600,
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
                    Get.to(() => const LogInPage());
                  },
                  child: Text(
                    "Log In",
                    style: TextStyles.body2(context).copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

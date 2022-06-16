
import 'package:ecoach/lib/core/utils/app_colors.dart';
import 'package:ecoach/lib/features/account/view/screen/log_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../account/view/screen/create_account.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainAppColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9B9),
              Color(0xFF00A396),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/welcome_1.png"),
                      const SizedBox(
                        height: 1,
                      ),
                      Image.asset("images/welcome_2.png")
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/welcome_3.png"),
                      const SizedBox(
                        height: 1,
                      ),
                      Image.asset("images/welcome_4.png"),
                      const SizedBox(
                        height: 1,
                      ),
                      Image.asset("images/welcome_5.png")
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/welcome_6.png"),
                      const SizedBox(
                        height: 33,
                      ),
                      Image.asset("images/welcome_school.png"),
                      const SizedBox(
                        height: 59,
                      ),
                      Image.asset("images/welcome_7.png")
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/welcome_8.png"),
                      const SizedBox(
                        height: 1,
                      ),
                      Image.asset("images/welcome_9.png"),
                      const SizedBox(
                        height: 1,
                      ),
                      Image.asset("images/welcome_10.png")
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 41,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 27.0, right: 27.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome \nto Adeo',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  const Text(
                    """Prep for your upcoming exams with ease.\nBECE | WASSCE | JAMB and many others.""",
                    style: TextStyle(
                      color: kHomeTextColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 76,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const CreateAccountPage());
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(35),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Join Now",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00A89B),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Alredy a member?",
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const LogInPage());
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

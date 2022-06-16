
import 'package:ecoach/lib/core/utils/app_colors.dart';
import 'package:ecoach/lib/features/questions/view/screens/quiz_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StartAccessmentPage extends StatelessWidget {
  const StartAccessmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessment'),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Get.to(() => const QuizQuestion());
        },
        child: Container(
          color: kAccessmentButtonColor,
          padding: const EdgeInsets.all(15),
          child: const Text(
            'Begin Accessment',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            "images/accessment_start_background.svg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Center(
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: const Text(
                    "This accessment helps us understand your weaknesses and strengths so as to help you prep better.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Image.asset(
                  'images/analysis.png',
                  height: 239,
                  width: 239,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

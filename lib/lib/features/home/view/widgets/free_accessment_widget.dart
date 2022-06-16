
import 'package:ecoach/lib/core/utils/app_colors.dart';
import 'package:ecoach/lib/features/accessment/views/screens/choose_level.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FreeAccessmentWidget extends StatefulWidget {
  const FreeAccessmentWidget({Key? key}) : super(key: key);

  @override
  State<FreeAccessmentWidget> createState() => _FreeAccessmentWidgetState();
}

class _FreeAccessmentWidgetState extends State<FreeAccessmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.h),
      height: 150,
      decoration: BoxDecoration(
        color: kHomeAccessmentColor,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Free Accessment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'Take a free test today and get to know your strenghts and weaknesses.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                    fontSize: 9,
                  ),
                ),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () {
                    Get.to(() => const ChooseAccessmentLevel());
                  },
                  child: SizedBox(
                    height: 41,
                    width: 121,
                    child: Material(
                      color: const Color(0xFF00C9B9),
                      borderRadius: BorderRadius.circular(7),
                      child: const Center(
                        child: Text(
                          "Try it Now",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 1.h,
          ),
          Image.asset(
            'images/exam.png',
            height: 92,
            width: 92,
          ),
        ],
      ),
    );
  }
}

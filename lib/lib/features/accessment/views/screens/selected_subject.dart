import 'package:ecoach/lib/features/accessment/views/screens/start_accessment_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/utils/text_styles.dart';

List<String> subjects = [
  "Mathematics",
  "English",
  "Science",
  "ICT",
  "French",
];

class SelectSubjectWidget extends StatelessWidget {
  const SelectSubjectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 1.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: 20.w,
                child: const Divider(
                  thickness: 3,
                  color: Color(0xFF707070),
                ),
              ),
            ),
            const SizedBox(
              height: 51,
            ),
            const Text(
              "Lower Primary",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 29,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "Select Your Course",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(subjects.length, (index) {
              return InkWell(
                onTap: () {
                  Get.to(() => const StartAccessmentPage());
                },
                child: Container(
                  height: 58,
                  width: 354,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      subjects[index],
                      textAlign: TextAlign.center,
                      style: TextStyles.headline(context).copyWith(
                        color: const Color(0xFF8D8D8D),
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.h),
          topRight: Radius.circular(4.h),
        ),
      ),
    );
  }
}

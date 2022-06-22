import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/utils/text_styles.dart';

class GeneratedLink extends StatelessWidget {
  const GeneratedLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: 20.w,
              child: Divider(
                thickness: 0.5.h,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          const Text(
            "Payment Link",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
          const Text(
            "Payment link generated successfully below",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: () {},
            child: Container(
              height: 58,
              width: 285,
              decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: const Color(
                      0xFFBBCFD6,
                    ),
                  )),
              child: Center(
                child: Text(
                  "bit.ly/apdeoleo",
                  textAlign: TextAlign.center,
                  style: TextStyles.headline(context).copyWith(
                    color: const Color(0xFF868686),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: () {},
            child: Container(
              height: 58,
              width: 285,
              decoration: const BoxDecoration(
                color: Color(0xFF00C9B9),
              ),
              child: Center(
                child: Text(
                  "Copy Link",
                  textAlign: TextAlign.center,
                  style: TextStyles.headline(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 7.h),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.h),
          topRight: Radius.circular(4.h),
        ),
      ),
    );
  }
}

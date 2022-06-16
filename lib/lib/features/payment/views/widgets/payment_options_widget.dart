
import 'package:ecoach/lib/core/utils/text_styles.dart';
import 'package:ecoach/lib/features/payment/views/widgets/generated_link_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentOptionsWidget extends StatelessWidget {
  const PaymentOptionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 1.h),
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
            height: 52,
          ),
          const Text(
            "Which option do you prefer",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF606C7A),
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 33),
          Container(
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
                "Direct Pay",
                textAlign: TextAlign.center,
                style: TextStyles.headline(context).copyWith(
                  color: const Color(0xFF868686),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: () {
              Get.back();
              Get.bottomSheet(
                const GeneratedLink(),
              );
            },
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
                  "Generate Payment Link",
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
          const SizedBox(height: 82),
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


import 'dart:convert';

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/core/utils/text_styles.dart';
import 'package:ecoach/revamp/features/payment/views/widgets/generated_link_widget.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:ecoach/views/user_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentOptionsWidget extends StatefulWidget {
   PaymentOptionsWidget();
  @override
  State<PaymentOptionsWidget> createState() => _PaymentOptionsWidgetState();
}

class _PaymentOptionsWidgetState extends State<PaymentOptionsWidget> {


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

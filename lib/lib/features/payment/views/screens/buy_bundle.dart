import 'package:ecoach/lib/features/payment/views/widgets/payment_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_styles.dart';

class BuyBundlePage extends StatelessWidget {
  const BuyBundlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          Get.bottomSheet(const PaymentOptionsWidget());
        },
        child: Container(
          color: const Color(0xFF00C9B9),
          height: 56,
          child: const Center(
            child: Text(
              'Buy Bundle',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w, bottom: 4),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_back),
                  const Expanded(
                    child: Text(
                      "JHS 1 Bundle",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 29,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 27,
                    width: 27,
                    child: Stack(
                      children: [
                        Container(
                          width: 21,
                          height: 21,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(width: 2, color: Colors.black),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Rev Shaddy Consult",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "GHS 200",
              style: TextStyle(
                  color: Color(0xFF2A9CEA),
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            ),
            const Text(
              "validity: 365 days",
              style: TextStyle(fontSize: 11, color: Color(0xFF8E8E8E)),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                child: Container(
              height: 651,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        Text(
                          "A comprehensive collection from Rev Shaddy Consult for students in JHS 1",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E8E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xFFB8B8B8),
                    thickness: 2,
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 32, top: 27, right: 32, bottom: 20),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: Card(
                              elevation: 0,
                              child: ListTile(
                                title: const Text(
                                  "JHS 1 Bundle",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                subtitle: const Text(
                                  "Topic: 20 | Quizes: 20 | Questions: 2000",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 9),
                                ),
                                leading: Text(
                                  "0${index + 1}",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.25),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 29,
                                  ),
                                ),
                                trailing: Image.asset(
                                  "images/download.png",
                                  color:
                                      index == 0 ? Colors.green : Colors.grey,
                                  height: 27,
                                  width: 27,
                                ),
                              )),
                        );
                      })
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.w),
                  topRight: Radius.circular(5.w),
                ),
                color: const Color(0xFFF5F5F5),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

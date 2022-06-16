import 'package:ecoach/lib/core/utils/app_colors.dart';
import 'package:ecoach/lib/features/home/view/widgets/free_accessment_widget.dart';
import 'package:ecoach/lib/features/payment/views/screens/buy_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      body: ListView(
        padding: EdgeInsets.only(top: 6.h, bottom: 2.h, left: 2.h, right: 2.h),
        children: [
          const Text(
            'Hello,',
            style: TextStyle(fontSize: 12),
          ),
          const Text(
            'Vickyjay',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 37.5),
          const FreeAccessmentWidget(),
          const SizedBox(
            height: 37.5,
          ),
          const Text(
            'Available bundles',
            style: TextStyle(color: kSecondaryTextColor, fontSize: 15),
          ),
          const Divider(
            color: kSecondaryTextColor,
            thickness: 1,
            height: 0,
          ),
          const SizedBox(
            height: 20.5,
          ),
          ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.only(bottom: 2.h),
                child: ListTile(
                  onTap: () {
                    Get.to(() => const BuyBundlePage());
                  },
                  title: const Text(
                    "JHS 1 Bundle",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    "All subjects under JHS1",
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: const Text(
                    "GHS 200",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

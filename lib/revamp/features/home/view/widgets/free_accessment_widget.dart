
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/accessment/views/screens/choose_level.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FreeAccessmentWidget extends StatefulWidget {
  final User user;
   FreeAccessmentWidget(this.user) ;

  @override
  State<FreeAccessmentWidget> createState() => _FreeAccessmentWidgetState();
}

class _FreeAccessmentWidgetState extends State<FreeAccessmentWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(() =>  ChooseAccessmentLevel(widget.user));
      },
      child: Container(
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
                    'Free Assessment',
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
                      // SchedulerBinding.instance.addPostFrameCallback((_) {
                      //   showLoaderDialog(context, message: "Loading Diagnostic data ...");
                      //   ApiCall<Data>(AppUrl.new_user_data, isList: false,
                      //       create: (Map<String, dynamic> json) {
                      //         return Data.fromJson(json);
                      //       }, onCallback: (data) async{
                      //         if (data != null) {
                      //           await LevelDB().insertAll(data!.levels!);
                      //           await CourseDB().insertAll(data!.courses!);
                      //         }
                      //         Navigator.pop(context);
                      //         Get.to(() =>  ChooseAccessmentLevel(widget.user));
                      //         // Navigator.pop(context);
                      //       }, onError: (e) {
                      //         Navigator.pop(context);
                      //       }).get(context);
                      // });
                      Get.to(() =>  ChooseAccessmentLevel(widget.user));
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
              'assets/images/exam.png',
              height: 92,
              width: 92,
            ),
          ],
        ),
      ),
    );
  }
}

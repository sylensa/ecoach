import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_activities/activities/group_activity.dart';
import 'package:ecoach/views/user_group/group_activities/chat/chat.dart';
import 'package:ecoach/views/user_group/group_activities/performance/performance.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupActivity extends StatefulWidget {
  static const String routeName = '/user_group';
  GroupActivity( {Key? key}) : super(key: key);
  @override
  State<GroupActivity> createState() => _GroupActivityState();
}

class _GroupActivityState extends State<GroupActivity> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h, right: 2.h),
              decoration: BoxDecoration(
                color: Color(0XFFE2EFF3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4.h,),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        ),
                        SizedBox(width: 20,),
                        sText("Afram's SAT",weight: FontWeight.bold,size: 20),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        color: Color(0XFFF7B06E),
                      ),
                      SizedBox(width: 10,),
                      sText("20 days remaining",weight: FontWeight.w500,size: 12,color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 10,),
                  sText("Welcome, Victor",weight: FontWeight.w500,size: 20,color: Colors.black),

                ],
              ),
            ),
            AdeoTabControl(
              variant: 'square',
              tabs: [
                'Activity',
                'Performance',
                'Chat',
              ],
              tabPages: [
                Activity(),
                GroupPerformance(),
                GroupChatScreen()
              ],
            ),

          ],
        ),

      ),

    );
  }
}

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_activities/activities/group_activity.dart';
import 'package:ecoach/views/user_group/group_notification/group_announcement.dart';
import 'package:ecoach/views/user_group/group_notification/group_invite.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupNotificationActivity extends StatefulWidget {
  static const String routeName = '/user_group';
  GroupNotificationActivity(this.user, {Key? key}) : super(key: key);
  User user;
  @override
  State<GroupNotificationActivity> createState() => _GroupNotificationActivityState();
}

class _GroupNotificationActivityState extends State<GroupNotificationActivity> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0XFFDBF1A8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h, right: 2.h),
              decoration: BoxDecoration(
                color: Color(0XFFDBF1A8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4.h,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        ),
                        SizedBox(width: 20,),
                        sText("Notifications",weight: FontWeight.bold,size: 20),

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
                    ],
                  ),
                  SizedBox(height: 10,),
                  sText("Track all activities",weight: FontWeight.w500,size: 20,color: Colors.black),
                  SizedBox(height: 5,),
                  sText("Never miss deadlines",weight: FontWeight.w500,size: 20,color: Colors.black),

                ],
              ),
            ),

            Expanded(
              child: Container(
                width: appWidth(context),
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Expanded(
                     child: ListView(
                       padding: EdgeInsets.zero,
                       children: [
                         sText("Upcoming Activity",weight: FontWeight.bold),
                         SizedBox(height: 10,),
                         for(int i =0; i < 2; i++)
                           GestureDetector(
                             onTap: (){
                               goTo(context, GroupAnnouncement(widget.user));
                             },
                             child: Column(
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                   margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                   decoration: BoxDecoration(
                                       color: Color(0XFFE2EFF3),
                                       borderRadius: BorderRadius.circular(10)
                                   ),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Container(
                                         color: Colors.red,
                                         width: 5,
                                         height: 60,
                                       ),
                                       Container(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             sText("ANNOUNCEMENT",),
                                             SizedBox(height: 5,),
                                             Container(
                                               width: 150,
                                               child: sText("Prepare for your upcoming group test",weight: FontWeight.bold,size: 10),
                                             ),
                                             SizedBox(height: 10,),
                                             sText("RevShady SAT",weight: FontWeight.normal,size: 12),
                                           ],
                                         ),
                                       ),
                                       Container(
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             sText("03 : 59",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
                                             sText("remaining",weight: FontWeight.normal,size: 10),
                                           ],
                                         ),
                                       ),
                                       Container(
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             sText("10h",weight: FontWeight.normal),
                                             SizedBox(height: 20,),
                                             Icon(Icons.arrow_forward),
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         SizedBox(height: 10,),
                         Container(
                           color: Colors.white,
                           width: appWidth(context),
                           height: 2,
                         ),
                         SizedBox(height: 20,),
                         sText("All Activity",weight: FontWeight.bold),
                         SizedBox(height: 10,),
                         for(int i =0; i < 2; i++)
                           MaterialButton(
                             padding: EdgeInsets.zero,
                             onPressed: (){
                               goTo(context, GroupInvite(widget.user));
                             },
                             child: Column(
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                   margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(10)
                                   ),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Container(
                                         color: Colors.red,
                                         width: 5,
                                         height: 60,
                                       ),
                                       Container(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             sText("ANNOUNCEMENT",),
                                             SizedBox(height: 5,),
                                             Container(
                                               width: 150,
                                               child: sText("Prepare for your upcoming group test",weight: FontWeight.bold,size: 10),
                                             ),
                                             SizedBox(height: 10,),
                                             sText("RevShady SAT",weight: FontWeight.normal,size: 12),
                                           ],
                                         ),
                                       ),
                                       Container(
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             sText("03 : 59",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
                                             sText("remaining",weight: FontWeight.normal,size: 10),
                                           ],
                                         ),
                                       ),
                                       Container(
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             sText("10h",weight: FontWeight.normal),
                                             SizedBox(height: 20,),
                                             Icon(Icons.arrow_forward),
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           )
                       ],
                     ),
                   )
                  ],
                ),
              ),
            )


          ],
        ),

      ),

    );
  }
}

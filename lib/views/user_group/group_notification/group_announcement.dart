import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_notification_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_activities/activities/group_activity.dart';
import 'package:ecoach/views/user_group/group_activities/group_activity.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupAnnouncement extends StatefulWidget {
  static const String routeName = '/user_group';
  GroupAnnouncement(this.user, {Key? key,this.groupNotificationData}) : super(key: key);
  GroupNotificationData? groupNotificationData;
  User user;
  @override
  State<GroupAnnouncement> createState() => _GroupAnnouncementState();
}

class _GroupAnnouncementState extends State<GroupAnnouncement> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!widget.groupNotificationData!.viewed!){
      GroupManagementController(groupId: widget.groupNotificationData!.groupId.toString()).viewedNotification(notificationId: widget.groupNotificationData!.id);
    }
  }
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
                color: Color(0XFFF4E3E3),
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
                        sText("Announcement",weight: FontWeight.bold,size: 20),

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
                      sText("${StringExtension.displayTimeAgoFromTimestamp(widget.groupNotificationData!.notificationtable!.createdAt.toString())}",weight: FontWeight.w500,color: Colors.black),

                    ],
                  ),
                  SizedBox(height: 10,),
                  sText("Track all group activities",weight: FontWeight.w500,size: 20,color: Colors.black),
                  SizedBox(height: 5,),
                  sText("Never miss deadlines",weight: FontWeight.w500,size: 20,color: Colors.black),

                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                width: appWidth(context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        sText("Announcement",weight: FontWeight.bold,size: 16,align: TextAlign.left),
                        SizedBox(height: 20,),
                        sText("${widget.groupNotificationData!.message}"),
                      ],
                    ),
                   Image.asset("assets/images/announcement.png")
                  ],
                ),
              ),
            ),


          ],
        ),

      ),

    );
  }
}

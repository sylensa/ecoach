import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_notification_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_activities/activities/group_activity.dart';
import 'package:ecoach/views/user_group/group_notification/group_announcement.dart';
import 'package:ecoach/views/user_group/group_notification/group_invite.dart';
import 'package:ecoach/views/user_group/group_notification/group_request.dart';
import 'package:ecoach/views/user_group/group_notification/test_instruction.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get_utils/get_utils.dart';
// import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  List<GroupNotificationData> upComingGroupNotificationData = [];
  List<GroupNotificationData> allGroupNotificationData = [];
  bool progressCodeUpComing = true;
  bool progressCodeAll = true;
  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 3;

  getUpcomingActivity() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      upComingGroupNotificationData = await GroupManagementController().getUpcomingGroupNotifications();
    } else {
      showNoConnectionToast(context);
    }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
      progressCodeUpComing = false;
    });
  }
  getAllActivity() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      allGroupNotificationData = await GroupManagementController().getUpcomingAllGroupNotifications();
    } else {
      showNoConnectionToast(context);
    }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
      progressCodeAll = false;
    });
  }
  getTimerWidget(DateTime dateTime,{bool isStartTime = true}){
    // var lastConsoString3= Duration(hours:int.parse(duration.split(":").first),minutes: int.parse(duration.split(":").last),seconds: 0,);
    // var _lastConso = DateTime.now().subtract(lastConsoString3);
    // var diff = DateTime.now().difference(_lastConso);
    // print( diff.inSeconds);
    endTime = dateTime.millisecondsSinceEpoch + 1000 ;
    controller = CountdownTimerController(endTime: endTime, onEnd: _onEnd);


    return  CountdownTimer(
      controller: controller,
      onEnd: _onEnd,
      endTime: endTime,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return Text(isStartTime ? "Test in progress" : "Test Completed");
        }
        return Column(
          children: [
            Text('${time.days != null ? time.days : "00"}:${time.hours != null ? time.hours : "00"}:${time.min != null ? time.min : "00"} : ${time.sec}'),
            sText(isStartTime? "Time remaining to start" : "Time remaining to complete",weight: FontWeight.normal,size: 10),
          ],
        );
      },
    );
  }

  void _onEnd() {
    print('onEnd');
  }

  @override
  void initState(){
    getUpcomingActivity();
    getAllActivity();
    super.initState();
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

            progressCodeAll && progressCodeUpComing ?
                Expanded(
                    child: Container(
                      color: Colors.white,
                        child: Center(child: progress(),),
                    ),
                ) :
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
                         if(upComingGroupNotificationData.isNotEmpty)
                        Column(
                          children: [
                            for(int i =0; i < upComingGroupNotificationData.length; i++)
                              // if(!upComingGroupNotificationData[i].viewed!)
                              notificationType(upComingGroupNotificationData[i],i,true)

                          ],
                        )
                        else
                          Container(
                            height: 200,
                            child: Center(
                              child: sText("No upcoming activity"),
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
                        if(allGroupNotificationData.isNotEmpty)
                        Column(
                          children: [
                            for(int i =0; i < allGroupNotificationData.length; i++)
                              if(allGroupNotificationData[i].viewed!)
                              notificationType(allGroupNotificationData[i],i,false)

                          ],
                        )
                         else
                          Container(
                            height: 200,
                            child: Center(
                              child: sText("No activity"),
                            ),
                          ),
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

  notificationType(GroupNotificationData groupNotificationData,int index,bool isUpcoming ){
    switch(groupNotificationData.notificationtableType){
      case "group_test" :
      return  groupTest(groupNotificationData,index,isUpcoming);
      case "group_test_result" :
        return  groupTestResult(groupNotificationData,index,isUpcoming);
      case "group_announcement" :
      return  groupAnnouncement(groupNotificationData,index,isUpcoming);
      case "group_invitation" :
        return  groupInvitation(groupNotificationData,index,isUpcoming);
      case "group_invite" :
        return  groupInvitation(groupNotificationData,index,isUpcoming);
      case "group_request" :
        return  groupRequest(groupNotificationData,index,isUpcoming);
      default:
      return  groupTest(groupNotificationData,index,isUpcoming);


    }
  }

  // groupTest(GroupNotificationData groupNotificationData,int index,bool isUpcoming){
  //   int countDown = 0;
  //   if(groupNotificationData.notificationtable!.configurations!.timing! != "Untimed"){
  //
  //     if(groupNotificationData.notificationtable!.configurations!.startDatetime != null && groupNotificationData.notificationtable!.configurations!.dueDateTime != null){
  //       // period
  //       DateTime startTime = groupNotificationData.notificationtable!.configurations!.startDatetime!;
  //       DateTime endTime = groupNotificationData.notificationtable!.configurations!.dueDateTime!;
  //       countDown = endTime.difference(startTime).inSeconds;
  //     }else{
  //       // exact
  //       if(groupNotificationData.notificationtable!.configurations!.timing! == "Time per Question"){
  //         countDown = groupNotificationData.notificationtable!.configurations!.countDown! * 10;
  //       }else if(groupNotificationData.notificationtable!.configurations!.timing! == "Time per Quiz"){
  //         countDown = 60 * groupNotificationData.notificationtable!.configurations!.countDown!;
  //       }
  //       DateTime startTime =groupNotificationData.notificationtable!.configurations!.startDatetime!;
  //       countDown = countDown - DateTime.now().difference(startTime).inSeconds;
  //       groupNotificationData.notificationtable!.configurations!.dueDateTime  = groupNotificationData.notificationtable!.configurations!.startDatetime!.add(new Duration(seconds: countDown));
  //     }
  //   }else{
  //     DateTime startTime = groupNotificationData.notificationtable!.configurations!.startDatetime!;
  //     countDown = countDown - DateTime.now().difference(startTime).inSeconds;
  //     groupNotificationData.notificationtable!.configurations!.dueDateTime  = groupNotificationData.notificationtable!.configurations!.startDatetime!.add(new Duration(seconds: countDown));
  //   }
  //   return MaterialButton(
  //     padding: EdgeInsets.zero,
  //     onPressed: ()async{
  //       if(groupNotificationData.group != null){
  //         await goTo(context, TestInstruction(widget.user,groupNotificationData: groupNotificationData,));
  //         readNotification(isUpcoming,groupNotificationData,index);
  //       }else{
  //         toastMessage("Group deleted or suspended");
  //       }
  //
  //     },
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //           margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
  //           decoration: BoxDecoration(
  //               color: groupNotificationData.viewed! ? Colors.white :  Color(0XFFE2EFF3),
  //               borderRadius: BorderRadius.circular(10)
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                 color: Colors.red,
  //                 width: 5,
  //                 height: 60,
  //               ),
  //               Container(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     sText("GROUP TEST",),
  //                     SizedBox(height: 5,),
  //                     Container(
  //                       width: 150,
  //                       child: sText("${groupNotificationData.notificationtable!.name}",weight: FontWeight.bold,size: 10),
  //                     ),
  //                     SizedBox(height: 10,),
  //                    groupNotificationData.group != null ?
  //                       sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12) :
  //                    sText("Group deleted or suspended",weight: FontWeight.normal,size: 12)  ,
  //                   ],
  //                 ),
  //               ),
  //               if( groupNotificationData.group != null)
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   if(groupNotificationData.notificationtable!.configurations!.startDatetime!.compareTo(DateTime.now()) > 0)
  //                     Container(
  //                       // width: 100,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         crossAxisAlignment: CrossAxisAlignment.end,
  //                         children: [
  //                           // sText("${}",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
  //                           // allGroupNotificationData[i].notificationtable!.configurations!.dueDateTime! > DateTime.now() ?
  //                           getTimerWidget(groupNotificationData.notificationtable!.configurations!.startDatetime.toString().split(" ").last.split(".").first,isStartTime:true),
  //                           sText("remaining",weight: FontWeight.normal,size: 10),
  //                         ],
  //                       ),
  //                     )
  //                   else if(groupNotificationData.notificationtable!.configurations!.dueDateTime!.compareTo(DateTime.now()) > 0)
  //                     Container(
  //                       // width: 100,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         crossAxisAlignment: CrossAxisAlignment.end,
  //                         children: [
  //                           // sText("${}",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
  //                           // allGroupNotificationData[i].notificationtable!.configurations!.dueDateTime! > DateTime.now() ?
  //                           getTimerWidget(groupNotificationData.notificationtable!.configurations!.dueDateTime.toString().split(" ").last.split(".").first,isStartTime: false),
  //                           sText("Test ongoing",weight: FontWeight.normal,size: 10),
  //                         ],
  //                       ),
  //                     )
  //                   else
  //                     sText("Test Completed",weight: FontWeight.normal,size: 10),
  //                   Container(
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         sText("${StringExtension.displayTimeAgoFromTimestamp(groupNotificationData.notificationtable!.configurations!.startDatetime.toString())}",weight: FontWeight.normal),
  //                         SizedBox(height: 20,),
  //                         Icon(Icons.arrow_forward),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //
  // }


  groupTest(GroupNotificationData groupNotificationData,int index,bool isUpcoming){
    int countDown = 0;
    if(groupNotificationData.notificationtable!.configurations!.timing! != "Untimed"){

      if(groupNotificationData.notificationtable!.configurations!.startDatetime != null && groupNotificationData.notificationtable!.configurations!.dueDateTime != null){
        // period
        DateTime startTime = groupNotificationData.notificationtable!.configurations!.startDatetime!;
        DateTime endTime = groupNotificationData.notificationtable!.configurations!.dueDateTime!;
        countDown = endTime.difference(DateTime.now()).inSeconds;
      }else{
        // exact
        if(groupNotificationData.notificationtable!.configurations!.timing! == "Time per Question"){
          countDown = groupNotificationData.notificationtable!.configurations!.countDown! * 10;
        }else if(groupNotificationData.notificationtable!.configurations!.timing! == "Time per Quiz"){
          countDown = 60 * groupNotificationData.notificationtable!.configurations!.countDown!;
        }
        DateTime startTime = groupNotificationData.notificationtable!.configurations!.startDatetime!;
        // countDown = countDown - DateTime.now().difference(startTime).inSeconds;
        groupNotificationData.notificationtable!.configurations!.dueDateTime  = groupNotificationData.notificationtable!.configurations!.startDatetime!.add(new Duration(seconds: countDown));
      }
    }
    else{
      DateTime startTime = groupNotificationData.notificationtable!.configurations!.startDatetime!;
      DateTime endTime = groupNotificationData.notificationtable!.configurations!.dueDateTime!;
      countDown = endTime.difference(DateTime.now()).inSeconds;
    }

    print("startTime:${groupNotificationData.notificationtable!.configurations!.startDatetime}");
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: ()async{
        if(groupNotificationData.group != null){
          await goTo(context, TestInstruction(widget.user,groupNotificationData: groupNotificationData,));
          readNotification(isUpcoming,groupNotificationData,index);
        }else{
          toastMessage("Group deleted or suspended");
        }

      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(
                color: groupNotificationData.viewed! ? Colors.white :  Color(0XFFE2EFF3),
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
                      sText("GROUP TEST",),
                      SizedBox(height: 5,),
                      Container(
                        width: 150,
                        child: sText("${groupNotificationData.notificationtable!.name}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      groupNotificationData.group != null ?
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12) :
                      sText("Group deleted or suspended",weight: FontWeight.normal,size: 12)  ,
                    ],
                  ),
                ),
                if( groupNotificationData.group != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(groupNotificationData.notificationtable!.configurations!.startDatetime!.compareTo(DateTime.now()) > 0)
                        Container(
                          // width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // sText("${}",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
                              // allGroupNotificationData[i].notificationtable!.configurations!.dueDateTime! > DateTime.now() ?
                              getTimerWidget(groupNotificationData.notificationtable!.configurations!.startDatetime!,isStartTime:true),
                            ],
                          ),
                        )
                      else if(groupNotificationData.notificationtable!.configurations!.dueDateTime!.compareTo(DateTime.now()) > 0)
                        Container(
                          // width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // sText("${}",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
                              // allGroupNotificationData[i].notificationtable!.configurations!.dueDateTime! > DateTime.now() ?
                              getTimerWidget(groupNotificationData.notificationtable!.configurations!.dueDateTime!,isStartTime: false),
                              sText("Test ongoing",weight: FontWeight.normal,size: 10),
                            ],
                          ),
                        )
                      else
                        sText("Test Completed",weight: FontWeight.normal,size: 10),

                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );

  }
  groupTestResult(GroupNotificationData groupNotificationData,int index,bool isUpcoming){
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: ()async{
        // await goTo(context, GroupInvite(widget.user,groupNotificationData.id.toString()));
        if(groupNotificationData.group != null){
          readNotification(isUpcoming,groupNotificationData,index);
        }else{
          toastMessage("Group deleted or suspended");
        }

      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
            decoration: BoxDecoration(
                color: groupNotificationData.viewed! ? Colors.white :  Color(0XFFE2EFF3),
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
                SizedBox(width: 5,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("GROUP TEST",),
                      SizedBox(height: 5,),
                      Container(
                        width: appWidth(context) * 0.60,
                        child: sText("${groupNotificationData.notificationtable!.name}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      groupNotificationData.group != null ?
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12) :
                      sText("Group deleted or suspended",weight: FontWeight.normal,size: 12) ,
                    ],
                  ),
                ),
                  if(groupNotificationData.group != null)
                  Container(
                    // width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        getTimerWidget(groupNotificationData.notificationtable!.configurations!.startDatetime!,isStartTime:true),
                        sText("40 out of 50",weight: FontWeight.normal,size: 10),
                      ],
                    ),
                  ),
                if(groupNotificationData.group != null)
                  Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      sText("${StringExtension.displayTimeAgoFromTimestamp(groupNotificationData.notificationtable!.configurations!.startDatetime.toString())}",weight: FontWeight.normal),
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
    );
  }

  groupAnnouncement(GroupNotificationData groupNotificationData,int index,bool isUpcoming){
    return  MaterialButton(
      padding: EdgeInsets.zero,

      onPressed: ()async{
        if(groupNotificationData.group != null){
          await  goTo(context, GroupAnnouncement(widget.user,groupNotificationData: groupNotificationData,));
          readNotification(isUpcoming,groupNotificationData,index);
        }else{
          toastMessage("Group deleted or suspended");
        }

      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
            decoration: BoxDecoration(
                color:  groupNotificationData.viewed! ? Colors.white :  Color(0XFFE2EFF3),
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
                SizedBox(width: 5,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("ANNOUNCEMENT",),
                      SizedBox(height: 5,),
                      Container(
                        width: appWidth(context) * 0.60,
                        child: sText("${groupNotificationData.message}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      groupNotificationData.group != null ?
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12) :
                      sText("Group deleted or suspended",weight: FontWeight.normal,size: 12) ,
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      sText("${StringExtension.displayTimeAgoFromTimestamp(groupNotificationData.notificationtable!.createdAt.toString())}",weight: FontWeight.normal),
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
    )    ;
  }

  groupInvitation(GroupNotificationData groupNotificationData,int index,bool isUpcoming){
    return  MaterialButton(
      padding: EdgeInsets.zero,

      onPressed: ()async{
        if(groupNotificationData.group != null){
          await  goTo(context, GroupInvite(widget.user,groupNotificationData: groupNotificationData,));
          readNotification(isUpcoming,groupNotificationData,index);
        }else{
          toastMessage("Group deleted or suspended");
        }

        setState(() {
          print("allGroupNotificationData:${allGroupNotificationData.length}");
        });

      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
            decoration: BoxDecoration(
                color: groupNotificationData.viewed! ? Colors.white :  Color(0XFFE2EFF3),
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
                SizedBox(width: 5,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("INVITATION",),
                      SizedBox(height: 5,),
                      Container(
                        width: appWidth(context) * 0.60,
                        child: sText("${groupNotificationData.message}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      groupNotificationData.group != null ?
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12) :
                      sText("Group deleted or suspended",weight: FontWeight.normal,size: 12)
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      sText("${StringExtension.displayTimeAgoFromTimestamp(groupNotificationData.group != null ? groupNotificationData.group!.dateCreated.toString() : groupNotificationData.createdAt!.toString())}",weight: FontWeight.normal),
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
    )    ;
  }
  groupRequest(GroupNotificationData groupNotificationData,int index,bool isUpcoming){
    return  MaterialButton(
      padding: EdgeInsets.zero,

      onPressed: ()async{
        if(groupNotificationData.group != null){
          await goTo(context, GroupRequest(widget.user,groupNotificationData: groupNotificationData,));
          readNotification(isUpcoming,groupNotificationData,index);
        }else{
          toastMessage("Group deleted or suspended");
        }

      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
            decoration: BoxDecoration(
                color: groupNotificationData.viewed! ? Colors.white :  Color(0XFFE2EFF3),
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
                SizedBox(width: 5,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("GROUP REQUEST",),
                      SizedBox(height: 5,),
                      Container(
                        width: appWidth(context) * 0.60,
                        child: sText("${groupNotificationData.message}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      groupNotificationData.group != null ?
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12) :
                      sText("Group deleted or suspended",weight: FontWeight.normal,size: 12)
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      sText("${StringExtension.displayTimeAgoFromTimestamp(groupNotificationData.createdAt.toString())}",weight: FontWeight.normal),
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
    )    ;
  }

  readNotification(bool isUpcoming,GroupNotificationData groupNotificationData,int index){
    setState((){
      if(isUpcoming){
        List<GroupNotificationData> listGroupNotificationData = [];
        groupNotificationData.viewed = true;
        listGroupNotificationData.add(groupNotificationData);
        allGroupNotificationData.insertAll(0,listGroupNotificationData);
        upComingGroupNotificationData.removeAt(index);
      }else{
        allGroupNotificationData[index].viewed = true;
        print("object2");
      }
      groupNotificationData = allGroupNotificationData[index];

    });
  }
}

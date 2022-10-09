import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_notification_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/user_group/group_activities/no_activity.dart';
import 'package:ecoach/views/user_group/group_notification/group_announcement.dart';
import 'package:ecoach/views/user_group/group_notification/group_invite.dart';
import 'package:ecoach/views/user_group/group_notification/group_request.dart';
import 'package:ecoach/views/user_group/group_notification/test_instruction.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Activity extends StatefulWidget {
  GroupListData? groupData;
  Activity(this.user, {Key? key,this.groupData,}) : super(key: key);
  User user;
  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  List<GroupNotificationData> upComingGroupNotificationData = [];
  List<GroupNotificationData> allGroupNotificationData = [];
  bool progressCodeUpComing = true;
  bool progressCodeAll = true;
  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 3;

  getAllActivity() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      allGroupNotificationData = await GroupManagementController(groupId: widget.groupData!.id.toString()).getGroupNotifications();

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

  getTimerWidget(String duration,{bool isStartTime = true}){
    var lastConsoString3= Duration(hours:int.parse(duration.split(":").first),minutes: int.parse(duration.split(":").last),seconds: 0,);
    var _lastConso = DateTime.now().subtract(lastConsoString3);
    var diff = DateTime.now().difference(_lastConso);
    print( diff.inSeconds);
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 *  diff.inSeconds;
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
    getAllActivity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: [
          progressCodeAll ?
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(child: progress(),),
            ),
          ) :
          allGroupNotificationData.isNotEmpty ?
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
                itemCount: allGroupNotificationData.length,
                itemBuilder: (BuildContext context, int index){
                  return   notificationType(allGroupNotificationData[index],index,);
                }),
          ) :
          Expanded(
            child: Container(
              height: 200,
              child: Center(
                child: sText("No activity"),
              ),
            ),
          ),



        ],
      ),

    );
  }




  notificationType(GroupNotificationData groupNotificationData,int index){
    switch(groupNotificationData.notificationtableType){
      case "group_test" :
        return  groupTest(groupNotificationData,index);
      case "group_test_result" :
        return  groupTestResult(groupNotificationData,index);
      case "group_announcement" :
        return  groupAnnouncement(groupNotificationData,index);
      case "group_invitation" :
        return  groupInvitation(groupNotificationData,index);
      case "group_invite" :
        return  groupInvitation(groupNotificationData,index);
      case "group_request" :
        return  groupRequest(groupNotificationData,index);
      default:
        return  groupTest(groupNotificationData,index);


    }
  }

  groupTest(GroupNotificationData groupNotificationData,int index){
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: ()async{
        await goTo(context, TestInstruction(widget.user,groupNotificationData: groupNotificationData,));
        setState((){
            allGroupNotificationData[index].viewed = true;
            groupNotificationData = allGroupNotificationData[index];
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
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12),
                    ],
                  ),
                ),
                if(groupNotificationData.notificationtable!.configurations!.startDatetime!.compareTo(DateTime.now()) > 0)
                  Container(
                    // width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // sText("${}",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
                        // allGroupNotificationData[i].notificationtable!.configurations!.dueDateTime! > DateTime.now() ?
                        getTimerWidget(groupNotificationData.notificationtable!.configurations!.startDatetime.toString().split(" ").last.split(".").first,isStartTime:true),
                        sText("remaining",weight: FontWeight.normal,size: 10),
                      ],
                    ),
                  ) else if(groupNotificationData.notificationtable!.configurations!.dueDateTime!.compareTo(DateTime.now()) > 0)
                  Container(
                    // width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // sText("${}",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
                        // allGroupNotificationData[i].notificationtable!.configurations!.dueDateTime! > DateTime.now() ?
                        getTimerWidget(groupNotificationData.notificationtable!.configurations!.dueDateTime.toString().split(" ").last.split(".").first,isStartTime: false),
                        sText("Test ongoing",weight: FontWeight.normal,size: 10),
                      ],
                    ),
                  ) else
                  sText("Test Completed",weight: FontWeight.normal,size: 10),
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

  groupTestResult(GroupNotificationData groupNotificationData,int index){
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: ()async{
        // await goTo(context, GroupInvite(widget.user,groupNotificationData.id.toString()));
        setState((){
          allGroupNotificationData[index].viewed = true;
          groupNotificationData = allGroupNotificationData[index];

        });
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
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12),
                    ],
                  ),
                ),
                Container(
                  // width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      getTimerWidget(groupNotificationData.notificationtable!.configurations!.startDatetime.toString().split(" ").last.split(".").first,isStartTime:true),
                      sText("40 out of 50",weight: FontWeight.normal,size: 10),
                    ],
                  ),
                ),
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

  groupAnnouncement(GroupNotificationData groupNotificationData,int index){
    return  MaterialButton(
      padding: EdgeInsets.zero,

      onPressed: ()async{
        await  goTo(context, GroupAnnouncement(widget.user,groupNotificationData: groupNotificationData,));
        setState((){
          allGroupNotificationData[index].viewed = true;
          groupNotificationData = allGroupNotificationData[index];
        });
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
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("ANNOUNCEMENT",),
                      SizedBox(height: 5,),
                      Container(
                        width: 250,
                        child: sText("${groupNotificationData.message}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12),
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

  groupInvitation(GroupNotificationData groupNotificationData,int index,){
    return  MaterialButton(
      padding: EdgeInsets.zero,

      onPressed: ()async{
        await  goTo(context, GroupInvite(widget.user,groupNotificationData: groupNotificationData,));
        setState((){
          allGroupNotificationData[index].viewed = true;
          groupNotificationData = allGroupNotificationData[index];

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
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("INVITATION",),
                      SizedBox(height: 5,),
                      Container(
                        width: 250,
                        child: sText("${groupNotificationData.message}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12),
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      sText("${StringExtension.displayTimeAgoFromTimestamp(groupNotificationData.group!.dateCreated.toString())}",weight: FontWeight.normal),
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
  groupRequest(GroupNotificationData groupNotificationData,int index,){
    return  MaterialButton(
      padding: EdgeInsets.zero,

      onPressed: ()async{
        await goTo(context, GroupRequest(widget.user,groupNotificationData: groupNotificationData,));
        setState((){
          allGroupNotificationData[index].viewed = true;
          groupNotificationData = allGroupNotificationData[index];

        });
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
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("GROUP REQUEST",),
                      SizedBox(height: 5,),
                      Container(
                        width: 250,
                        child: sText("${groupNotificationData.message}",weight: FontWeight.bold,size: 10),
                      ),
                      SizedBox(height: 10,),
                      sText("${groupNotificationData.group!.name}",weight: FontWeight.normal,size: 12),
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
}

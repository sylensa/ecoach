import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_notification_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/user_group/group_activities/activities/group_activity.dart';
import 'package:ecoach/views/user_group/group_activities/group_activity.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GroupRequest extends StatefulWidget {
  static const String routeName = '/user_group';
  GroupRequest(this.user, {Key? key,this.groupNotificationData}) : super(key: key);
  User user;
  GroupNotificationData? groupNotificationData;
  @override
  State<GroupRequest> createState() => _GroupRequestState();
}

class _GroupRequestState extends State<GroupRequest> {
  TextEditingController searchController = TextEditingController();
  late String generatedLink = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  showAcceptDialog({String? message, BuildContext? context,String type = "Accept"}) {
    // flutter defined function
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: sText("Alert", color: Colors.black, weight: FontWeight.bold),
          content: sText(message!),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                margin: rightPadding(10),
                child: sText("Cancel", color: Colors.white),
                decoration: BoxDecoration(
                    color: kAccessmentButtonColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                showLoaderDialog(context);
                if(type == "Accept"){
                  await acceptGroupInvite();
                }else{
                  await rejectGroupInvite();
                }

              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                margin: rightPadding(10),
                child: sText("Yes", color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        );
      },
    );
  }

  acceptGroupInvite() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      print("object:${widget.user.id}");

      var res = await GroupManagementController(groupId: widget.groupNotificationData!.groupId.toString()).groupRequestAccept(widget.groupNotificationData!.userId.toString());
      Navigator.pop(context);
      showDialogOk(context: context,message: errorMessage);
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
    });
  }
  rejectGroupInvite() async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      print("object:${widget.user.id}");
      var res = await GroupManagementController(groupId: widget.groupNotificationData!.groupId.toString()).groupRequestAccept(widget.groupNotificationData!.userId.toString());
      Navigator.pop(context);
      showDialogOk(context: context,message: errorMessage);
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Color(0XFFFDE4CE),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h, right: 2.h),
              decoration: BoxDecoration(
                // color: Color(0XFFF4E3E3),
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
                        sText("GroupInvite",weight: FontWeight.bold,size: 20),

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
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          sText("Track all activities",weight: FontWeight.w500,size: 20,color: Colors.black),
                          SizedBox(height: 5,),
                          sText("Never miss deadlines",weight: FontWeight.w500,size: 20,color: Colors.black),
                        ],
                      ),
                      Expanded(child: Container()),
                      Image.asset("assets/images/send-mail.png")

                    ],
                  )
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
                        Row(
                          children: [
                            sText("${widget.groupNotificationData!.group!.name}",weight: FontWeight.w500,size: 20),
                            SizedBox(width: 5,),
                            sText("by ${widget.groupNotificationData!.group!.owner!.name}",weight: FontWeight.w500,size: 12,color: Colors.grey),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Image.asset("assets/images/user_group.png"),
                                  ),
                                  SizedBox(width: 5,),
                                  Container(
                                    child: sText("${widget.groupNotificationData!.group!.membersCount}",size: 12,weight: FontWeight.bold,),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(Icons.star,color: Colors.orange,size: 20,),
                                  ),
                                  SizedBox(width: 0,),
                                  Container(
                                    child: sText("${widget.groupNotificationData!.group!.rating}",size: 10,weight: FontWeight.bold,),
                                  ),
                                  SizedBox(width: 5,),
                                  Container(
                                    child: sText("(${widget.groupNotificationData!.group!.reviews} reviews)",size: 10,weight: FontWeight.normal,),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                      child: Image.asset("assets/images/label.png")
                                  ),
                                  SizedBox(width: 5,),
                                  Container(
                                    child: sText(widget.groupNotificationData!.group!.settings != null ? widget.groupNotificationData!.group!.settings!.access!.toLowerCase() != "free" ?"${widget.groupNotificationData!.group!.settings!.currency}${widget.groupNotificationData!.group!.settings!.amount}" : "Free" : "Free",size: 12,weight: FontWeight.bold,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        sText("${widget.groupNotificationData!.message}",lHeight: 2),

                      ],
                    ),
                    Column(
                      children: [

                        SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              showAcceptDialog(context: context,message: "Are you sure you want to accept?",type: "Accept");
                            },
                            child: Container(
                              width: appWidth(context),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Center(child: sText("Accept",color: Colors.white,weight: FontWeight.w500)),
                            ),
                          ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            showAcceptDialog(context: context,message: "Are you sure you want to decline?",type: "Decline");
                          },
                          child: Container(
                            width: appWidth(context),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.orange)
                            ),
                            child: Center(child: sText("Decline",color: Colors.orange,weight: FontWeight.w500)),
                          ),
                        )
                      ],
                    ),

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

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/announcement_list_model.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_page_view_model.dart';
import 'package:ecoach/models/group_test_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/commission/commission_agent_page.dart';
import 'package:ecoach/views/group_management/group_list.dart';
import 'package:ecoach/views/group_management/test_creation/edit_test_configuration.dart';
import 'package:ecoach/views/group_management/test_creation/settings.dart';
import 'package:ecoach/views/group_management/test_creation/test_creation.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GroupPage extends StatefulWidget {
  GroupListData? groupListData;
  GroupPage({this.groupListData});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  List<ListNames> listMembers = [
    ListNames(name: "Victor Adatsi", id: "1"),
    ListNames(name: "Samuel Quaye", id: "2"),
    ListNames(name: "Peter Ocansey", id: "1"),
  ];
  List<GroupViewData> listGroupViewData = [];
  bool progressCode = true;
  bool progressCodeAnnouncement = true;
  int _currentSlide = 0;
  List<File> listFiles = [];
  List<AnnouncementData> listAnnouncementData = [];

  List base64Images = [];
  List<T> map<T>(int listLength, Function handler) {
    List list = [];
    for (var i = 0; i < listLength; i++) {
      list.add(i);
    }
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
  String orderBy = "asc";
  String sortBy = "popularity";
  List<ListNames> sortList = [ListNames(name: "",id: ""),ListNames(name: "Rank",id: "rank"),ListNames(name: "Speed",id: "speed"),ListNames(name: "Strength",id: "strength"),ListNames(name: "Passed",id: "passed")];
  String dropdownValue = 'Courses';
  showRevokeDialog({String? message, BuildContext? context, Widget? target, bool replace = false, String? userId}) {
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
                child: sText("No", color: Colors.white),
                decoration: BoxDecoration(
                    color: kAccessmentButtonColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                showLoaderDialog(context);
                await revokeGroupInvite(userId!);
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

  memberActionsModalBottomSheet(context, String userId, bool isMember,bool suspended) {
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: sText("Member Actions",
                                weight: FontWeight.bold,
                                size: 20,
                                align: TextAlign.center)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Perform an action",
                            color: kAdeoGray3,
                            weight: FontWeight.w400,
                            align: TextAlign.center),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              showLoaderDialog(context);
                              removeMember(userId);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: sText("Remove member",
                                  color: kAdeoGray3, align: TextAlign.center),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              showLoaderDialog(context);
                              if(suspended){
                                unSuspendMember(userId);
                              }else{
                                suspendMember(userId);
                              }

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: sText(suspended ? "Un suspend member" : "Suspend member",
                                  color: kAdeoGray3, align: TextAlign.center),
                            ),
                          ),

                          if(!suspended)
                          isMember
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showLoaderDialog(context);
                                    makeUserAdmin(userId);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: sText("Make member an admin",
                                        color: kAdeoGray3,
                                        align: TextAlign.center),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showLoaderDialog(context);
                                    makeAdminParticipant(userId);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: sText("Make Admin a Participant",
                                        color: kAdeoGray3,
                                        align: TextAlign.center),
                                  ),
                                ),
                        ],
                      )),
                    ],
                  ));
            },
          );
        });
  }

  inviteToGroup(String email) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      try{
        if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).inviteToGroup(email)){
          await getGroupPageView();
          Navigator.pop(context);
          toastMessage("User invite sent successfully");
        }else{
          Navigator.pop(context);
          toastMessage("User invite failed");
        }
      }catch(e){
        Navigator.pop(context);
        print("error:$e");
        toastMessage("User invite failed");

      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }

  }

  inviteModalBottomSheet(context,){
    TextEditingController emailController = TextEditingController();
    String confirmText = "Swipe to Confirm";
    bool isActivated = true;
    double sheetHeight = 300;
    confirmFunc(){
      setState((){
        confirmText = "Confirmed";
      });
      print("$confirmText");
    }
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        color: kAdeoGray,
                        height: 5,
                        width: 50,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: sText( "Enter user's email to invite them to the group",weight: FontWeight.normal,align: TextAlign.center)),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 40,),
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20,right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please check that you\'ve entered email';
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (value){
                                            stateSetter((){
                                              sheetHeight = 300;
                                            });
                                          },
                                          onTap: (){
                                            stateSetter((){
                                              sheetHeight = 650;
                                            });
                                          },
                                          textAlign: TextAlign.left,
                                          style: appStyle(weight: FontWeight.w400,size: 20),
                                          decoration: textDecorNoBorder(
                                            hintWeight: FontWeight.normal,
                                            radius: 10,
                                            labelText: "Email",
                                            hintColor: Colors.black,
                                            borderColor: Colors.grey[400]!,
                                            fill: Colors.white,
                                            padding: EdgeInsets.only(left: 10,right: 40),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 30,
                                  top: 7,
                                  child: Container(
                                    margin: topPadding(5),
                                    child: Icon(Icons.check,color: Colors.white,),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00C9B9),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 40,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ConfirmationSlider(
                                onConfirmation:(){
                                  stateSetter((){
                                    confirmText = "Confirmed";
                                    if(emailController.text.isNotEmpty){
                                      Navigator.pop(context);
                                      showLoaderDialog(context);
                                      inviteToGroup(emailController.text);
                                    }else{
                                      toastMessage("Enter user email");
                                    }
                                    // goTo(context, GroupProfilePage(groupListData:widget.groupListData));
                                  });
                                } ,
                                backgroundColor: Color(0xFFE8F5FF),
                                text: "$confirmText",
                                textStyle: appStyle(col: Color(0xFF023F6E)),
                                shadow: BoxShadow(color: Colors.white,),
                                iconColor: Color(0xFF0367B4),
                                sliderButtonContent: Icon(Icons.keyboard_double_arrow_right,color: Color(0xFF69AAEA),),
                                stickToEnd: false,
                                foregroundColor: Color(0xFF0367B4),
                                backgroundColorEnd:   Color(0xFFE8F5FF),


                              ),
                            ),


                          ],
                        ),
                      ),

                    ],
                  )
              );
            },

          );
        }
    );
  }

  popUpMenu({BuildContext? context}) {
    return PopupMenuButton(
      onSelected: (result) async {
        if (result == "report") {}
      },
      padding: bottomPadding(0),
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Icon(Icons.more_vert, color: Colors.black),
      ),
      // add this line
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Container(
            // height: 30,
            child: sText("Group Actions", size: 18),
          ),
          value: 'report',
          onTap: () {},
        ),
      ],
    );
  }

  groupActionsModalBottomSheet(context,) {
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: sText("Group Actions",
                                weight: FontWeight.bold,
                                size: 20,
                                align: TextAlign.center)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Perform an action",
                            color: kAdeoGray3,
                            weight: FontWeight.w400,
                            align: TextAlign.center),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView(
                        children: [
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              Navigator.pop(context);
                              showLoaderDialog(context);
                              await deleteGroup();

                              },
                            child: Container(
                              width: appWidth(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: sText("Delete Group",
                                  color: kAdeoGray3, align: TextAlign.center),
                            ),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              Navigator.pop(context);
                              showLoaderDialog(context);
                              if (widget.groupListData!.status!.toLowerCase() ==
                                  "suspended") {
                                await unSuspendGroup();
                              } else {
                                await suspendGroup();
                              }
                            },
                            child: Container(
                              width: appWidth(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: sText(
                                  widget.groupListData!.status!.toLowerCase() ==
                                          "suspended"
                                      ? "Unsuspend Group"
                                      : "Suspend Group",
                                  color: kAdeoGray3,
                                  align: TextAlign.center),
                            ),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: ()async{
                              Navigator.pop(context);
                              inviteModalBottomSheet(context);
                            },
                            child: Container(
                              width: appWidth(context),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration:BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: sText("Invite User",color: kAdeoGray3,align: TextAlign.center),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ));
            },
          );
        });
  }
  incomingActionsModalBottomSheet(context,int userId) {
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: sText("Incoming Actions",
                                weight: FontWeight.bold,
                                size: 20,
                                align: TextAlign.center)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Perform an action",
                            color: kAdeoGray3,
                            weight: FontWeight.w400,
                            align: TextAlign.center),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView(
                        children: [
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              Navigator.pop(context);
                              showLoaderDialog(context);
                              await acceptGroupInvite(userId);
                              },
                            child: Container(
                              width: appWidth(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: sText("Accept Invite",
                                  color: kAdeoGray3, align: TextAlign.center),
                            ),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              Navigator.pop(context);
                              showLoaderDialog(context);
                              await rejectGroupInvite(userId);

                            },
                            child: Container(
                              width: appWidth(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: sText("Reject Invite",
                                  color: kAdeoGray3,
                                  align: TextAlign.center),
                            ),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: ()async{
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: appWidth(context),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration:BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: sText("Cancel",color: kAdeoGray3,align: TextAlign.center),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ));
            },
          );
        });
  }

  getGroupPageView() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      listGroupViewData.clear();
      try {
        listGroupViewData = await GroupManagementController(groupId: widget.groupListData!.id.toString()).getGroupPageView();
        setState(() {
          progressCode = false;
        });
      } catch (e) {
        Navigator.pop(context);
        setState(() {
          progressCode = false;
        });
        toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }

    setState(() {
      progressCode = false;
    });
  }

  makeUserAdmin(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .makeUserAdmin(userId)) {
        await getGroupPageView();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  makeAdminParticipant(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .makeUserParticipant(userId)) {
        await getGroupPageView();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  suspendGroup() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .groupSuspend()) {
        setState(() {
          widget.groupListData!.status = "SUSPENDED";
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  unSuspendGroup() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .groupUnSuspend()) {
        setState(() {
          widget.groupListData!.status = "ACTIVE";
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  suspendMember(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .suspendUser(userId)) {
        await getGroupPageView();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  unSuspendMember(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .unSuspendUser(userId)) {
        await getGroupPageView();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  removeMember(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .removeUser(userId)) {
        await getGroupPageView();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  revokeGroupInvite(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .groupInviteRevoke(userId)) {
        await getGroupPageView();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  announcementModalBottomSheet(context,) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 600;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                    height: sheetHeight,
                    decoration: BoxDecoration(
                        color: kAdeoGray,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey,
                          height: 5,
                          width: 100,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                              child: sText("Announcement",
                                  weight: FontWeight.bold,
                                  size: 20,
                                  align: TextAlign.center)),
                        ),
                        // SizedBox(height: 10,),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 20),
                        //   child: sText("Select Your Preferred Upgrade",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        // autofocus: true,
                                        controller: titleController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please check that you\'ve entered group_management email';
                                          }
                                          return null;
                                        },
                                        decoration: textDecorNoBorder(
                                          radius: 10,
                                          labelText: "Title",
                                          hintColor: Color(0xFFB9B9B9),
                                          borderColor: Colors.white,
                                          fill: Colors.white,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        // autofocus: true,
                                        controller: descriptionController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please check that you\'ve entered your group description';
                                          }
                                          return null;
                                        },
                                        maxLines: 10,
                                        decoration: textDecorNoBorder(
                                          radius: 10,
                                          labelText: "Description",
                                          hintColor: Color(0xFFB9B9B9),
                                          borderColor: Colors.white,
                                          fill: Colors.white,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _previewImage(stateSetter)
                              // MaterialButton(
                              //   onPressed: (){
                              //     attachDoc();
                              //   },
                              //   child: Container(
                              //     child: Image.asset("assets/images/upload_images.png")
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            showLoaderDialog(context);
                            createAnnouncement(
                                title: titleController.text,
                                description: descriptionController.text);
                          },
                          child: Container(
                            width: appWidth(context),
                            color: Color(0xFF00C9B9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: sText("Send Announcement",
                                color: Colors.white,
                                weight: FontWeight.w500,
                                align: TextAlign.center,
                                size: 18),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }

  updateAnnouncementModalBottomSheet(context, AnnouncementData announcementData, int index) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    titleController.text = announcementData.title!;
    descriptionController.text = announcementData.description!;
    List images = [];
    for (int i = 0; i < announcementData.resources!.length; i++) {
      images.add(announcementData.resources![i].url);
    }
    bool isActivated = true;
    double sheetHeight = 600;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                    height: sheetHeight,
                    decoration: BoxDecoration(
                        color: kAdeoGray,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Container(
                              color: Colors.grey,
                              height: 5,
                              width: 100,
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                showLoaderDialog(context);
                                deleteAnnouncement(
                                    announcementData.id.toString(), index);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 15),
                                margin: rightPadding(10),
                                child: sText("Delete", color: Colors.white),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                              child: sText("Announcement",
                                  weight: FontWeight.bold,
                                  size: 20,
                                  align: TextAlign.center)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        // autofocus: true,
                                        controller: titleController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please check that you\'ve entered group email';
                                          }
                                          return null;
                                        },
                                        decoration: textDecorNoBorder(
                                          radius: 10,
                                          labelText: "Title",
                                          hintColor: Color(0xFFB9B9B9),
                                          borderColor: Colors.white,
                                          fill: Colors.white,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        // autofocus: true,
                                        controller: descriptionController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please check that you\'ve entered your group description';
                                          }
                                          return null;
                                        },
                                        maxLines: 10,
                                        decoration: textDecorNoBorder(
                                          radius: 10,
                                          labelText: "Description",
                                          hintColor: Color(0xFFB9B9B9),
                                          borderColor: Colors.white,
                                          fill: Colors.white,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              listFiles.isNotEmpty
                                  ? _previewImage(stateSetter)
                                  : announcementData.resources!.isNotEmpty
                                      ? _previewImageUpdate(stateSetter, images)
                                      : _previewImage(stateSetter)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            showLoaderDialog(context);
                            updateAnnouncement(
                                title: titleController.text,
                                description: descriptionController.text,aId: announcementData.id.toString(),index: index);
                          },
                          child: Container(
                            width: appWidth(context),
                            color: Color(0xFF00C9B9),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: sText("Update Announcement",
                                color: Colors.white,
                                weight: FontWeight.w500,
                                align: TextAlign.center,
                                size: 18),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }

  createAnnouncement({String title = '', String description = ''}) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      if (isConnected) {
        AnnouncementData? announcementData = await GroupManagementController(
                groupId: widget.groupListData!.id.toString())
            .createAnnouncement(base64Images,
                title: title, description: description);
        if (announcementData != null) {
          base64Images.clear();
          listFiles.clear();
          Navigator.pop(context);
          listAnnouncementData.add(announcementData);
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        showNoConnectionToast(context);
      }
    } catch (e) {
      Navigator.pop(context);
      print("error:${e.toString()}");
    }
    setState(() {});
  }

  getAnnouncement() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      if (isConnected) {
        listAnnouncementData = await GroupManagementController(
                groupId: widget.groupListData!.id.toString())
            .getAnnouncement();
        if (listAnnouncementData.isNotEmpty) {
        } else {}
      } else {
        showNoConnectionToast(context);
      }
    } catch (e) {
      print(e.toString());
    }

    // setState(() {
    //   progressCodeAnnouncement = false;
    // });
  }

  updateAnnouncement({String title = '', String description = '', int index = 0, String aId = ''}) async {
    try {
      final bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        AnnouncementData? announcementData = await GroupManagementController(
                groupId: widget.groupListData!.id.toString())
            .updateAnnouncement(base64Images,title: title, description: description, id: aId);
        if (announcementData != null) {
          listAnnouncementData.removeAt(index);
          listAnnouncementData.insert(index, announcementData);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        showNoConnectionToast(context);
      }
    } catch (e) {
      Navigator.pop(context);
      print(e.toString());
    }
    setState(() {});
  }

  deleteAnnouncement(String aId, int index) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(
              groupId: widget.groupListData!.id.toString())
          .deleteAnnouncement(aId)) {
        setState(() {
          listAnnouncementData.removeAt(index);
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  attachDoc() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image, withData: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      // List<PlatformFile> listFiles = result.files;
      print(files.first.path);
      if (files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          listFiles.add(files[i]);
        }
      }
      if (listFiles.isNotEmpty) {
        for (int i = 0; i < listFiles.length; i++) {
          base64Images.add(base64Encode(listFiles.first.readAsBytesSync()));
        }
      }

      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  Widget _previewImage(StateSetter stateSetter) {
    if (listFiles.isNotEmpty) {
      return GestureDetector(
        onTap: () async {
          await attachDoc();

          stateSetter(() {});
          print(listFiles);
        },
        child: Center(
          child: Container(
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
                scrollDirection: Axis.horizontal,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: listFiles.map<Widget>((_imageFiles) {
                  return Stack(
                    children: [
                      Semantics(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: displayLocalImage(_imageFiles.path,
                                  radius: 10,
                                  height: 100,
                                  width: appWidth(context))),
                          label: 'image_picker_example_picked_image'),
                      Positioned(
                          left: 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () async {
                                listFiles.remove(_imageFiles);
                                stateSetter(() {});
                              }))
                    ],
                  );
                }).toList()),
          ),
        ),
      );
    } else {
      return MaterialButton(
        onPressed: () async {
          await attachDoc();
          stateSetter(() {});
        },
        child: Container(child: Image.asset("assets/images/upload_images.png")),
      );
    }
  }

  Widget _previewImageUpdate(StateSetter stateSetter, List url) {
    if (url.isNotEmpty) {
      return GestureDetector(
        onTap: () async {
          await attachDoc();

          stateSetter(() {});
          print(listFiles);
        },
        child: Center(
          child: Container(
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
                scrollDirection: Axis.horizontal,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: url.map<Widget>((_imageFiles) {
                  return Stack(
                    children: [
                      Semantics(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: displayImage(_imageFiles,
                                  radius: 0,
                                  height: 100,
                                  width: appWidth(context))),
                          label: 'image_picker_example_picked_image'),
                      Positioned(
                          left: 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () async {
                                url.remove(_imageFiles);
                                stateSetter(() {});
                              }))
                    ],
                  );
                }).toList()),
          ),
        ),
      );
    } else {
      return MaterialButton(
        onPressed: () async {
          await attachDoc();
          stateSetter(() {});
        },
        child: Container(child: Image.asset("assets/images/upload_images.png")),
      );
    }
  }

  getGroupTest() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      if (isConnected) {
        listGroupTestData = await GroupManagementController(groupId: widget.groupListData!.id.toString()).getGroupTest();
      } else {
        showNoConnectionToast(context);
      }
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      progressCodeAnnouncement = false;
    });

    print("listGroupTestData:$listGroupTestData");
  }

  deleteGroup() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (await GroupManagementController(groupId: widget.groupListData!.id.toString()).groupDelete()) {
        listGroupListData.remove(widget.groupListData);
        Navigator.pop(context);
        Navigator.pop(context,);
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  acceptGroupInvite(int userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      var res = await GroupManagementController(groupId: widget.groupListData!.id.toString()).groupRequestAccept(userId.toString());
      await getGroupPageView();
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
  rejectGroupInvite(int userId) async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      var res = await GroupManagementController(groupId:  widget.groupListData!.id.toString()).groupRequestAccept(userId.toString());
      await getGroupPageView();
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

  buildDropDownButton() {
    return DropdownButton<String>(
      dropdownColor: Colors.white,

      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.grey,
      ),

      isExpanded: true,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(
        color: Colors.black,
      ),
      underline: Container(
        height: 1,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          print(dropdownValue);
        });
      },
      items: <String>[
        'Courses',
        'Participants',
        'Tests',
        'Topics',
        'Questions',
      ].map<DropdownMenuItem<String>>(
            (String value) {
          return DropdownMenuItem<String>(
            value: value,

            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),

          );
        },
      ).toList(),
    );
  }


  @override
  void initState() {
    getGroupPageView();
    getAnnouncement();
    getGroupTest();
    listGroupTestData.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context,widget.groupListData);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0XFF2D3E50),
            )),
        title: Text(
          widget.groupListData!.name!,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0XFF2D3E50),
              height: 1.1,
              fontFamily: "Poppins"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                groupActionsModalBottomSheet(context);
              },
              icon: Icon(Icons.more_vert, color: Colors.black))
        ],
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText(widget.groupListData!.uid!,
                  color: Color(0xFF2A9CEA),
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                  size: 25),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          listGroupViewData.isNotEmpty
              ? Expanded(
                  child: ListView(
                    children: [
                      // admin
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Admins",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[
                               listGroupViewData[0].admins!.isNotEmpty ?
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      children: [
                                        for (int i = 0; i < listGroupViewData[0].admins!.length; i++)
                                          if(listGroupViewData[0].admins![i].isGroupCreator!)
                                            MaterialButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                // memberActionsModalBottomSheet(context, listGroupViewData[0].admins![i].id.toString(), false);
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          displayLocalImage(
                                                              "filePath",
                                                              radius: 30),
                                                          Positioned(
                                                            bottom: 5,
                                                            right: 0,
                                                            child: Image.asset(
                                                                "assets/images/tick-mark.png"),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          sText(
                                                              listGroupViewData[0]
                                                                  .admins![i]
                                                                  .name,
                                                              color: Colors.black,
                                                              weight: FontWeight
                                                                  .w500),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          sText("Owner/Admin",
                                                              color: kAdeoGray3,
                                                              size: 12),
                                                        ],
                                                      ),
                                                      Expanded(
                                                          child: Container()),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: kAdeoGray3,
                                                        size: 16,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            )
                                          else
                                            MaterialButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                memberActionsModalBottomSheet(
                                                    context,
                                                    listGroupViewData[0]
                                                        .admins![i]
                                                        .id
                                                        .toString(),
                                                    false,false);
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          displayLocalImage(
                                                              "filePath",
                                                              radius: 30),
                                                          Positioned(
                                                            bottom: 5,
                                                            right: 0,
                                                            child: Image.asset(
                                                                "assets/images/tick-mark.png"),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          sText(
                                                              listGroupViewData[0]
                                                                  .admins![i]
                                                                  .name,
                                                              color: Colors.black,
                                                              weight: FontWeight
                                                                  .w500),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          sText("Admin",
                                                              color: kAdeoGray3,
                                                              size: 12),
                                                        ],
                                                      ),
                                                      Expanded(
                                                          child: Container()),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: kAdeoGray3,
                                                        size: 16,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            )

                                      ],
                                    ),
                                  ) : 
                               Center(
                                 child: sText("You've no admin"),
                               ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //members
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Members",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[
                                listGroupViewData[0].members!.isNotEmpty ?
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            for (int i = 0;i < listGroupViewData[0].members!.length; i++)
                                              if(listGroupViewData[0].members![i].isGroupCreator!)
                                              MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  // memberActionsModalBottomSheet(context, listGroupViewData[0].members![i].id.toString(), listGroupViewData[0].members![i].isGroupCreator!);
                                                },
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            displayLocalImage(
                                                                "filePath",
                                                                radius: 30),
                                                            Positioned(
                                                              bottom: 5,
                                                              right: 0,
                                                              child: Image.asset(
                                                                  "assets/images/tick-mark.png"),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            sText(
                                                                listGroupViewData[
                                                                        0]
                                                                    .members![i]
                                                                    .name,
                                                                color: Colors
                                                                    .black,
                                                                weight:
                                                                    FontWeight
                                                                        .w500),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            sText(
                                                                "Owner",
                                                                color:
                                                                    kAdeoGray3,
                                                                size: 12),
                                                          ],
                                                        ),
                                                        Expanded(
                                                            child: Container()),

                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: kAdeoGray3,
                                                          size: 16,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    listGroupViewData[0]
                                                                    .members!
                                                                    .length -
                                                                1 !=
                                                            i
                                                        ? Column(
                                                            children: [
                                                              Divider(
                                                                color:
                                                                    kAdeoGray,
                                                                height: 1,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              )
                                               else
                                                MaterialButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    memberActionsModalBottomSheet(
                                                        context,
                                                        listGroupViewData[0]
                                                            .members![i]
                                                            .id
                                                            .toString(),
                                                        true,false);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              displayLocalImage(
                                                                  "filePath",
                                                                  radius: 30),
                                                              Positioned(
                                                                bottom: 5,
                                                                right: 0,
                                                                child: Image.asset(
                                                                    "assets/images/tick-mark.png"),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              sText(
                                                                  listGroupViewData[
                                                                  0]
                                                                      .members![i]
                                                                      .name,
                                                                  color: Colors
                                                                      .black,
                                                                  weight:
                                                                  FontWeight
                                                                      .w500),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              sText(
                                                                  "${listGroupViewData[0].members![i].testCount} Tests",
                                                                  color:
                                                                  kAdeoGray3,
                                                                  size: 12),
                                                            ],
                                                          ),
                                                          Expanded(
                                                              child: Container()),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              sText(
                                                                  "${listGroupViewData[0].members![i].testPercent}",
                                                                  color: Colors
                                                                      .black,
                                                                  weight:
                                                                  FontWeight
                                                                      .w500),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              sText(
                                                                  "${listGroupViewData[0].members![i].testGrade == null ? "No Grade" : listGroupViewData[0].members![i].testGrade}",
                                                                  color:
                                                                  kAdeoGray3,
                                                                  size: 12),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: kAdeoGray3,
                                                            size: 16,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      listGroupViewData[0]
                                                          .members!
                                                          .length -
                                                          1 !=
                                                          i
                                                          ? Column(
                                                        children: [
                                                          Divider(
                                                            color:
                                                            kAdeoGray,
                                                            height: 1,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      )
                                                          : Container(),
                                                    ],
                                                  ),
                                                )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ) :  Center(
                                  child: sText("You've no members"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // pending
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Pending Invites",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[
                                listGroupViewData[0].pendingInvites!.isNotEmpty ?
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              listGroupViewData[0]
                                                  .pendingInvites!
                                                  .length;
                                          i++)
                                        MaterialButton(
                                          onPressed: () {
                                            showRevokeDialog(
                                                context: context,
                                                message:
                                                    "Are you sure you want to revoke this invite",
                                                userId: listGroupViewData[0]
                                                    .pendingInvites![i]
                                                    .id
                                                    .toString());
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      sText(
                                                          listGroupViewData[0].pendingInvites![i].email,
                                                          color: Colors.black,
                                                          weight:
                                                              FontWeight.w500),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      sText("${StringExtension.displayTimeAgoFromTimestamp(listGroupViewData[0].pendingInvites![i].createdAt.toString())} ago", color: kAdeoGray3,size: 12),


                                                    ],
                                                  ),
                                                  Expanded(child: Container()),
                                                  Icon(
                                                    Icons.horizontal_rule,
                                                    color: Colors.red,
                                                    size: 25,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              listGroupViewData[0].pendingInvites!.length - 1 != i
                                                  ? Column(
                                                      children: [
                                                        Divider(
                                                          color: kAdeoGray,
                                                          height: 1,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ) :
                                Center(
                                  child: sText("You've no pending invite"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Incoming Invites
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Incoming Invites",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[
                                listGroupViewData[0].incomingInvites!.isNotEmpty ?
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                      i <
                                          listGroupViewData[0]
                                              .incomingInvites!
                                              .length;
                                      i++)
                                        MaterialButton(
                                          onPressed: () {
                                            incomingActionsModalBottomSheet(context, listGroupViewData[0].incomingInvites![i].id!);
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      sText(
                                                          listGroupViewData[0].incomingInvites![i].email,
                                                          color: Colors.black,
                                                          weight:
                                                          FontWeight.w500),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      sText("${StringExtension.displayTimeAgoFromTimestamp(listGroupViewData[0].incomingInvites![i].createdAt.toString())} ago", color: kAdeoGray3,size: 12),


                                                    ],
                                                  ),
                                                  Expanded(child: Container()),
                                                  Icon(
                                                    Icons.horizontal_rule,
                                                    color: Colors.red,
                                                    size: 25,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              listGroupViewData[0].incomingInvites!.length - 1 != i
                                                  ? Column(
                                                children: [
                                                  Divider(
                                                    color: kAdeoGray,
                                                    height: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ) :
                                Center(
                                  child: sText("You've no incoming invite"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // suspended
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Suspended Members",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[
                                listGroupViewData[0].suspendedUser!.isNotEmpty ?
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin:
                                  EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          for (int i = 0;i < listGroupViewData[0].suspendedUser!.length; i++)

                                              MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  memberActionsModalBottomSheet(
                                                      context,
                                                      listGroupViewData[0]
                                                          .suspendedUser![i]
                                                          .id
                                                          .toString(),
                                                      false,true);
                                                },
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            displayLocalImage(
                                                                "filePath",
                                                                radius: 30),
                                                            Positioned(
                                                              bottom: 5,
                                                              right: 0,
                                                              child: Image.asset(
                                                                  "assets/images/tick-mark.png"),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            sText(
                                                                listGroupViewData[
                                                                0]
                                                                    .suspendedUser![i]
                                                                    .name,
                                                                color: Colors
                                                                    .black,
                                                                weight:
                                                                FontWeight
                                                                    .w500),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            sText(
                                                                "${listGroupViewData[0].suspendedUser![i].testCount} Tests",
                                                                color:
                                                                kAdeoGray3,
                                                                size: 12),
                                                          ],
                                                        ),
                                                        Expanded(
                                                            child: Container()),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            sText(
                                                                "${listGroupViewData[0].suspendedUser![i].testPercent}",
                                                                color: Colors
                                                                    .black,
                                                                weight:
                                                                FontWeight
                                                                    .w500),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            sText(
                                                                "${listGroupViewData[0].suspendedUser![i].testGrade == null ? "No Grade" : listGroupViewData[0].suspendedUser![i].testGrade}",
                                                                color:
                                                                kAdeoGray3,
                                                                size: 12),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: kAdeoGray3,
                                                          size: 16,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    listGroupViewData[0]
                                                        .suspendedUser!
                                                        .length -
                                                        1 !=
                                                        i
                                                        ? Column(
                                                      children: [
                                                        Divider(
                                                          color:
                                                          kAdeoGray,
                                                          height: 1,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )
                                                        : Container(),
                                                  ],
                                                ),
                                              )
                                        ],
                                      ),
                                    ],
                                  ),
                                ) :  Center(
                                  child: sText("You've no suspended members"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //announcement
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Announcements",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    announcementModalBottomSheet(context);
                                  },
                                  child:  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    width: appWidth(context),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF0F7FF),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: DottedBorder(
                                      color: const Color(0xFF489CFF),
                                      strokeWidth: 1.2,
                                      dashPattern: const [8, 4],
                                      strokeCap: StrokeCap.round,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(6.0),
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                      child: Center(
                                        child: sText(
                                          "New Announcement",
                                          weight: FontWeight.w500,
                                          align: TextAlign.center,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                listAnnouncementData.isNotEmpty
                                    ? Column(
                                        children: [
                                          for (int i = 0;
                                              i < listAnnouncementData.length;
                                              i++)
                                            MaterialButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                listFiles.clear();
                                                updateAnnouncementModalBottomSheet(
                                                    context,
                                                    listAnnouncementData[i],
                                                    i);
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            sText(
                                                                listAnnouncementData[
                                                                        i]
                                                                    .user!
                                                                    .name,
                                                                color: Colors
                                                                    .black,
                                                                weight:
                                                                    FontWeight
                                                                        .bold),
                                                            sText(
                                                                " (${listAnnouncementData[i].user!.role})",
                                                                color:
                                                                    kAdeoGray2),
                                                            Expanded(
                                                                child:
                                                                    Container()),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color: kAdeoGray3,
                                                              size: 16,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        sText(
                                                            "${StringExtension.displayTimeAgoFromTimestamp(listAnnouncementData[i].createdAt.toString())} ago",
                                                            color: kAdeoGray2),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          child: sText(
                                                              listAnnouncementData[
                                                                      i]
                                                                  .title,
                                                              color: kAdeoGray3,
                                                              weight: FontWeight
                                                                  .w500),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        if (listAnnouncementData[
                                                                i]
                                                            .resources!
                                                            .isNotEmpty)
                                                          Column(
                                                            children: [
                                                              CarouselSlider.builder(
                                                                      options:
                                                                          CarouselOptions(
                                                                        height:
                                                                            200,
                                                                        autoPlay:
                                                                            false,
                                                                        enableInfiniteScroll:
                                                                            false,
                                                                        autoPlayAnimationDuration:
                                                                            Duration(seconds: 1),
                                                                        enlargeCenterPage:
                                                                            false,
                                                                        viewportFraction:
                                                                            1,
                                                                        aspectRatio:
                                                                            2.0,
                                                                        pageSnapping:
                                                                            true,
                                                                        onPageChanged:
                                                                            (index,
                                                                                reason) {
                                                                          setState(
                                                                              () {
                                                                            _currentSlide =
                                                                                index;
                                                                          });
                                                                        },
                                                                      ),
                                                                      itemCount: listAnnouncementData[
                                                                              i]
                                                                          .resources!
                                                                          .length,
                                                                      itemBuilder: (BuildContext
                                                                              context,
                                                                          int index,
                                                                          int index2) {
                                                                        return ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                displayImage(
                                                                              listAnnouncementData[i].resources![index].url,
                                                                              radius: 0,
                                                                              height: 200,
                                                                              width: appWidth(context),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                              // SizedBox(height: 10,),
                                                              // Padding(
                                                              //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                                              //   child: Row(
                                                              //     mainAxisAlignment: MainAxisAlignment.center,
                                                              //     children: map<Widget>(listAnnouncementData[i].resources!.length, (index, url) {
                                                              //       return Container(
                                                              //         width: 25,
                                                              //         height: 3,
                                                              //         margin: EdgeInsets.only(right: 5),
                                                              //         decoration: BoxDecoration(color: _currentSlide == index ?  Color(0xFF2A9CEA) : sGray),
                                                              //       );
                                                              //     }),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  listAnnouncementData.length -
                                                              1 !=
                                                          i
                                                      ? SizedBox(
                                                          height: 10,
                                                          child: Container(
                                                            color:
                                                                kHomeBackgroundColor,
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                        ],
                                      )
                                    : Center(
                                        child: sText("You've no announcement"),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // test
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Tests",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async{
                                    if(listActivePackageData[0].maxTests == listGroupTestData.length){
                                      toastMessage("You've reach your maximum number of test for this package");
                                    }else{
                                      groupID = widget.groupListData!.id.toString();
                                      await goTo(context, TestCreation(groupListData: widget.groupListData!,));
                                      setState((){});
                                    }

                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    width: appWidth(context),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF0F7FF),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: DottedBorder(
                                      color: const Color(0xFF489CFF),
                                      strokeWidth: 1.2,
                                      dashPattern: const [8, 4],

                                      strokeCap: StrokeCap.round,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(6.0),
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                      child: Center(
                                        child: sText(
                                          "New Test",
                                          weight: FontWeight.w500,
                                          align: TextAlign.center,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                listGroupTestData.isNotEmpty ?

                                  Column(
                                    children: [
                                      for (int i = 0;
                                      i < listGroupTestData.length;
                                      i++)
                                      Column(
                                        children: [

                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            margin:
                                                EdgeInsets.symmetric(horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: ExpansionTile(
                                              iconColor: Color(0xFFB5B5B5),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text: "${listGroupTestData[i].user!.name}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Poppins',
                                                        color: Color(0xFF000000),
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: " (${listGroupTestData[i].user!.role})",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color(0xFF5A6775),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  sText(
                                                    "${StringExtension.displayTimeAgoFromTimestamp(listGroupTestData[i].createdAt.toString())} ago",
                                                    size: 12,
                                                    color: Color(0xFF5A6775),
                                                  ),
                                                ],
                                              ),
                                              children: [
                                                MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: ()async{
                                                 var res =  await  goTo(context, EditTestConfigurations(groupTestData: listGroupTestData[i],index: i,));
                                                 print("res:$res");
                                                  setState((){
                                                    if(res != null){
                                                      listGroupTestData[i] = res;
                                                    }
                                                  });
                                                },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                      vertical: 20,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF8F8F8)
                                                          .withOpacity(1),
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Color(0xFF489CFF),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: 10,),
                                                        ListTile(
                                                          title: sText(
                                                            "Test Name",
                                                            size: 14.0,
                                                            color: Color(0xFF5A6775),
                                                          ),
                                                          subtitle: sText(
                                                            "${listGroupTestData[i].name}",
                                                            weight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: sText(
                                                            "Test Source",
                                                            size: 14.0,
                                                            color: Color(0xFF5A6775),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              sText(
                                                                "${listGroupTestData[i].configurations!.testSource}",
                                                                weight:
                                                                    FontWeight.w600,
                                                              ),
                                                              sText(
                                                                "${listGroupTestData[i].configurations!.bundle} - ${listGroupTestData[i].configurations!.course}",
                                                                style:
                                                                    FontStyle.italic,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: sText(
                                                            "Timing",
                                                            size: 14.0,
                                                            color: Color(0xFF5A6775),
                                                          ),
                                                          subtitle: sText(
                                                            "${listGroupTestData[i].configurations!.timing}",
                                                            weight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: sText(
                                                            "Test Period",
                                                            size: 14.0,
                                                            color: Color(0xFF5A6775),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              sText(
                                                                "Exact Time",
                                                                weight:
                                                                    FontWeight.w600,
                                                              ),
                                                              sText(
                                                                  "${listGroupTestData[i].configurations!.startDatetime}",
                                                                  style: FontStyle
                                                                      .italic),
                                                            ],
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: sText(
                                                            "Status",
                                                            size: 14.0,
                                                            color: Color(0xFF5A6775),
                                                          ),
                                                          subtitle: sText(
                                                            "${listGroupTestData[i].status}",
                                                            weight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,)
                                        ],
                                      ),
                                    ],
                                  ) : Center(child:sText("No test")),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // notes
                      // Column(
                      //   children: [
                      //     Theme(
                      //       data: Theme.of(context)
                      //           .copyWith(dividerColor: Colors.transparent),
                      //       child: ExpansionTile(
                      //         textColor: Colors.white,
                      //         iconColor: Colors.white,
                      //         initiallyExpanded: false,
                      //         maintainState: false,
                      //         backgroundColor: kHomeBackgroundColor,
                      //         childrenPadding: EdgeInsets.zero,
                      //         collapsedIconColor: Colors.white,
                      //         leading: Container(
                      //           child: sText("Notes",
                      //               weight: FontWeight.w500, size: 16),
                      //         ),
                      //         trailing: Container(
                      //           child: Icon(
                      //             Icons.add_circle_outline,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //         title: Container(),
                      //         children: <Widget>[
                      //           GestureDetector(
                      //             onTap: () {
                      //               goTo(context, TestCreation());
                      //             },
                      //             child: Container(
                      //               width: appWidth(context) * 0.75,
                      //               child: sText("New Note",
                      //                   weight: FontWeight.w500,
                      //                   size: 16,
                      //                   align: TextAlign.center),
                      //               padding: EdgeInsets.symmetric(
                      //                   vertical: 15, horizontal: 30),
                      //               decoration: BoxDecoration(
                      //                   color: Color(0XFFF0F7FF),
                      //                   border: Border.all(
                      //                       color: Color(0XFF489CFF)),
                      //                   borderRadius:
                      //                       BorderRadius.circular(10)),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 20,
                      //           ),
                      //           if (listGroupViewData[0].admins!.isNotEmpty)
                      //             Container(
                      //               padding: EdgeInsets.symmetric(
                      //                   horizontal: 20, vertical: 10),
                      //               margin:
                      //                   EdgeInsets.symmetric(horizontal: 20),
                      //               decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   borderRadius: BorderRadius.circular(5)),
                      //               child: Column(
                      //                 children: [
                      //                   for (int i = 0;
                      //                       i <
                      //                           listGroupViewData[0]
                      //                               .admins!
                      //                               .length;
                      //                       i++)
                      //                     Column(
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Stack(
                      //                               children: [
                      //                                 displayLocalImage(
                      //                                     "filePath",
                      //                                     radius: 30),
                      //                                 Positioned(
                      //                                   bottom: 5,
                      //                                   right: 0,
                      //                                   child: Image.asset(
                      //                                       "assets/images/tick-mark.png"),
                      //                                 )
                      //                               ],
                      //                             ),
                      //                             SizedBox(
                      //                               width: 10,
                      //                             ),
                      //                             Column(
                      //                               crossAxisAlignment:
                      //                                   CrossAxisAlignment
                      //                                       .start,
                      //                               children: [
                      //                                 sText(
                      //                                     listGroupViewData[0]
                      //                                         .admins![i]
                      //                                         .name,
                      //                                     color: Colors.black,
                      //                                     weight:
                      //                                         FontWeight.w500),
                      //                                 SizedBox(
                      //                                   height: 5,
                      //                                 ),
                      //                                 sText("Admin",
                      //                                     color: kAdeoGray3,
                      //                                     size: 12),
                      //                               ],
                      //                             ),
                      //                             Expanded(child: Container()),
                      //                             Icon(
                      //                               Icons.arrow_forward_ios,
                      //                               color: kAdeoGray3,
                      //                               size: 16,
                      //                             )
                      //                           ],
                      //                         ),
                      //                         SizedBox(
                      //                           height: 10,
                      //                         )
                      //                       ],
                      //                     ),
                      //                 ],
                      //               ),
                      //             ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // stats
                      //stats
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              initiallyExpanded: false,
                              maintainState: false,
                              backgroundColor: kHomeBackgroundColor,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.white,
                              leading: Container(
                                child: sText("Stats",
                                    weight: FontWeight.w500, size: 16),
                              ),
                              trailing: Container(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              title: Container(),
                              children: <Widget>[

                               Column(
                                   children: [
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 10),
                                       margin: EdgeInsets.symmetric(horizontal: 10),
                                       child:buildDropDownButton(),
                                     ),
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 0),
                                       height: 50,
                                       child: ListView.builder(
                                           padding: EdgeInsets.symmetric(horizontal: 20),
                                           itemCount: sortList.length,
                                           shrinkWrap: true,
                                           scrollDirection: Axis.horizontal,
                                           itemBuilder: (BuildContext context, int index){
                                             if(index == 0){
                                               return GestureDetector(
                                                 onTap: ()async{
                                                   setState((){
                                                     if(orderBy == "asc"){
                                                       orderBy = "desc";
                                                     }else{
                                                       orderBy = "asc";
                                                     }

                                                   });
                                                 },
                                                 child: Row(
                                                   children: [
                                                     Container(
                                                       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                                       decoration: BoxDecoration(
                                                           color:  orderBy == "desc" ? Color(0XFF2D3E50) : Colors.white,
                                                           borderRadius: BorderRadius.circular(20),
                                                           border: Border.all(color: Colors.white)
                                                       ),
                                                       child: Image.asset("assets/images/up-and-down-arrow.png",color: orderBy == "desc" ? Colors.white : Colors.grey,),

                                                     ),
                                                     SizedBox(width: 10,),
                                                   ],
                                                 ),
                                               );
                                             }
                                             return MaterialButton(
                                               padding: EdgeInsets.zero,
                                               onPressed: ()async{
                                                 setState((){
                                                   sortBy = sortList[index].id;
                                                 });
                                               },
                                               child: Row(
                                                 children: [
                                                   Container(
                                                     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                     decoration: BoxDecoration(
                                                         color: sortBy == sortList[index].id ? Color(0XFF2D3E50)  : Colors.white,
                                                         borderRadius: BorderRadius.circular(20),
                                                         border: Border.all(color: Colors.black)
                                                     ),
                                                     child: sText("${sortList[index].name}",size: 14,weight: FontWeight.normal,align: TextAlign.center,color: sortBy == sortList[index].id ? Colors.white : Color(0XFF2D3E50)),

                                                   ),
                                                   SizedBox(width: 5,),
                                                 ],
                                               ),
                                             );
                                           }),
                                     ),
                                     dropdownValue == "Courses" ?
                                     Column(
                                         children: [
                                           CarouselSlider.builder(
                                               options:
                                               CarouselOptions(
                                                 height:
                                                 400,
                                                 autoPlay:
                                                 false,
                                                 enableInfiniteScroll:
                                                 false,
                                                 autoPlayAnimationDuration:
                                                 Duration(seconds: 1),
                                                 enlargeCenterPage:
                                                 false,
                                                 viewportFraction:
                                                 1,
                                                 aspectRatio:
                                                 2.0,
                                                 pageSnapping:
                                                 true,
                                                 onPageChanged: (index, reason) {
                                                   setState(
                                                           () {
                                                         _currentSlide =
                                                             index;
                                                       });
                                                 },
                                               ),
                                               itemCount:5,
                                               itemBuilder: (BuildContextcontext, int index, int index2) {
                                                 return  Container(
                                                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                                   child: Column(
                                                     children: [
                                                       Container(
                                                         padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                         margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                                         decoration: BoxDecoration(
                                                             color: Color(0XFFDBF1A8),
                                                             borderRadius: BorderRadius.circular(10)
                                                         ),
                                                         child: Column(
                                                           children: [
                                                             Row(
                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                               children: [
                                                                 Row(
                                                                   children: [
                                                                     Icon(Icons.play_arrow),
                                                                     sText("Physics",weight: FontWeight.bold),
                                                                   ],
                                                                 ),
                                                                 Column(
                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: [
                                                                     Container(
                                                                       height: 40,
                                                                       width: 40,
                                                                       child: Center(child: sText("09",weight: FontWeight.bold)),
                                                                       decoration: BoxDecoration(
                                                                           color: Colors.white,
                                                                           shape: BoxShape.rectangle,
                                                                           borderRadius: BorderRadius.circular(10)
                                                                       ),
                                                                     ),
                                                                     SizedBox(height: 5,),
                                                                     sText("Passed",size: 10,weight: FontWeight.bold),
                                                                   ],
                                                                 )
                                                               ],
                                                             ),
                                                             SizedBox(height: 10,),
                                                             LinearProgressIndicator(
                                                               color: Colors.red,
                                                               value: 0.5,
                                                               backgroundColor: Colors.grey,

                                                             ),
                                                             SizedBox(height: 10,),
                                                             Row(
                                                               children: [
                                                                 Image.asset(
                                                                   "assets/images/trophy.png",
                                                                 ),
                                                                 SizedBox(width: 5,),
                                                                 sText("2nd",weight: FontWeight.bold,color: Colors.grey),
                                                                 Expanded(child: Container()),
                                                                 Icon(Icons.arrow_forward,color: Colors.grey,)
                                                               ],
                                                             ),
                                                             SizedBox(height: 20,),
                                                             Container(
                                                               decoration: BoxDecoration(
                                                                   color: Color(0XFFFAFAFA),
                                                                   borderRadius: BorderRadius.circular(15)
                                                               ),
                                                               padding: bottomPadding(15),
                                                               child: Column(
                                                                 children: [
                                                                   Container(
                                                                     child: Row(
                                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                       children: [
                                                                         Center(
                                                                           child: Container(
                                                                             // padding: EdgeInsets.only(top: 10,bottom: 10,left:10),

                                                                             child: Column(
                                                                               children: [
                                                                                 sText("Test ",color: Colors.grey,align: TextAlign.center),
                                                                                 SizedBox(height: 10,),
                                                                                 sText("9",weight: FontWeight.bold,size: 25),
                                                                               ],
                                                                             ),
                                                                           ),
                                                                         ),
                                                                         Container(
                                                                           height: 100,
                                                                           width: 2,
                                                                           color: Colors.white,
                                                                         ),
                                                                         Container(
                                                                           padding: EdgeInsets.only(top: 10,bottom: 10,left: 0),
                                                                           child: Column(
                                                                             children: [
                                                                               sText("Participant",color: Colors.grey),
                                                                               SizedBox(height: 10,),
                                                                               sText("20",weight: FontWeight.bold,size: 25),
                                                                             ],
                                                                           ),
                                                                         ),
                                                                         Container(
                                                                           height: 100,
                                                                           width: 2,
                                                                           color: Colors.white,
                                                                         ),
                                                                         Container(
                                                                           child: Column(
                                                                             children: [
                                                                               sText("Grade",color: Colors.grey),
                                                                               SizedBox(height: 10,),
                                                                               sText("B2",weight: FontWeight.bold,size: 25),
                                                                             ],
                                                                           ),
                                                                         ),
                                                                       ],
                                                                     ),
                                                                   ),
                                                                   Container(
                                                                     height: 2,
                                                                     color: Colors.white,
                                                                   ),
                                                                   Container(
                                                                     padding: topPadding(10),
                                                                     child: Row(
                                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                       children: [
                                                                         Container(
                                                                           child: Column(
                                                                             children: [
                                                                               sText("Speed",color: Colors.grey),
                                                                               Container(
                                                                                 width: 80,
                                                                                 height: 80,
                                                                                 child: SfRadialGauge(
                                                                                     enableLoadingAnimation: true,

                                                                                     axes: <RadialAxis>[

                                                                                       RadialAxis(minimum: 0, maximum: 150, useRangeColorForAxis: false,ranges: <GaugeRange>[
                                                                                         GaugeRange(
                                                                                           startValue: 0,
                                                                                           endValue: 50,
                                                                                           color: Color(0xFF93E7EB),
                                                                                           startWidth: 10,
                                                                                           endWidth: 10,
                                                                                           // rangeOffset: 5,
                                                                                         ),


                                                                                       ], pointers: <GaugePointer>[
                                                                                         // NeedlePointer(value: 50)
                                                                                       ], annotations: <GaugeAnnotation>[
                                                                                         GaugeAnnotation(
                                                                                             widget: Container(
                                                                                                 child: const Text('5.0q/m',
                                                                                                     style: TextStyle(
                                                                                                         fontSize: 8, fontWeight: FontWeight.bold))),
                                                                                             angle: 0,
                                                                                             positionFactor: 0.1)
                                                                                       ],
                                                                                         // showAxisLine: false,
                                                                                         showFirstLabel: false,
                                                                                         showLabels: false,
                                                                                         showLastLabel: false,
                                                                                         showTicks: false,
                                                                                         canScaleToFit: true,
                                                                                         axisLabelStyle: GaugeTextStyle(
                                                                                             color: Colors.white
                                                                                         ),
                                                                                         axisLineStyle: AxisLineStyle(
                                                                                           dashArray: [1,2],

                                                                                         ),
                                                                                         majorTickStyle: MajorTickStyle(
                                                                                             dashArray: [1,2],
                                                                                             length: 2,
                                                                                             thickness: 6
                                                                                         ),
                                                                                         minorTickStyle: MinorTickStyle(
                                                                                             dashArray: [1,2],
                                                                                             length: 2,
                                                                                             thickness: 9
                                                                                         ),

                                                                                       )
                                                                                     ]),
                                                                               )                                      ],
                                                                           ),
                                                                         ),
                                                                         Container(
                                                                           child: Column(
                                                                             children: [
                                                                               sText("Mastery",color: Colors.grey),
                                                                               SizedBox(height: 10,),
                                                                               Center(
                                                                                 child: SizedBox(
                                                                                   child: Stack(
                                                                                     children: [
                                                                                       SizedBox(
                                                                                         height: 60,
                                                                                         width: 60,
                                                                                         child: CircularProgressIndicator(
                                                                                           color: Color(0XFF8CFFC5),
                                                                                           strokeWidth: 5,

                                                                                           value: 0.7,

                                                                                         ),
                                                                                       ),
                                                                                       Positioned(
                                                                                         top: 20,
                                                                                         left: 15,
                                                                                         child: Center(
                                                                                           child: Column(
                                                                                             children: [
                                                                                               sText("85%",size: 10,weight: FontWeight.bold),
                                                                                               sText("avg.score",size: 7,weight: FontWeight.normal),

                                                                                             ],
                                                                                           ),
                                                                                         ),
                                                                                       ),
                                                                                     ],
                                                                                   ),
                                                                                 ),
                                                                               ),
                                                                             ],
                                                                           ),
                                                                         ),
                                                                         Container(
                                                                           child: Column(
                                                                             children: [
                                                                               sText("Strength",color: Colors.grey),
                                                                               SizedBox(height: 30,),
                                                                               AdeoSignalStrengthIndicator(
                                                                                 strength: 100,
                                                                               )
                                                                             ],
                                                                           ),
                                                                         ),
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
                                                       Padding(
                                                         padding: const EdgeInsets.symmetric(horizontal: 20),
                                                         child: Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           children: map<Widget>(5, (index, url) {
                                                             return Container(
                                                               width: 10,
                                                               height: 10,
                                                               margin: EdgeInsets.only(right: 5),
                                                               decoration: BoxDecoration(
                                                                   color: _currentSlide == index ?  Color(0xFF2A9CEA) : sGray,
                                                                   shape: BoxShape.circle
                                                               ),
                                                             );
                                                           }),
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 );
                                               }),
                                           SizedBox(height: 10,),
                                           Divider(color: Colors.white,height: 5,thickness: 5,),
                                           SizedBox(height: 10,),
                                         ],
                                     ) :
                                     dropdownValue == "Participants" ?
                                     Column(
                                       children: [
                                         CarouselSlider.builder(
                                             options:
                                             CarouselOptions(
                                               height:
                                               530,
                                               autoPlay:
                                               false,
                                               enableInfiniteScroll:
                                               false,
                                               autoPlayAnimationDuration:
                                               Duration(seconds: 1),
                                               enlargeCenterPage:
                                               false,
                                               viewportFraction:
                                               1,
                                               aspectRatio:
                                               2.0,
                                               pageSnapping:
                                               true,
                                               onPageChanged: (index, reason) {
                                                 setState(
                                                         () {
                                                       _currentSlide =
                                                           index;
                                                     });
                                               },
                                             ),
                                             itemCount:5,
                                             itemBuilder: (BuildContextcontext, int index, int index2) {
                                               return  Container(
                                                 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                                 child: Column(
                                                   children: [
                                                     Container(
                                                       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                       margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                                       decoration: BoxDecoration(
                                                           color: Color(0XFFDBF1A8),
                                                           borderRadius: BorderRadius.circular(10)
                                                       ),
                                                       child: Column(
                                                         children: [
                                                           Row(
                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                             children: [
                                                               Row(
                                                                 children: [
                                                                   Icon(Icons.play_arrow),
                                                                   sText("Samuel Quaye",weight: FontWeight.bold),
                                                                 ],
                                                               ),
                                                               Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Container(
                                                                     height: 40,
                                                                     width: 40,
                                                                     child: Center(child: sText("09",weight: FontWeight.bold)),
                                                                     decoration: BoxDecoration(
                                                                         color: Colors.white,
                                                                         shape: BoxShape.rectangle,
                                                                         borderRadius: BorderRadius.circular(10)
                                                                     ),
                                                                   ),
                                                                   SizedBox(height: 5,),
                                                                   sText("Passed",size: 10,weight: FontWeight.bold),
                                                                 ],
                                                               )
                                                             ],
                                                           ),
                                                           SizedBox(height: 10,),
                                                           LinearProgressIndicator(
                                                             color: Colors.red,
                                                             value: 0.5,
                                                             backgroundColor: Colors.grey,

                                                           ),
                                                           SizedBox(height: 10,),
                                                           Row(
                                                             children: [
                                                               Image.asset(
                                                                 "assets/images/trophy.png",
                                                               ),
                                                               SizedBox(width: 5,),
                                                               sText("2nd",weight: FontWeight.bold,color: Colors.grey),
                                                               Expanded(child: Container()),
                                                               Icon(Icons.arrow_forward,color: Colors.grey,)
                                                             ],
                                                           ),
                                                           SizedBox(height: 20,),
                                                           Container(
                                                             decoration: BoxDecoration(
                                                                 color: Color(0XFFFAFAFA),
                                                                 borderRadius: BorderRadius.circular(15)
                                                             ),
                                                             padding: bottomPadding(15),
                                                             child: Column(
                                                               children: [
                                                                 Container(
                                                                   child: Row(
                                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                     children: [
                                                                       Center(
                                                                         child: Container(
                                                                           // padding: EdgeInsets.only(top: 10,bottom: 10,left:10),

                                                                           child: Column(
                                                                             children: [
                                                                               sText("Courses ",color: Colors.grey,align: TextAlign.center),
                                                                               SizedBox(height: 10,),
                                                                               sText("9",weight: FontWeight.bold,size: 25),
                                                                             ],
                                                                           ),
                                                                         ),
                                                                       ),
                                                                       Container(
                                                                         height: 100,
                                                                         width: 2,
                                                                         color: Colors.white,
                                                                       ),
                                                                       Container(
                                                                         padding: EdgeInsets.only(top: 10,bottom: 10,left: 0),
                                                                         child: Column(
                                                                           children: [
                                                                             sText("Test",color: Colors.grey),
                                                                             SizedBox(height: 10,),
                                                                             sText("20",weight: FontWeight.bold,size: 25),
                                                                           ],
                                                                         ),
                                                                       ),
                                                                       Container(
                                                                         height: 100,
                                                                         width: 2,
                                                                         color: Colors.white,
                                                                       ),
                                                                       Container(
                                                                         child: Column(
                                                                           children: [
                                                                             sText("Grade",color: Colors.grey),
                                                                             SizedBox(height: 10,),
                                                                             sText("B2",weight: FontWeight.bold,size: 25),
                                                                           ],
                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                 ),
                                                                 Container(
                                                                   height: 2,
                                                                   color: Colors.white,
                                                                 ),
                                                                 Container(
                                                                   padding: topPadding(10),
                                                                   child: Row(
                                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                     children: [
                                                                       Container(
                                                                         child: Column(
                                                                           children: [
                                                                             sText("Speed",color: Colors.grey),
                                                                             Container(
                                                                               width: 80,
                                                                               height: 80,
                                                                               child: SfRadialGauge(
                                                                                   enableLoadingAnimation: true,

                                                                                   axes: <RadialAxis>[

                                                                                     RadialAxis(minimum: 0, maximum: 150, useRangeColorForAxis: false,ranges: <GaugeRange>[
                                                                                       GaugeRange(
                                                                                         startValue: 0,
                                                                                         endValue: 50,
                                                                                         color: Color(0xFF93E7EB),
                                                                                         startWidth: 10,
                                                                                         endWidth: 10,
                                                                                         // rangeOffset: 5,
                                                                                       ),


                                                                                     ], pointers: <GaugePointer>[
                                                                                       // NeedlePointer(value: 50)
                                                                                     ], annotations: <GaugeAnnotation>[
                                                                                       GaugeAnnotation(
                                                                                           widget: Container(
                                                                                               child: const Text('5.0q/m',
                                                                                                   style: TextStyle(
                                                                                                       fontSize: 8, fontWeight: FontWeight.bold))),
                                                                                           angle: 0,
                                                                                           positionFactor: 0.1)
                                                                                     ],
                                                                                       // showAxisLine: false,
                                                                                       showFirstLabel: false,
                                                                                       showLabels: false,
                                                                                       showLastLabel: false,
                                                                                       showTicks: false,
                                                                                       canScaleToFit: true,
                                                                                       axisLabelStyle: GaugeTextStyle(
                                                                                           color: Colors.white
                                                                                       ),
                                                                                       axisLineStyle: AxisLineStyle(
                                                                                         dashArray: [1,2],

                                                                                       ),
                                                                                       majorTickStyle: MajorTickStyle(
                                                                                           dashArray: [1,2],
                                                                                           length: 2,
                                                                                           thickness: 6
                                                                                       ),
                                                                                       minorTickStyle: MinorTickStyle(
                                                                                           dashArray: [1,2],
                                                                                           length: 2,
                                                                                           thickness: 9
                                                                                       ),

                                                                                     )
                                                                                   ]),
                                                                             )                                      ],
                                                                         ),
                                                                       ),
                                                                       Container(
                                                                         child: Column(
                                                                           children: [
                                                                             sText("Mastery",color: Colors.grey),
                                                                             SizedBox(height: 10,),
                                                                             Center(
                                                                               child: SizedBox(
                                                                                 child: Stack(
                                                                                   children: [
                                                                                     SizedBox(
                                                                                       height: 60,
                                                                                       width: 60,
                                                                                       child: CircularProgressIndicator(
                                                                                         color: Color(0XFF8CFFC5),
                                                                                         strokeWidth: 5,

                                                                                         value: 0.7,

                                                                                       ),
                                                                                     ),
                                                                                     Positioned(
                                                                                       top: 20,
                                                                                       left: 15,
                                                                                       child: Center(
                                                                                         child: Column(
                                                                                           children: [
                                                                                             sText("85%",size: 10,weight: FontWeight.bold),
                                                                                             sText("avg.score",size: 7,weight: FontWeight.normal),

                                                                                           ],
                                                                                         ),
                                                                                       ),
                                                                                     ),
                                                                                   ],
                                                                                 ),
                                                                               ),
                                                                             ),
                                                                           ],
                                                                         ),
                                                                       ),
                                                                       Container(
                                                                         child: Column(
                                                                           children: [
                                                                             sText("Strength",color: Colors.grey),
                                                                             SizedBox(height: 30,),
                                                                             AdeoSignalStrengthIndicator(
                                                                               strength: 100,
                                                                             )
                                                                           ],
                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                 ),
                                                                 Container(
                                                                   height: 2,
                                                                   color: Colors.white,
                                                                 ),
                                                                 Container(
                                                                   padding: topPadding(10),
                                                                   child: Row(
                                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                     children: [
                                                                       Center(
                                                                         child: Container(
                                                                           padding: EdgeInsets.only(top: 0,bottom: 30,left:10),

                                                                           child: Column(
                                                                             crossAxisAlignment: CrossAxisAlignment.center,
                                                                             children: [
                                                                               sText("Total",color: Colors.grey,align: TextAlign.center),
                                                                               sText("Score",color: Colors.grey,align: TextAlign.center),
                                                                               SizedBox(height: 20,),
                                                                               sText("9",weight: FontWeight.bold,size: 25),
                                                                             ],
                                                                           ),
                                                                         ),
                                                                       ),
                                                                       Container(
                                                                         height: 100,
                                                                         width: 2,
                                                                         color: Colors.white,
                                                                       ),
                                                                       Container(
                                                                         padding: EdgeInsets.only(top: 0,bottom: 30,left: 0),
                                                                         child: Column(
                                                                           crossAxisAlignment: CrossAxisAlignment.center,
                                                                           children: [
                                                                             sText("Group",color: Colors.grey,align: TextAlign.center),
                                                                             sText("Score",color: Colors.grey,align: TextAlign.center),
                                                                             SizedBox(height: 20,),
                                                                             sText("9",weight: FontWeight.bold,size: 25),
                                                                           ],
                                                                         ),
                                                                       ),
                                                                       Container(
                                                                         height: 100,
                                                                         width: 2,
                                                                         color: Colors.white,
                                                                       ),
                                                                       Container(
                                                                         child: Column(
                                                                           crossAxisAlignment: CrossAxisAlignment.center,
                                                                           children: [
                                                                             sText("Group",color: Colors.grey),
                                                                             sText("Mastery",color: Colors.grey),
                                                                             SizedBox(height: 20,),
                                                                             Center(
                                                                               child: SizedBox(
                                                                                 child: Stack(
                                                                                   children: [
                                                                                     SizedBox(
                                                                                       height: 60,
                                                                                       width: 60,
                                                                                       child: CircularProgressIndicator(
                                                                                         color: Color(0XFF8CFFC5),
                                                                                         strokeWidth: 5,

                                                                                         value: 0.7,

                                                                                       ),
                                                                                     ),
                                                                                     Positioned(
                                                                                       top: 20,
                                                                                       left: 15,
                                                                                       child: Center(
                                                                                         child: Column(
                                                                                           children: [
                                                                                             sText("85%",size: 10,weight: FontWeight.bold),
                                                                                             sText("avg.score",size: 7,weight: FontWeight.normal),

                                                                                           ],
                                                                                         ),
                                                                                       ),
                                                                                     ),
                                                                                   ],
                                                                                 ),
                                                                               ),
                                                                             ),
                                                                           ],
                                                                         ),
                                                                       ),
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
                                                     Padding(
                                                       padding: const EdgeInsets.symmetric(horizontal: 20),
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: map<Widget>(5, (index, url) {
                                                           return Container(
                                                             width: 10,
                                                             height: 10,
                                                             margin: EdgeInsets.only(right: 5),
                                                             decoration: BoxDecoration(
                                                                 color: _currentSlide == index ?  Color(0xFF2A9CEA) : sGray,
                                                                 shape: BoxShape.circle
                                                             ),
                                                           );
                                                         }),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             }),
                                         SizedBox(height: 10,),
                                         Divider(color: Colors.white,height: 5,thickness: 5,),
                                         SizedBox(height: 10,),
                                       ],
                                     ) :
                                     dropdownValue == "Tests" ?
                                     Column(
                                       children: [
                                         CarouselSlider.builder(
                                             options:
                                             CarouselOptions(
                                               height:
                                               530,
                                               autoPlay:
                                               false,
                                               enableInfiniteScroll:
                                               false,
                                               autoPlayAnimationDuration:
                                               Duration(seconds: 1),
                                               enlargeCenterPage:
                                               false,
                                               viewportFraction:
                                               1,
                                               aspectRatio:
                                               2.0,
                                               pageSnapping:
                                               true,
                                               onPageChanged: (index, reason) {
                                                 setState(
                                                         () {
                                                       _currentSlide =
                                                           index;
                                                     });
                                               },
                                             ),
                                             itemCount:5,
                                             itemBuilder: (BuildContextcontext, int index, int index2) {
                                               return  Container(
                                                 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                                 child: Column(
                                                   children: [
                                                     Container(
                                                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                                       margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                                       decoration: BoxDecoration(
                                                           color: Colors.grey[300],
                                                           borderRadius: BorderRadius.circular(10)
                                                       ),
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                         children: [
                                                           Column(
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               Container(
                                                                 child: sText("Revision 1",size: 16,weight: FontWeight.bold),
                                                               ),
                                                               Row(
                                                                 children: [
                                                                   Icon(Icons.timelapse,size: 8,),
                                                                   Container(
                                                                     child: sText("3hrs ago",size: 8,weight: FontWeight.bold),
                                                                   ),
                                                                 ],
                                                               ),
                                                               SizedBox(height: 10,),
                                                               Container(
                                                                 child: sText("20 participant",color: Colors.grey,weight: FontWeight.w500,size: 12),
                                                               ),
                                                               Container(
                                                                 child: sText("10 questions",color: Colors.grey,weight: FontWeight.w500,size: 12),
                                                               ),
                                                             ],
                                                           ),
                                                           Column(
                                                             crossAxisAlignment: CrossAxisAlignment.end,
                                                             children: [
                                                               SizedBox(height: 20,),
                                                               Row(
                                                                 children: [
                                                                   Column(
                                                                     children: [
                                                                       Container(
                                                                         height: 40,
                                                                         width: 40,
                                                                         child: Center(child: sText("09",weight: FontWeight.bold)),
                                                                         decoration: BoxDecoration(
                                                                             color: Colors.white,
                                                                             shape: BoxShape.rectangle,
                                                                             borderRadius: BorderRadius.circular(10)
                                                                         ),
                                                                       ),
                                                                       SizedBox(height: 5,),
                                                                       sText("Mastery",size: 10,weight: FontWeight.w500)
                                                                     ],
                                                                   ),
                                                                   SizedBox(width: 10,),
                                                                   Column(
                                                                     children: [
                                                                       Container(
                                                                         height: 40,
                                                                         width: 40,
                                                                         child: Center(child: sText("2.5",weight: FontWeight.bold)),
                                                                         decoration: BoxDecoration(
                                                                             color: Colors.white,
                                                                             shape: BoxShape.rectangle,
                                                                             borderRadius: BorderRadius.circular(10)
                                                                         ),
                                                                       ),
                                                                       SizedBox(height: 5,),
                                                                       sText("Avg. Time",size: 10,weight: FontWeight.w500)
                                                                     ],
                                                                   ),
                                                                   SizedBox(width: 10,),
                                                                   Column(
                                                                     children: [
                                                                       Container(
                                                                         height: 40,
                                                                         width: 40,
                                                                         child: Center(child: sText("09",weight: FontWeight.bold)),
                                                                         decoration: BoxDecoration(
                                                                             color: Colors.white,
                                                                             shape: BoxShape.rectangle,
                                                                             borderRadius: BorderRadius.circular(10)
                                                                         ),
                                                                       ),
                                                                       SizedBox(height: 5,),
                                                                       sText("Passed",size: 10,weight: FontWeight.w500)
                                                                     ],
                                                                   ),
                                                                 ],
                                                               ),
                                                                Icon(Icons.arrow_forward,color: Colors.grey,)
                                                             ],
                                                           )

                                                         ],
                                                       ),
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Padding(
                                                       padding: const EdgeInsets.symmetric(horizontal: 20),
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: map<Widget>(5, (index, url) {
                                                           return Container(
                                                             width: 10,
                                                             height: 10,
                                                             margin: EdgeInsets.only(right: 5),
                                                             decoration: BoxDecoration(
                                                                 color: _currentSlide == index ?  Color(0xFF2A9CEA) : sGray,
                                                                 shape: BoxShape.circle
                                                             ),
                                                           );
                                                         }),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             }),
                                         SizedBox(height: 10,),
                                         Divider(color: Colors.white,height: 5,thickness: 5,),
                                         SizedBox(height: 10,),
                                       ],
                                     ) :
                                     dropdownValue == "Topics" ?
                                     Column(
                                       children: [
                                         CarouselSlider.builder(
                                             options:
                                             CarouselOptions(
                                               height:
                                               530,
                                               autoPlay:
                                               false,
                                               enableInfiniteScroll:
                                               false,
                                               autoPlayAnimationDuration:
                                               Duration(seconds: 1),
                                               enlargeCenterPage:
                                               false,
                                               viewportFraction:
                                               1,
                                               aspectRatio:
                                               2.0,
                                               pageSnapping:
                                               true,
                                               onPageChanged: (index, reason) {
                                                 setState(
                                                         () {
                                                       _currentSlide =
                                                           index;
                                                     });
                                               },
                                             ),
                                             itemCount:5,
                                             itemBuilder: (BuildContextcontext, int index, int index2) {
                                               return  Container(
                                                 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                                 child: Column(
                                                   children: [
                                                     Container(
                                                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                       margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                                       decoration: BoxDecoration(
                                                           color: Colors.grey[300],
                                                           borderRadius: BorderRadius.circular(10)
                                                       ),
                                                       child: Column(
                                                         children: [
                                                           Row(
                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                             children: [
                                                               Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Container(
                                                                     child: sText("Photosynthesis",size: 16,weight: FontWeight.bold),
                                                                   ),
                                                                   Row(
                                                                     children: [
                                                                       Icon(Icons.timelapse,size: 8,),
                                                                       Container(
                                                                         child: sText("3hrs ago",size: 8,weight: FontWeight.bold),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                 ],
                                                               ),
                                                               Container(
                                                                 padding: EdgeInsets.only(top: 0,bottom: 10),
                                                                 child: Row(
                                                                   children: [
                                                                     Image.asset(
                                                                       "assets/images/trophy.png",
                                                                     ),
                                                                     SizedBox(width: 5,),

                                                                     sText("2nd",weight: FontWeight.bold,color: Colors.grey),
                                                                   ],
                                                                 ),
                                                               ),
                                                             ],
                                                           ),
                                                           Container(
                                                             child: Column(
                                                               crossAxisAlignment: CrossAxisAlignment.end,
                                                               mainAxisAlignment: MainAxisAlignment.center,
                                                               children: [
                                                                 Row(
                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                   children: [
                                                                     Column(
                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                                       children: [
                                                                         Container(
                                                                           child: sText("20 participant",color: Colors.grey,weight: FontWeight.w500,size: 12),
                                                                         ),
                                                                         Container(
                                                                           child: sText("10 questions",color: Colors.grey,weight: FontWeight.w500,size: 12),
                                                                         ),
                                                                       ],
                                                                     ),
                                                                     Row(
                                                                       children: [
                                                                         Column(
                                                                           children: [
                                                                             Container(
                                                                               height: 40,
                                                                               width: 40,
                                                                               child: Center(child: sText("09",weight: FontWeight.bold)),
                                                                               decoration: BoxDecoration(
                                                                                   color: Colors.white,
                                                                                   shape: BoxShape.rectangle,
                                                                                   borderRadius: BorderRadius.circular(10)
                                                                               ),
                                                                             ),
                                                                             SizedBox(height: 5,),
                                                                             sText("Mastery",size: 10,weight: FontWeight.w500)
                                                                           ],
                                                                         ),
                                                                         SizedBox(width: 10,),
                                                                         Column(
                                                                           children: [
                                                                             Container(
                                                                               height: 40,
                                                                               width: 40,
                                                                               child: Center(child: sText("2.5",weight: FontWeight.bold)),
                                                                               decoration: BoxDecoration(
                                                                                   color: Colors.white,
                                                                                   shape: BoxShape.rectangle,
                                                                                   borderRadius: BorderRadius.circular(10)
                                                                               ),
                                                                             ),
                                                                             SizedBox(height: 5,),
                                                                             sText("Avg. Time",size: 10,weight: FontWeight.w500)
                                                                           ],
                                                                         ),
                                                                         SizedBox(width: 10,),
                                                                         Column(
                                                                           children: [
                                                                             Container(
                                                                               height: 40,
                                                                               width: 40,
                                                                               child: Center(child: sText("09",weight: FontWeight.bold)),
                                                                               decoration: BoxDecoration(
                                                                                   color: Colors.white,
                                                                                   shape: BoxShape.rectangle,
                                                                                   borderRadius: BorderRadius.circular(10)
                                                                               ),
                                                                             ),
                                                                             SizedBox(height: 5,),
                                                                             sText("Passed",size: 10,weight: FontWeight.w500)
                                                                           ],
                                                                         ),
                                                                       ],
                                                                     ),
                                                                   ],
                                                                 ),
                                                                 Icon(Icons.arrow_forward,color: Colors.grey,)
                                                               ],
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Padding(
                                                       padding: const EdgeInsets.symmetric(horizontal: 20),
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: map<Widget>(5, (index, url) {
                                                           return Container(
                                                             width: 10,
                                                             height: 10,
                                                             margin: EdgeInsets.only(right: 5),
                                                             decoration: BoxDecoration(
                                                                 color: _currentSlide == index ?  Color(0xFF2A9CEA) : sGray,
                                                                 shape: BoxShape.circle
                                                             ),
                                                           );
                                                         }),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             }),
                                         SizedBox(height: 10,),
                                         Divider(color: Colors.white,height: 5,thickness: 5,),
                                         SizedBox(height: 10,),
                                       ],
                                     ) :
                                     dropdownValue == "Questions" ?
                                     Column(
                                       children: [

                                           Column(
                                             children: [

                                               Container(
                                                 padding: EdgeInsets.symmetric(
                                                     horizontal: 0, vertical: 0),
                                                 margin:
                                                 EdgeInsets.symmetric(horizontal: 20),
                                                 decoration: BoxDecoration(
                                                   color: Colors.white,
                                                   borderRadius: BorderRadius.circular(5),
                                                 ),
                                                 child: Column(
                                                   children: [
                                                     ExpansionTile(
                                                       iconColor: Color(0xFFB5B5B5),
                                                       title: Column(
                                                         crossAxisAlignment:
                                                         CrossAxisAlignment.start,
                                                         children: [
                                                           Container(
                                                              // width: 100,
                                                               child: sText("Which of the following is a product",maxLines: 1),
                                                           )
                                                         ],
                                                       ),
                                                       children: [
                                                         Container(
                                                           margin: EdgeInsets.symmetric(
                                                             vertical: 20,
                                                           ),
                                                           decoration: BoxDecoration(
                                                             color: Color(0xFFF8F8F8)
                                                                 .withOpacity(1),
                                                             borderRadius:
                                                             BorderRadius.circular(8),
                                                             border: Border.all(
                                                               width: 1.5,
                                                               color: Color(0xFF489CFF),
                                                             ),
                                                           ),
                                                           child: Column(
                                                             crossAxisAlignment:
                                                             CrossAxisAlignment.start,
                                                             children: [
                                                               SizedBox(height: 10,),
                                                               ListTile(
                                                                 title: sText(
                                                                   "Test Name",
                                                                   size: 14.0,
                                                                   color: Color(0xFF5A6775),
                                                                 ),
                                                                 subtitle: sText(
                                                                   "name",
                                                                   weight: FontWeight.w600,
                                                                 ),
                                                               ),
                                                               ListTile(
                                                                 title: sText(
                                                                   "Test Source",
                                                                   size: 14.0,
                                                                   color: Color(0xFF5A6775),
                                                                 ),
                                                                 subtitle: Column(
                                                                   crossAxisAlignment:
                                                                   CrossAxisAlignment
                                                                       .start,
                                                                   children: [
                                                                     sText(
                                                                       "score",
                                                                       weight:
                                                                       FontWeight.w600,
                                                                     ),
                                                                     sText(
                                                                       "cours",
                                                                       style:
                                                                       FontStyle.italic,
                                                                     ),
                                                                   ],
                                                                 ),
                                                               ),
                                                               ListTile(
                                                                 title: sText(
                                                                   "Timing",
                                                                   size: 14.0,
                                                                   color: Color(0xFF5A6775),
                                                                 ),
                                                                 subtitle: sText(
                                                                   "timing",
                                                                   weight: FontWeight.w600,
                                                                 ),
                                                               ),
                                                               ListTile(
                                                                 title: sText(
                                                                   "Test Period",
                                                                   size: 14.0,
                                                                   color: Color(0xFF5A6775),
                                                                 ),
                                                                 subtitle: Column(
                                                                   crossAxisAlignment:
                                                                   CrossAxisAlignment
                                                                       .start,
                                                                   children: [
                                                                     sText(
                                                                       "Exact Time",
                                                                       weight:
                                                                       FontWeight.w600,
                                                                     ),
                                                                     sText(
                                                                         "start",
                                                                         style: FontStyle
                                                                             .italic),
                                                                   ],
                                                                 ),
                                                               ),
                                                               ListTile(
                                                                 title: sText(
                                                                   "Status",
                                                                   size: 14.0,
                                                                   color: Color(0xFF5A6775),
                                                                 ),
                                                                 subtitle: sText(
                                                                   "status",
                                                                   weight: FontWeight.w600,
                                                                 ),
                                                               ),
                                                             ],
                                                           ),
                                                         )
                                                       ],
                                                     ),
                                                     Container(
                                                         color: Colors.grey[200],
                                                         height:1,
                                                         width:appWidth(context)
                                                     ),
                                                     Container(
                                                         padding: EdgeInsets.symmetric(
                                                           horizontal: 10, vertical: 10),
                                                       child: Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                           children:[
                                                             Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   sText("Photosynthesis",color: Colors.grey,weight: FontWeight.w500),
                                                                   SizedBox(height:10),
                                                                   sText("Topic",color: Colors.grey[400]!),
                                                                 ],
                                                             ),
                                                             Column(
                                                             crossAxisAlignment: CrossAxisAlignment.end,
                                                               children: [
                                                                 AdeoSignalStrengthIndicator(
                                                                   strength: 100,
                                                                 ),
                                                                 SizedBox(height:10),
                                                                 Row(
                                                                   children: [
                                                                     sText("50s",color: Colors.grey,weight: FontWeight.bold,size: 10),
                                                                     sText("|"),
                                                                     sText("90%",color: Colors.grey,weight: FontWeight.bold,size: 10),
                                                                   ],
                                                                 ),

                                                               ],
                                                             ),

                                                           ]
                                                       ),
                                                     )
                                                   ],
                                                 ),
                                               ),
                                               SizedBox(height: 10,),
                                              
                                             ],
                                           ),
                                       ],
                                     )  :
                                      Container()
                                   ],
                               )

                              ],
                            ),
                          ),

                        ],
                      ),
                      // wallet

                      // Column(
                      //   children: [
                      //     Theme(
                      //       data: Theme.of(context)
                      //           .copyWith(dividerColor: Colors.transparent),
                      //       child: ExpansionTile(
                      //         textColor: Colors.white,
                      //         iconColor: Colors.white,
                      //         initiallyExpanded: false,
                      //         maintainState: false,
                      //         backgroundColor: kHomeBackgroundColor,
                      //         childrenPadding: EdgeInsets.zero,
                      //         collapsedIconColor: Colors.white,
                      //         leading: Container(
                      //           child: sText("Wallet",
                      //               weight: FontWeight.w500, size: 16),
                      //         ),
                      //         trailing: Container(
                      //           child: Icon(
                      //             Icons.add_circle_outline,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //         title: Container(),
                      //         children: <Widget>[
                      //           SizedBox(
                      //             height: 10,
                      //           ),
                      //           if (listGroupViewData[0].admins!.isNotEmpty)
                      //             Container(
                      //               padding: EdgeInsets.symmetric(
                      //                   horizontal: 20, vertical: 10),
                      //               margin:
                      //                   EdgeInsets.symmetric(horizontal: 20),
                      //               decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   borderRadius: BorderRadius.circular(5)),
                      //               child: Column(
                      //                 children: [
                      //                   for (int i = 0;
                      //                       i <
                      //                           listGroupViewData[0]
                      //                               .admins!
                      //                               .length;
                      //                       i++)
                      //                     Column(
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Stack(
                      //                               children: [
                      //                                 displayLocalImage(
                      //                                     "filePath",
                      //                                     radius: 30),
                      //                                 Positioned(
                      //                                   bottom: 5,
                      //                                   right: 0,
                      //                                   child: Image.asset(
                      //                                       "assets/images/tick-mark.png"),
                      //                                 )
                      //                               ],
                      //                             ),
                      //                             SizedBox(
                      //                               width: 10,
                      //                             ),
                      //                             Column(
                      //                               crossAxisAlignment:
                      //                                   CrossAxisAlignment
                      //                                       .start,
                      //                               children: [
                      //                                 sText(
                      //                                     listGroupViewData[0]
                      //                                         .admins![i]
                      //                                         .name,
                      //                                     color: Colors.black,
                      //                                     weight:
                      //                                         FontWeight.w500),
                      //                                 SizedBox(
                      //                                   height: 5,
                      //                                 ),
                      //                                 sText("Admin",
                      //                                     color: kAdeoGray3,
                      //                                     size: 12),
                      //                               ],
                      //                             ),
                      //                             Expanded(child: Container()),
                      //                             Icon(
                      //                               Icons.arrow_forward_ios,
                      //                               color: kAdeoGray3,
                      //                               size: 16,
                      //                             )
                      //                           ],
                      //                         ),
                      //                         SizedBox(
                      //                           height: 10,
                      //                         )
                      //                       ],
                      //                     ),
                      //                 ],
                      //               ),
                      //             ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Setting
                      MaterialButton(
                        onPressed: ()async{
                         var res = await  goTo(context, Settings(groupListData: widget.groupListData,));
                        setState((){
                          if(res != null){
                            widget.groupListData = res;
                          }
                        });
                        },
                        child: Column(
                          children: [
                            // Theme(
                            //   data: Theme.of(context)
                            //       .copyWith(dividerColor: Colors.transparent),
                            //   child: ExpansionTile(
                            //
                            //     textColor: Colors.white,
                            //     iconColor: Colors.white,
                            //     initiallyExpanded: false,
                            //     maintainState: false,
                            //     onExpansionChanged: (value){
                            //       if(value){
                            //         goTo(context, Settings(groupListData: widget.groupListData,));
                            //       }
                            //     },
                            //
                            //     backgroundColor: kHomeBackgroundColor,
                            //     childrenPadding: EdgeInsets.zero,
                            //     collapsedIconColor: Colors.white,
                            //     leading: Container(
                            //       child: sText("Settings",
                            //           weight: FontWeight.w500, size: 16),
                            //     ),
                            //     trailing: Container(
                            //       child: Icon(
                            //         Icons.add_circle_outline,
                            //         color: Colors.black,
                            //       ),
                            //     ),
                            //     title: Container(),
                            //     children: <Widget>[
                            //       SizedBox(
                            //         height: 10,
                            //       ),
                            //       if (listGroupViewData[0].admins!.isNotEmpty)
                            //         Container(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 20, vertical: 10),
                            //           margin:
                            //               EdgeInsets.symmetric(horizontal: 20),
                            //           decoration: BoxDecoration(
                            //               color: Colors.white,
                            //               borderRadius: BorderRadius.circular(5)),
                            //           child: Column(
                            //             children: [
                            //               for (int i = 0;
                            //                   i <
                            //                       listGroupViewData[0]
                            //                           .admins!
                            //                           .length;
                            //                   i++)
                            //                 Column(
                            //                   children: [
                            //                     Row(
                            //                       children: [
                            //                         Stack(
                            //                           children: [
                            //                             displayLocalImage(
                            //                                 "filePath",
                            //                                 radius: 30),
                            //                             Positioned(
                            //                               bottom: 5,
                            //                               right: 0,
                            //                               child: Image.asset(
                            //                                   "assets/images/tick-mark.png"),
                            //                             )
                            //                           ],
                            //                         ),
                            //                         SizedBox(
                            //                           width: 10,
                            //                         ),
                            //                         Column(
                            //                           crossAxisAlignment:
                            //                               CrossAxisAlignment
                            //                                   .start,
                            //                           children: [
                            //                             sText(
                            //                                 listGroupViewData[0]
                            //                                     .admins![i]
                            //                                     .name,
                            //                                 color: Colors.black,
                            //                                 weight:
                            //                                     FontWeight.w500),
                            //                             SizedBox(
                            //                               height: 5,
                            //                             ),
                            //                             sText("Admin",
                            //                                 color: kAdeoGray3,
                            //                                 size: 12),
                            //                           ],
                            //                         ),
                            //                         Expanded(child: Container()),
                            //                         Icon(
                            //                           Icons.arrow_forward_ios,
                            //                           color: kAdeoGray3,
                            //                           size: 16,
                            //                         )
                            //                       ],
                            //                     ),
                            //                     SizedBox(
                            //                       height: 10,
                            //                     )
                            //                   ],
                            //                 ),
                            //             ],
                            //           ),
                            //         ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                  Container(
                                        child: sText("Settings",
                                            weight: FontWeight.w500, size: 16),
                                      ),
                                    Container(
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.black,
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
                )
              : progressCode
                  ? Expanded(child: Center(child: progress()))
                  : Expanded(
                      child: Center(child: sText("Group does not exist")))
        ],
      ),
    );
  }
}

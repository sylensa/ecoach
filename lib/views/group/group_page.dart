import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/announcement_list_model.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_page_view_model.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/commission/commission_agent_page.dart';
import 'package:ecoach/views/group/group_list.dart';
import 'package:ecoach/views/group/test_creation/test_creation.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class GroupPage extends StatefulWidget {
  GroupListData? groupListData;
  GroupPage({this.groupListData});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<ListNames> listMembers = [ListNames(name: "Victor Adatsi",id: "1"),ListNames(name: "Samuel Quaye",id: "2"),ListNames(name: "Peter Ocansey",id: "1"),];
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
  showRevokeDialog(
      {String? message,
        BuildContext? context,
        Widget? target,
        bool replace = false,
        String? userId}) {
    // flutter defined function
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: sText("Alert",color: Colors.black,weight: FontWeight.bold),
          content: sText(message!),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            GestureDetector(
              onTap: ()async{
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                margin: rightPadding(10),
                child: sText("No",color: Colors.white),

                decoration: BoxDecoration(
                    color:kAccessmentButtonColor,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),

            GestureDetector(
              onTap: ()async{
                Navigator.pop(context);
                showLoaderDialog(context);
                await revokeGroupInvite(userId!);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                margin: rightPadding(10),
                child: sText("Yes",color: Colors.white),

                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            )
          ],
        );
      },
    );
  }
  memberActionsModalBottomSheet(context,String userId,bool isMember){
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 400;
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
                      color: kAdeoGray ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: sText("Member Actions",weight: FontWeight.bold,size: 20,align: TextAlign.center)),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Perform an action",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                      ),
                      SizedBox(height: 20,),
                      Expanded(
                          child: ListView(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  showLoaderDialog(context);
                                  removeMember(userId);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  decoration:BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: sText("Remove member",color: kAdeoGray3,align: TextAlign.center),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  showLoaderDialog(context);
                                  suspendMember(userId);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  decoration:BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: sText("Suspend member",color: kAdeoGray3,align: TextAlign.center),
                                ),
                              ),
                              isMember ?
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  showLoaderDialog(context);
                                  makeUserAdmin(userId);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  decoration:BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: sText("Make member an admin",color: kAdeoGray3,align: TextAlign.center),
                                ),
                              ) :
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  showLoaderDialog(context);
                                  makeAdminParticipant(userId);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  decoration:BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: sText("Make Admin a Participant",color: kAdeoGray3,align: TextAlign.center),
                                ),
                              ) ,
                            ],
                          )
                      ),

                    ],
                  )
              );
            },

          );
        }
    );
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
        if (result == "report") {
        }

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
  groupActionsModalBottomSheet(context,){
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 400;
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
                      color: kAdeoGray ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: sText("Group Actions",weight: FontWeight.bold,size: 20,align: TextAlign.center)),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Perform an action",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                      ),
                      SizedBox(height: 20,),
                      Expanded(
                          child: ListView(
                            children: [
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                onPressed: ()async{

                                },
                                child: Container(
                                  width: appWidth(context),
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  decoration:BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: sText("Delete Group",color: kAdeoGray3,align: TextAlign.center),
                                ),
                              ),
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                onPressed: ()async{
                                  Navigator.pop(context);
                                    showLoaderDialog(context);
                                    if(widget.groupListData!.status!.toLowerCase() == "suspended"){
                                     await unSuspendGroup();
                                    }else{
                                      await suspendGroup();
                                    }
                                },
                                child: Container(
                                  width: appWidth(context),
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  decoration:BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: sText(widget.groupListData!.status!.toLowerCase() == "suspended" ? "Unsuspend Group" : "Suspend Group",color: kAdeoGray3,align: TextAlign.center),
                                ),
                              ),
                              // MaterialButton(
                              //   padding: EdgeInsets.zero,
                              //   onPressed: ()async{
                              //
                              //   },
                              //   child: Container(
                              //     width: appWidth(context),
                              //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              //     margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              //     decoration:BoxDecoration(
                              //         color: Colors.white,
                              //         borderRadius: BorderRadius.circular(10)
                              //     ),
                              //     child: sText("Make member an admin",color: kAdeoGray3,align: TextAlign.center),
                              //   ),
                              // ),
                            ],
                          )
                      ),

                    ],
                  )
              );
            },

          );
        }
    );
  }
  getGroupPageView() async{
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      listGroupViewData.clear();
      try{
        listGroupViewData = await GroupManagementController(groupId: widget.groupListData!.id.toString()).getGroupPageView();
        setState((){
          progressCode = false;
        });
      }catch(e){
        Navigator.pop(context);
        setState((){
          progressCode = false;
        });
        toastMessage("Failed");
      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
      }


    setState((){
      progressCode = false;
    });

  }
  makeUserAdmin(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
       if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).makeUserAdmin(userId)){
         await getGroupPageView();
         Navigator.pop(context);

       }else{
         Navigator.pop(context);
         // toastMessage("Failed");
       }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  makeAdminParticipant(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
       if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).makeUserParticipant(userId)){
         await getGroupPageView();
         Navigator.pop(context);

       }else{
         Navigator.pop(context);
         // toastMessage("Failed");
       }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  suspendGroup() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).groupSuspend()){
        setState((){
          widget.groupListData!.status = "SUSPENDED";
        });
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  unSuspendGroup() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).groupUnSuspend()){
        setState((){
          widget.groupListData!.status = "ACTIVE";
        });
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  suspendMember(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).suspendUser(userId)){
        await getGroupPageView();
        Navigator.pop(context);

      }else{
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  removeMember(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).removeUser(userId)){
        await getGroupPageView();
        Navigator.pop(context);

      }else{
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  revokeGroupInvite(String userId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).groupInviteRevoke(userId)){
        await getGroupPageView();
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        // toastMessage("Failed");
      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }
  announcementModalBottomSheet(context,){
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 600;
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
                      color: kAdeoGray ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: sText("Announcement",weight: FontWeight.bold,size: 20,align: TextAlign.center)),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Select Your Preferred Upgrade",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                      ),
                      SizedBox(height: 20,),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      // autofocus: true,
                                      controller:titleController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please check that you\'ve entered group email';
                                        }
                                        return null;
                                      },
                                      decoration: textDecorNoBorder(
                                        radius: 10,
                                        labelText: "Name",
                                        hintColor: Color(0xFFB9B9B9),
                                        borderColor:Colors.white ,
                                        fill: Colors.white,
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderColor:Colors.white ,
                                        fill: Colors.white,
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
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
                        onTap: (){
                          showLoaderDialog(context);
                        },
                        child: Container(
                          width: appWidth(context),
                          color: Color(0xFF00C9B9),
                          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                          child: sText("Send Announcement",color: Colors.white,weight: FontWeight.w500,align: TextAlign.center,size: 18),
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

  createAnnouncement({String title = '',String description = ''})async{
    final bool isConnected = await InternetConnectionChecker().hasConnection;
      try{
        if(isConnected){
          AnnouncementData? announcementData = await GroupManagementController(groupId: widget.groupListData!.id.toString()).createAnnouncement(title: title,description: description);
          if(announcementData != null){
            Navigator.pop(context);
            listAnnouncementData.add(announcementData);
          }else{
            Navigator.pop(context);
          }
        }else{
          Navigator.pop(context);
          showNoConnectionToast(context);
        }
      }catch(e){
        print(e.toString());
      }
    setState((){
    });

  }
  getAnnouncement()async{
    final bool isConnected = await InternetConnectionChecker().hasConnection;
      try{
        if(isConnected){
          listAnnouncementData = await GroupManagementController(groupId: widget.groupListData!.id.toString()).getAnnouncement();
          if(listAnnouncementData.isNotEmpty){
          }else{
          }
        }else{
          showNoConnectionToast(context);
        }
      }catch(e){
        print(e.toString());
      }

    setState((){
      progressCodeAnnouncement = false;
    });

  }

  updateAnnouncement({String title = '',String description = '',int index = 0,String aId = ''}) async {
   try{
     final bool isConnected = await InternetConnectionChecker().hasConnection;
     if(isConnected){
       AnnouncementData? announcementData = await GroupManagementController(groupId: widget.groupListData!.id.toString()).updateAnnouncement(title: title,description: description,id: aId);
       if(announcementData != null){
         listAnnouncementData.removeAt(index);
         listAnnouncementData.insert(index, announcementData);
         Navigator.pop(context);
       }else{
         Navigator.pop(context);
       }
     }else{
       Navigator.pop(context);
       showNoConnectionToast(context);
     }
   }catch(e){
     Navigator.pop(context);
     print(e.toString());
   }
    setState((){

    });
  }

  deleteAnnouncement(String aId) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).deleteAnnouncement(aId)){
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
      }
    }else{
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  attachDoc() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image,withData: true);
    if(result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      // List<PlatformFile> listFiles = result.files;
      print(files.first.path);
      if(files.isNotEmpty){
        for(int i = 0; i< files.length; i++){
          listFiles.add(files[i]);
        }
      }
      if(listFiles.isNotEmpty){
        for(int i = 0; i < listFiles.length; i++){
          base64Images.add(base64Encode(listFiles.first.readAsBytesSync()));
        }
      }


      setState(() {

      });
    } else {
      // User canceled the picker
    }
  }

  Widget _previewImage(StateSetter stateSetter) {

    if (listFiles.isNotEmpty) {
          return GestureDetector(
            onTap: ()async {
             await  attachDoc();

             stateSetter(() {

             });
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
                    children:listFiles.map<Widget>( (_imageFiles) {
                      return  Stack(
                        children: [
                          Semantics(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                  child:displayLocalImage( _imageFiles.path,radius: 10,height: 100,width: appWidth(context))
                              ),
                              label: 'image_picker_example_picked_image'
                          ),

                          Positioned(
                            left: 0,
                              child: IconButton(icon: Icon(Icons.cancel,color: Colors.red,size: 30,), onPressed: ()async{
                             listFiles.remove(_imageFiles);
                            stateSetter(() {

                            });
                          }))
                        ],
                      );
                    }).toList()),
              ),
            ),
          );

    } else {
      return  MaterialButton(
        onPressed: ()async{
          await attachDoc();
          stateSetter(() {

          });
        },
        child: Container(
            child: Image.asset("assets/images/upload_images.png")
        ),
      );
    }
  }

  @override
 void initState(){
    getGroupPageView();
    getAnnouncement();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color:  Color(0XFF2D3E50),)),
        title:    Text(
          widget.groupListData!.name!,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color:  Color(0XFF2D3E50),
              height: 1.1,
              fontFamily: "Poppins"
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            groupActionsModalBottomSheet(context);
          }, icon: Icon(Icons.more_vert, color: Colors.black))
        ],
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText(widget.groupListData!.uid!,color: Color(0xFF2A9CEA),weight: FontWeight.w500,align: TextAlign.center,size: 25),
            ),
          ),

          SizedBox(height: 40,),
          listGroupViewData.isNotEmpty ?
          Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index){
                  if(index == 0){
                    return Column(
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
                              child: sText("Admins",weight: FontWeight.w500,size: 16),
                            ) ,
                            trailing:  Container(
                              child: Icon(Icons.add_circle_outline,color: Colors.black,),
                            ),
                            title: Container()  ,
                            children: <Widget>[
                              if(listGroupViewData[0].admins!.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    children: [
                                      for(int i = 0; i< listGroupViewData[0].admins!.length; i++)
                                        MaterialButton(
                                          padding: EdgeInsets.zero,

                                          onPressed: (){
                                            memberActionsModalBottomSheet(context,listGroupViewData[0].admins![i].id.toString(),false);

                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      displayLocalImage("filePath",radius: 30),
                                                      Positioned(
                                                        bottom: 5,
                                                        right: 0,
                                                        child: Image.asset("assets/images/tick-mark.png"),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      sText(listGroupViewData[0].admins![i].name,color: Colors.black,weight: FontWeight.w500),
                                                      SizedBox(height: 5,),
                                                      sText("Admin",color: kAdeoGray3,size: 12),
                                                    ],
                                                  ),
                                                  Expanded(child: Container()),
                                                  Icon(Icons.arrow_forward_ios,color: kAdeoGray3,size: 16,)
                                                ],
                                              ),
                                              SizedBox(height: 10,)
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
                    );
                  }
                  else if(index == 1){
                    return Column(
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
                            leading:   Container(
                            child: sText("Members",weight: FontWeight.w500,size: 16),
                             ) ,
                            trailing:  Container(
                              child: Icon(Icons.add_circle_outline,color: Colors.black,),
                            ),
                            title: Container()  ,
                            children: <Widget>[
                              if(listGroupViewData[0].members!.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          for(int i = 0; i< listGroupViewData[0].members!.length; i++)
                                            MaterialButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: (){
                                                memberActionsModalBottomSheet(context,listGroupViewData[0].members![i].id.toString(),true);
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          displayLocalImage("filePath",radius: 30),
                                                          Positioned(
                                                            bottom: 5,
                                                            right: 0,
                                                            child: Image.asset("assets/images/tick-mark.png"),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          sText(listGroupViewData[0].members![i].name,color: Colors.black,weight: FontWeight.w500),
                                                          SizedBox(height: 5,),
                                                          sText("${listGroupViewData[0].members![i].testCount} Tests",color: kAdeoGray3,size: 12),
                                                        ],
                                                      ),
                                                      Expanded(child: Container()),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          sText("${listGroupViewData[0].members![i].testPercent}",color: Colors.black,weight: FontWeight.w500),
                                                          SizedBox(height: 5,),
                                                          sText("${listGroupViewData[0].members![i].testGrade == null ? "No Grade" : listGroupViewData[0].members![i].testGrade}",color: kAdeoGray3,size: 12),
                                                        ],
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Icon(Icons.arrow_forward_ios,color: kAdeoGray3,size: 16,)
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  listGroupViewData[0].members!.length -1 != i ?
                                                  Column(
                                                    children: [
                                                      Divider(color: kAdeoGray,height: 1,),
                                                      SizedBox(height: 10,),
                                                    ],
                                                  ) : Container(),
                                                ],
                                              ),
                                            ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                      ],
                    );
                  }
                  else   if(index == 2){
                    return Column(
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
                              child: sText("Pending Invites",weight: FontWeight.w500,size: 16),
                            ),
                            trailing:  Container(
                              child: Icon(Icons.add_circle_outline,color: Colors.black,),
                            ),
                            title: Container()  ,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Column(
                                  children: [
                                    for(int i = 0; i< listGroupViewData[0].pendingInvites!.length; i++)
                                      MaterialButton(
                                        onPressed: (){
                                          showRevokeDialog(context: context,message: "Are you sure you want to revoke this invite",userId: listGroupViewData[0].pendingInvites![i].id.toString());
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    sText(listGroupViewData[0].pendingInvites![i].email,color: Colors.black,weight: FontWeight.w500),
                                                    SizedBox(height: 5,),
                                                    sText("10 days ago",color: kAdeoGray3,size: 12),
                                                  ],
                                                ),
                                                Expanded(child: Container()),
                                                Icon(Icons.horizontal_rule,color: Colors.red,size: 25,)
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            listMembers.length -1 != i ?
                                            Column(
                                              children: [
                                                Divider(color: kAdeoGray,height: 1,),
                                                SizedBox(height: 10,),
                                              ],
                                            ) : Container(),

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
                    );
                  }
                  else  if(index == 3){
                    return Column(
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
                              child: sText("Announcements",weight: FontWeight.w500,size: 16),
                            ),

                            trailing:  Container(
                              child: Icon(Icons.add_circle_outline,color: Colors.black,),
                            ),

                            title: Container()  ,
                            children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                announcementModalBottomSheet(context);
                              },
                              child: Container(
                                child:  sText("New Announcements",weight: FontWeight.w500,size: 16,align: TextAlign.center),
                                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F7FF),
                                  border: Border.all(color: Color(0XFF489CFF)),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                            ),
                                SizedBox(height: 20,),
                             listAnnouncementData.isNotEmpty ?
                                Column(
                                  children: [
                                    for(int i = 0; i< listAnnouncementData.length; i++)
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            margin: EdgeInsets.symmetric(horizontal: 20),
                                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),

                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                   sText("Victor Adatsi",color: Colors.black,weight: FontWeight.bold),
                                                   sText(" (group admin)",color: kAdeoGray2),
                                                    Expanded(child: Container()),
                                                    Icon(Icons.arrow_forward_ios,color: kAdeoGray3,size: 16,)
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                sText( "${StringExtension.displayTimeAgoFromTimestamp(listAnnouncementData[i].createdAt.toString())} ago",color: kAdeoGray2),
                                                SizedBox(height: 10,),
                                                Container(
                                                  child:sText(listAnnouncementData[i].title,color: kAdeoGray3,weight: FontWeight.w500),
                                                ),
                                                SizedBox(height: 10,),
                                                if(listAnnouncementData[i].resources!.isNotEmpty)
                                                  Column(
                                                    children: [
                                                      CarouselSlider.builder(
                                                          options: CarouselOptions(
                                                            height: 200,
                                                            autoPlay: false,
                                                            enableInfiniteScroll: false,
                                                            autoPlayAnimationDuration: Duration(seconds: 1),
                                                            enlargeCenterPage: false,
                                                            viewportFraction: 1,
                                                            aspectRatio: 2.0,
                                                            pageSnapping: true,
                                                            onPageChanged: (index, reason) {
                                                              setState(() {
                                                                _currentSlide = index;
                                                              });
                                                            },
                                                          ),
                                                          itemCount: listAnnouncementData[i].resources!.length,
                                                          itemBuilder: (BuildContext context, int index, int index2) {
                                                            return ClipRRect(
                                                              borderRadius: BorderRadius.circular(20),
                                                              child: Container(
                                                                child: displayImage(listAnnouncementData[i].resources![index].url,radius: 0,height: 200,width: appWidth(context),),
                                                              ),
                                                            );
                                                          }),
                                                      SizedBox(height: 10,),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: map<Widget>(listAnnouncementData[i].resources!.length, (index, url) {
                                                            return Container(
                                                              width: 25,
                                                              height: 3,
                                                              margin: EdgeInsets.only(right: 5),
                                                              decoration: BoxDecoration(color: _currentSlide == index ?  Color(0xFF2A9CEA) : sGray),
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                              ],
                                            ),
                                          ),
                                          listAnnouncementData.length -1 != i ?
                                          SizedBox(height: 10,child: Container(color: kHomeBackgroundColor,),): Container(),
                                        ],
                                      ),


                                  ],
                                ) : Center(child:sText("You've no announcement") ,),
                            ],
                          ),
                        ),

                      ],
                    );
                  }else{
                    return Column(
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
                            leading:  Container(
                              child: sText("Tests",weight: FontWeight.w500,size: 16),
                            ),
                            trailing:  Container(
                              child: Icon(Icons.add_circle_outline,color: Colors.black,),
                            ),
                            title: Container()  ,
                            children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                 goTo(context, TestCreation());
                                },
                                child: Container(
                                  child:  sText("New Test",weight: FontWeight.w500,size: 16,align: TextAlign.center),
                                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: Color(0XFFF0F7FF),
                                      border: Border.all(color: Color(0XFF489CFF)),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              if(listGroupViewData[0].admins!.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    children: [
                                      for(int i = 0; i< listGroupViewData[0].admins!.length; i++)
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    displayLocalImage("filePath",radius: 30),
                                                    Positioned(
                                                      bottom: 5,
                                                      right: 0,
                                                      child: Image.asset("assets/images/tick-mark.png"),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 10,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    sText(listGroupViewData[0].admins![i].name,color: Colors.black,weight: FontWeight.w500),
                                                    SizedBox(height: 5,),
                                                    sText("Admin",color: kAdeoGray3,size: 12),
                                                  ],
                                                ),
                                                Expanded(child: Container()),
                                                Icon(Icons.arrow_forward_ios,color: kAdeoGray3,size: 16,)
                                              ],
                                            ),
                                            SizedBox(height: 10,)
                                          ],
                                        ),

                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                      ],
                    );
                  }

            }),
          ) : progressCode ? Expanded(child: Center(child: progress())) : Expanded(child: Center(child: sText("Group does not exist")))

        ],
      ),
    );
  }
}

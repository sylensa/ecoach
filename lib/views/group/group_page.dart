import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_page_view_model.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/commission/commission_agent_page.dart';
import 'package:ecoach/views/group/group_list.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
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

  memberActionsModalBottomSheet(context,String userId){
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
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: sText("Remove member",color: kAdeoGray3,align: TextAlign.center),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: sText("Suspend member",color: kAdeoGray3,align: TextAlign.center),
                              ),
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
                              ),
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
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: sText("Delete Group",color: kAdeoGray3,align: TextAlign.center),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: sText("Suspend Group",color: kAdeoGray3,align: TextAlign.center),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: sText("Make member an admin",color: kAdeoGray3,align: TextAlign.center),
                              ),
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
    listGroupViewData.clear();
    try{
      var js = await doGet('${AppUrl.groups}/${widget.groupListData!.id}');
      print("res groups view : $js");
      if (js["code"].toString() == "200" && js["data"].isNotEmpty) {
        GroupViewData groupViewData = GroupViewData.fromJson(js["data"]);
        listGroupViewData.add(groupViewData);
      }else{
        toastMessage("${js["message"]}");
      }
    }catch(e){
      Navigator.pop(context);
      toastMessage("Failed");
    }

    setState((){
      progressCode = false;
    });

  }
  suspendUser(String userId) async {
    var res = await doPost(AppUrl.suspendGroupMember, {
      "group_id": widget.groupListData!.id,
      "user_id": userId,
    });
    if(res["status"]){
      Navigator.pop(context);
     toastMessage(res["message"]);
    }else{
      Navigator.pop(context);
      toastMessage(res["message"]);
    }
  }
  unSuspendUser(String userId) async {
    var res = await doPost(AppUrl.unSuspendGroupMember, {
      "group_id": widget.groupListData!.id,
      "user_id": userId,
    });
    if(res["status"]){
      Navigator.pop(context);
      toastMessage(res["message"]);
    }else{
      Navigator.pop(context);
      toastMessage(res["message"]);
    }
  }
  makeUserAdmin(String userId) async {
    var res = await doPost(AppUrl.makeMemberAdmin, {
      "group_id": widget.groupListData!.id,
      "user_id": userId,
    });
    if(res["status"]){
      await getGroupPageView();
      Navigator.pop(context);
      toastMessage(res["message"]);
    }else{
      Navigator.pop(context);
      toastMessage(res["message"]);
    }
  }
  makeUserParticipant(String userId) async {
    var res = await doPost(AppUrl.makeMemberParticipant, {
      "group_id": widget.groupListData!.id,
      "user_id": userId,
    });
    if(res["status"]){
      Navigator.pop(context);
      toastMessage(res["message"]);
    }else{
      Navigator.pop(context);
      toastMessage(res["message"]);
    }
  }
  removeUser(String userId) async {
    var res = await doPost(AppUrl.removeMember, {
      "group_id": widget.groupListData!.id,
      "user_id": userId,
    });
    if(res["status"]){
      Navigator.pop(context);
      toastMessage(res["message"]);
    }else{
      Navigator.pop(context);
      toastMessage(res["message"]);
    }
  }


  @override
 void initState(){
    getGroupPageView();
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
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Admins",weight: FontWeight.w500,size: 16),
                              ),
                              Container(
                                child: Icon(Icons.add_circle_outline,color: Colors.black,),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),

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
                    );
                  }
                  else if(index == 1){
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.only(top: 20),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Members",weight: FontWeight.w500,size: 16),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(listActivePackageData[0].maxParticipants! == listMembers.length){
                                    showDialogOk(message: "You have reached your limit, to add more members upgrade your package",context: context);
                                  }else{
                                    inviteModalBottomSheet(context);
                                  }
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline,color: Colors.black,),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
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
                                        memberActionsModalBottomSheet(context,listGroupViewData[0].members![i].id.toString());
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
                    );
                  }
                  else   if(index == 2){
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Pending Invites",weight: FontWeight.w500,size: 16),
                              ),
                              Container(
                                child: Icon(Icons.add_circle_outline,color: Colors.black,),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),

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
                                Column(
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

                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  else  if(index == 3){
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Announcements",weight: FontWeight.w500,size: 16),
                              ),
                              Container(
                                child: Icon(Icons.add_circle_outline,color: Colors.black,),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
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
                    );
                  }else{
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Tests",weight: FontWeight.w500,size: 16),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(listActivePackageData[0].maxTests! == listMembers.length){
                                    showDialogOk(message: "You have reached your limit, to add more test upgrade your package",context: context);
                                  }
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline,color: Colors.black,),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
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
                    );
                  }

            }),
          ) : progressCode ? Expanded(child: Center(child: progress())) : Expanded(child: Center(child: sText("Group does not exist")))

        ],
      ),
    );
  }
}

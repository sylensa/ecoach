import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/commission/commission_agent_page.dart';
import 'package:ecoach/views/group_main_page.dart';
import 'package:ecoach/views/group/group_list.dart';
import 'package:ecoach/views/group/group_page.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class EmptyGroupMembers extends StatefulWidget {
  GroupListData? groupListData;
   EmptyGroupMembers({this.groupListData}) ;

  @override
  State<EmptyGroupMembers> createState() => _EmptyGroupMembersState();
}

class _EmptyGroupMembersState extends State<EmptyGroupMembers> {

  inviteToGroup(String email) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected){
      try{
        if(await GroupManagementController(groupId: widget.groupListData!.id.toString()).inviteToGroup(email)){
          Navigator.pop(context);
          goTo(context, GroupPage(groupListData:widget.groupListData));
        }else{
          Navigator.pop(context);
        }
      }catch(e){
        Navigator.pop(context);
        print("error:$e");
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color:  Color(0XFF2D3E50),)),
        title:    Text(
          properCase(widget.groupListData!.name!),
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
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: sText("${widget.groupListData!.uid!}",color: Color(0xFF2A9CEA),weight: FontWeight.w500,align: TextAlign.center,size: 25),
              ),
              SizedBox(height: 100,),
              Container(
                width: appWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                        text: 'Your group has ',
                        style: appStyle(col: kAdeoGray3,),
                        children: <InlineSpan>[
                          TextSpan(
                            text:'NO',
                            style: appStyle(col: Colors.black,weight: FontWeight.bold),

                          ),
                          TextSpan(
                            text:' members.',
                            style: appStyle(col: kAdeoGray3),

                          )
                        ]
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: sText("Add members and assign roles",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
              ),
              SizedBox(height: 20,),
              Image.asset("assets/images/people.png",),
              SizedBox(height: 100,),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: sText("Add users by inviting them to join your group",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: (){
                      inviteModalBottomSheet(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF00C9B9),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 15),
                      child: sText("Invite Users",color: Colors.white,weight: FontWeight.w400,align: TextAlign.center,size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),


        ],
      ),
    );
  }
}

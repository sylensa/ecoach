import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group/empty_group_memebers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  bool switchOn = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kHomeBackgroundColor,

        appBar: AppBar(
          backgroundColor: kHomeBackgroundColor,
          elevation: 0,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color:  Color(0XFF2D3E50),)),
          title:    Text("Create group",
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

          centerTitle: false,
        ),
        body: Container(
          child: Column(
            children: [
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
                              controller: groupNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please check that you\'ve entered group email';
                                }
                                return null;
                              },

                              decoration: textDecorNoBorder(
                                radius: 10,
                                labelText: "Name",
                                hintColor: kAdeoGray3,
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
                              controller: groupDescriptionController,
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: sText("Discoverability",color: kAdeoGray3,size: 16),
                          ),
                          FlutterSwitch(
                            width: 50.0,
                            height: 20.0,
                            valueFontSize: 10.0,
                            toggleSize: 15.0,
                            value: switchOn,
                            borderRadius: 30.0,
                            padding: 2.0,
                            showOnOff: false,
                            activeColor: Color(0xFF555555),
                            inactiveColor: Color(0xFFD1D1D1),
                            inactiveTextColor: Colors.red,
                            inactiveToggleColor: Color(0xFF555555),

                            onToggle: (val) {
                              setState(() {
                                switchOn = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),

                      child: sText("Who can join this group",color: kAdeoGray3,size: 16),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sText("Anyone",color: kAdeoGray3,size: 16),
                          Container(
                            padding: EdgeInsets.all(2.0),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(64.0),
                              border: Border.all(
                                width: 2.0,
                                color: Color(0xFF00C9B9),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 32.0,
                              backgroundColor:   Color(0xFF00C9B9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          sText("Only Invited members",color: kAdeoGray3,size: 16),
                          Container(
                            padding: EdgeInsets.all(2.0),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(64.0),
                              border: Border.all(
                                width: 2.0,
                                color: Color(0xFF00C9B9),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 32.0,
                              backgroundColor:   Color(0xFF00C9B9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  goTo(context, EmptyGroupMembers());
                },
                child: Container(
                  width: appWidth(context),
                  color: Color(0xFF00C9B9),
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                  child: sText("Create Group",color: Colors.white,weight: FontWeight.w500,align: TextAlign.center,size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

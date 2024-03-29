import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group_management/empty_group_memebers.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ListNames> listLevels = [ListNames(name: "Lower Primary",id: "1"),ListNames(name: "Upper Primary",id: "2",),ListNames(name: "Junior High",id: "3"),ListNames(name: "Senior High",id: "4")];
  ListNames? level;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  bool switchOn = false;
  bool status = false;
  createGroup() async {
    var res = await doPost(AppUrl.groups, {
      "name": groupNameController.text,
      "description": groupDescriptionController.text,
      "type": switchOn ? "Public" : "Private",
      "discoverability": switchOn,
      "category": level!.name
    });
    Navigator.pop(context);
    // return;
    if (res["status"]) {
      GroupListData groupListData = GroupListData.fromJson(res["data"]);
      listGroupListData.add(groupListData);
      Navigator.pop(context);
      goTo(
          context,
          EmptyGroupMembers(
            groupListData: groupListData,
          ),
          replace: true);
    } else {
      Navigator.pop(context);
      toastMessage(res["message"]);
    }
  }

  @override
  void initState(){
    level = listLevels[0];
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kHomeBackgroundColor,
        appBar: AppBar(
          backgroundColor: kHomeBackgroundColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Color(0XFF2D3E50),
              )),
          title: Text(
            "Create groups",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0XFF2D3E50),
                height: 1.1,
                fontFamily: "Poppins"),
          ),
          centerTitle: false,
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              // autofocus: true,
                              controller: groupNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please check that you\'ve entered group_management email';
                                }
                                return null;
                              },
                              decoration: textDecorNoBorder(
                                radius: 10,
                                labelText: "Name",
                                hintColor: Color(0xFFB9B9B9),
                                borderColor: Colors.white,
                                fill: Colors.white,
                                padding: EdgeInsets.only(left: 10, right: 10),
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
                                hintColor: Color(0xFFB9B9B9),
                                borderColor: Colors.white,
                                fill: Colors.white,
                                padding: EdgeInsets.only(left: 10, right: 10),
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
                      padding: EdgeInsets.only(left: 20,right:20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sText("Category",color: kAdeoGray3),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.only(left: 12, right: 20),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<ListNames>(
                                  value: level ?? listLevels[0],
                                  itemHeight: 60,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kDefaultBlack,
                                  ),
                                  onChanged: (ListNames? value){
                                    setState((){
                                      level = value;
                                    });
                                  },
                                  items: listLevels.map(
                                        (item) => DropdownMenuItem<ListNames>(
                                      value: item,
                                      child: Text(
                                        item.name,
                                        style: TextStyle(
                                          color: kDefaultBlack,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: sText("Discoverability",
                                color: kAdeoGray3, size: 16),
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
                                if(switchOn){
                                  status = true;
                                }else{
                                  status = false;
                                }

                                print(switchOn);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: sText("Who can join this group",
                          color: kAdeoGray3, size: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if(switchOn)
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          status = true;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sText("Anyone", color: kAdeoGray3, size: 16),
                            status
                                ? Container(
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
                                      backgroundColor: Color(0xFF00C9B9),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          status = false;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sText("Only Invited members",
                                color: kAdeoGray3, size: 16),
                            !status
                                ? Container(
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
                                      backgroundColor: Color(0xFF00C9B9),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showLoaderDialog(context);
                  createGroup();
                  // goTo(context, EmptyGroupMembers());
                },
                child: Container(
                  width: appWidth(context),
                  color: Color(0xFF00C9B9),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: sText("Create Group",
                      color: Colors.white,
                      weight: FontWeight.w500,
                      align: TextAlign.center,
                      size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

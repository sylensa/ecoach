import 'dart:io';

import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/group_page_view_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/revamp/features/payment/views/screens/preparing_download.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group/create_group.dart';
import 'package:ecoach/views/group/group_page.dart';
import 'package:ecoach/views/group/group_profile.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupListPage extends StatefulWidget {



  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
bool progressCode = false;


  @override
  void initState() {
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
        title:    Text("Group Management",
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
      body: Container(
        child: Column(
          children: [

            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: sText("Pro Editor",color: Color(0xFF2A9CEA),weight: FontWeight.bold,align: TextAlign.center,size: 25),
                ),
                SizedBox(height: 0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: sText("Validity : ${listActivePackageData[0].validity}",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                ),
              ],
            ),
            SizedBox(height: 40,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child:  Container(
                      width: 100,
                      child: Text(
                        "Name",
                        softWrap: true,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child:  Text(
                      "Expiry",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                        height: 1.1,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child:  Text(
                      "Members",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            listGroupListData.isNotEmpty ?
            Expanded(
              flex: 8,
              child: ListView.builder(
                  itemCount: listGroupListData.length,
                  itemBuilder: (BuildContext context, int index){
                    return  GestureDetector(
                      onTap: (){
                        goTo(context, GroupPage(groupListData:listGroupListData[index]));

                        // goTo(context, GroupProfilePage());
                      },
                      child: Card(
                          color: Colors.white,
                          margin: bottomPadding(10),
                          elevation: 0,
                          child: ListTile(
                            title:  Container(
                              width: 100,
                              child: sText("${listActivePackageData[0].createdAt!.difference(listGroupListData[index].dateCreated!).inDays > 365 ? "365" : listGroupListData[index].dateCreated!.difference(DateTime.now()).inDays.toString()} days",color: Colors.black,weight: FontWeight.w600,align: TextAlign.center),

                            ),

                            leading: Container(
                              width: 100,
                              child: sText("${listGroupListData[index].name}",color: Colors.black,weight: FontWeight.w600,align: TextAlign.center),
                            ),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: [
                                  Text(
                                    "${listGroupListData[index].membersCount} members",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color:  Color(0XFF2D3E50),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios,size: 15,)
                                ],
                              ),
                            ),
                          )),
                    );
                  }),
            ) :
            Expanded(child: Center(child: sText("Empty group",weight: FontWeight.bold),)),

            GestureDetector(
              onTap:(){
                if(listActivePackageData[0].maxGroups! == listGroupListData.length){
                  showDialogOk(message: "You have reached your limit, to create more groups upgrade your package",context: context);
                }else{
                  goTo(context, CreateGroup());
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
                decoration: BoxDecoration(
                    color: Color(0xFFddfffc),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/add.png"),
                    SizedBox(width: 20,),
                    Text(
                      "Create Group",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C9B9),
                          height: 1.1,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

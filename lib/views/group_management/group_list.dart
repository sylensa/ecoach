import 'dart:io';

import 'package:custom_floating_action_button/custom_floating_action_button.dart';
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
import 'package:ecoach/views/group_management/create_group.dart';
import 'package:ecoach/views/group_management/group_page.dart';
import 'package:ecoach/views/group_management/group_profile.dart';
import 'package:ecoach/views/group_management/not_content_editor.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GroupListPage extends StatefulWidget {



  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
bool progressCode = false;
bool enableButtonPress = false;
late String generatedLink = '';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
authorisePayment(BuildContext context, int packageId) async {
  var res = await doPost(AppUrl.groupPackagesPaymentInitialization, {
    "group_package_id": packageId,
  });
  if (res["status"]) {
    Navigator.pop(_scaffoldKey.currentContext!);
    generatedLink = res["data"]["authorization_url"];
    paymentPage(generatedLink);
  } else {
    Navigator.pop(_scaffoldKey.currentContext!);
    toastMessage(res["message"]);
  }
}

paymentPage(String authorizationUrl) {
  showDialog(
    context: _scaffoldKey.currentContext!,
    builder: (context) {
      return WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: authorizationUrl,
        navigationDelegate: (navigation) async {
          //Listen for callback URL
          if (navigation.url.contains('https://standard.paystack.co/close')) {
            print("hey:");
            Navigator.of(context).pop(); //close webview
          }
          if (navigation.url.contains(AppUrl.payment_callback)) {
            Navigator.of(context).pop();
            showLoaderDialog(context);
            await getActivePackage();
            //close webview
            setState(() {
              print("hello adolf:");
            });
          }
          return NavigationDecision.navigate;
        },
      );
    },
  );
}

upgradePackageModalBottomSheet(
    context,
    ) {
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
                          child: sText("Upgrade Packages",
                              weight: FontWeight.bold,
                              size: 20,
                              align: TextAlign.center)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: sText("Select Your Preferred Upgrade",
                          color: kAdeoGray3,
                          weight: FontWeight.w400,
                          align: TextAlign.center),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: listGroupPackageData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showLoaderDialog(context);
                                  authorisePayment(context,
                                      listGroupPackageData[index].id!);
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
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      sText(listGroupPackageData[index].name,
                                          color: kAdeoGray3),
                                      sText(
                                          "GHS ${listGroupPackageData[index].price}",
                                          color: Colors.black,
                                          weight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ));
          },
        );
      });
}

getGroupList() async {
  final bool isConnected = await InternetConnectionChecker().hasConnection;
  if (isConnected) {
    listGroupListData.clear();
    try {
      listGroupListData = await groupManagementController.getGroupList();
      Navigator.pop(context);
      setState((){
      });
    } catch (e) {
      Navigator.pop(context);
      toastMessage("Failed");
    }
  } else {
    Navigator.pop(context);
    showNoConnectionToast(context);
  }
}

getActivePackage() async {
  listActivePackageData.clear();
  final bool isConnected = await InternetConnectionChecker().hasConnection;
  if (isConnected) {
    try {
      listActivePackageData = await groupManagementController.getActivePackage();
      if (listActivePackageData.isNotEmpty) {
        await getGroupList();
      } else {
        Navigator.pop(context);
        goTo(context, NotContentEditor());
      }
    } catch (e) {
      Navigator.pop(context);
      toastMessage("Failed");
    }
  } else {
    Navigator.pop(context);
    showNoConnectionToast(context);
  }
}
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      body: Scaffold(
        key: _scaffoldKey,
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
          actions: [
            IconButton(
                onPressed: () {
                },
                icon: Icon(Icons.more_vert, color: Colors.black))
          ],
        ),
        body: Container(
          child: Column(
            children: [

              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: sText("${listActivePackageData[0].name}",color: Color(0xFF2A9CEA),weight: FontWeight.bold,align: TextAlign.center,size: 25),
                  ),
                  SizedBox(height: 0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: sText("Validity:",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: sText(listActivePackageData[0].endAt != null ? "${DateTime.parse(listActivePackageData[0].endAt!).difference(DateTime.now()).inDays > 365 ? "365" : DateTime.parse(listActivePackageData[0].endAt!).difference(DateTime.now()).inDays.toString()} days" : "No Expiration",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
                      ),
                    ],
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
                        onTap: ()async{
                        var res =  await goTo(context, GroupPage(groupListData:listGroupListData[index]));
                        if(res != null){
                          setState((){
                            listGroupListData[index] = res;
                          });
                        }else{
                          setState((){
                          });
                        }

                        },
                        child: Card(
                            color: Colors.white,
                            margin: bottomPadding(10),
                            elevation: 0,
                            child: ListTile(
                              title:  Container(
                                width: 100,
                                child: sText( listActivePackageData[0].endAt != null ? "${DateTime.parse(listActivePackageData[0].endAt!).difference(listGroupListData[index].dateCreated!).inDays > 365 ? "365" : DateTime.parse(listActivePackageData[0].endAt!).difference(DateTime.now()).inDays.toString()} days" : "No Expiration",color: Colors.black,weight: FontWeight.w600,align: TextAlign.center),

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

              // GestureDetector(
              //   onTap:(){
              //     if(listActivePackageData[0].maxGroups! == listGroupListData.length){
              //       showDialogOk(message: "You have reached your limit, to create more groups upgrade your package",context: context);
              //     }else{
              //       goTo(context, CreateGroup());
              //     }
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 20),
              //     margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
              //     decoration: BoxDecoration(
              //         color: Color(0xFFddfffc),
              //         borderRadius: BorderRadius.circular(10)
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset("assets/images/add.png"),
              //         SizedBox(width: 20,),
              //         Text(
              //           "Create Group",
              //           softWrap: true,
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //               fontSize: 18.0,
              //               fontWeight: FontWeight.bold,
              //               color: Color(0xFF00C9B9),
              //               height: 1.1,
              //               fontFamily: "Poppins"
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        // floatingActionButton:
        // enableButtonPress ?
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     MaterialButton(
        //       onPressed: (){
        //         if(listActivePackageData[0].maxGroups! == listGroupListData.length){
        //           showDialogOk(message: "You have reached your limit, to create more groups upgrade your package",context: context);
        //         }else{
        //           goTo(context, CreateGroup());
        //         }
        //       },
        //         child: Image.asset("assets/images/add.png"),
        //     ),
        //     SizedBox(height: 10,),
        //     MaterialButton(
        //       onPressed: (){
        //         upgradePackageModalBottomSheet(_scaffoldKey.currentContext);
        //       },
        //         child: Image.asset("assets/images/system-update.png"),
        //     ),
        //     SizedBox(height: 10,),
        //     Image.asset("assets/images/delete.png"),
        //     SizedBox(height: 10,),
        //     Container(
        //       decoration: BoxDecoration(
        //         color: Colors.black,
        //         shape: BoxShape.circle
        //       ),
        //       child: IconButton(
        //           onPressed: (){
        //             setState((){
        //               enableButtonPress = false;
        //             });
        //       }, icon: Icon(Icons.horizontal_rule,color: Colors.white,)),
        //     ),
        //
        //   ],
        // ) :
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //           color: Colors.black,
        //           shape: BoxShape.circle
        //       ),
        //       child: IconButton(
        //           onPressed: (){
        //             setState((){
        //               enableButtonPress = true;
        //             });
        //           }, icon: Icon(Icons.add,color: Colors.white,)),
        //     ),
        //
        //   ],
        // ) ,
      ),
      options:  [
        GestureDetector(
          onTap: (){
            if(listActivePackageData[0].maxGroups! == listGroupListData.length){
              showDialogOk(message: "You have reached your limit, to create more groups upgrade your package",context: context);
            }else{
              goTo(context, CreateGroup());
            }
          },
          child: Image.asset("assets/images/add.png"),
        ),
        GestureDetector(
          onTap: (){
            upgradePackageModalBottomSheet(_scaffoldKey.currentContext);
          },
          child: Image.asset("assets/images/system-update.png"),
        ),
        GestureDetector(
          onTap: (){},
            child: Image.asset("assets/images/delete.png"),
        ),

      ],
      floatinButtonColor: Colors.black,
      spaceFromBottom: 40,
      type: CustomFloatingActionButtonType.verticalUp,
      openFloatingActionButton: const Icon(Icons.add,color: Colors.white,),
      closeFloatingActionButton: const Icon(Icons.horizontal_rule,color: Colors.white,),
    );
  }

}

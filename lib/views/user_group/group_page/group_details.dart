import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/models/user_group_rating.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GroupDetails extends StatefulWidget {
  static const String routeName = '/user_group';
  GroupListData? groupData;
  GroupDetails( {Key? key,this.groupData,}) : super(key: key);
  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  TextEditingController searchController = TextEditingController();
  List<GroupRatingData> listGroupRatingData = [];
  bool progressCode = true;
  getGroupDetails() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      widget.groupData = await GroupManagementController(groupId: widget.groupData!.id.toString()).getGroupDetails();
    } else {
      showNoConnectionToast(context);
    }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
    });
  }
  getGroupReviews() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      listGroupRatingData = await GroupManagementController(groupId: widget.groupData!.id.toString()).getReviewGroup();
    } else {
      showNoConnectionToast(context);
    }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
      progressCode = false;
    });
  }
  late String generatedLink = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  getMyGroups() async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      myGroupList = await GroupManagementController().getJoinGroupList();
      Navigator.pop(context);
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
  authorisePayment(BuildContext context, int groupId) async {
    var res = await doPost(AppUrl.groupSubscription, {
      "group_id": groupId,
    });
    print("res:$res");
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
              await getMyGroups();
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

  upgradePackageModalBottomSheet(context,) {
    double sheetHeight = 300;
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
                            child: sText("${widget.groupData!.description}",
                                weight: FontWeight.bold,
                                size: 20,
                                align: TextAlign.center)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Join Group",
                            color: kAdeoGray3,
                            weight: FontWeight.w400,
                            align: TextAlign.center),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
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
                            sText(widget.groupData!.name,
                                color: kAdeoGray3),
                            sText(
                                widget.groupData!.settings != null ?  "${widget.groupData!.settings!.currency} ${widget.groupData!.settings!.amount}" : "Free",
                                color: Colors.black,
                                weight: FontWeight.bold),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showLoaderDialog(context);
                    authorisePayment(context, widget.groupData!.id!);
                  },
                  child: Container(
                    width: appWidth(context),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    margin: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius:
                        BorderRadius.circular(10)),
                    child: sText("Join Now",color: Colors.white,weight: FontWeight.bold,align: TextAlign.center),
                  ),
                ),
                    ],
                  ));
            },
          );
        });
  }


  @override
 void initState(){
    super.initState();
    getGroupReviews();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h, right: 2.h),
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 3.h,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                           child: Icon(Icons.arrow_back,color: Colors.black,),
                       ),
                        GestureDetector(
                          onTap: ()async{
                            upgradePackageModalBottomSheet(_scaffoldKey.currentContext);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                            child: sText("JOIN",color: Colors.white,weight: FontWeight.bold),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("${widget.groupData!.name}",weight: FontWeight.w500,size: 20),
                      SizedBox(height: 0,),
                      sText("by ${widget.groupData!.owner != null  ? widget.groupData!.owner!.name : "No Owner"}",weight: FontWeight.w500,size: 12,color: Colors.grey),
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
                              child: sText("${widget.groupData!.membersCount}",size: 12,weight: FontWeight.bold,),
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
                              child: sText("${widget.groupData!.rating}",size: 10,weight: FontWeight.bold,),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              child: sText("(${widget.groupData!.reviews} reviews)",size: 10,weight: FontWeight.normal,),
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
                            widget.groupData!.settings != null ?
                            Container(
                              child: sText(widget.groupData!.settings!.access.toString() != "free" ? "${widget.groupData!.settings!.currency} ${widget.groupData!.settings!.amount}" : "Free",size: 12,weight: FontWeight.bold,),
                            ) :
                            Container(
                              child: sText("Free",size: 12,weight: FontWeight.bold,),
                            )
                            ,
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: kHomeBackgroundColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),)
                ),
                child: ListView(
                    padding:EdgeInsets.zero,
                  children: [
                     Container(
                       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             child: sText("Description",weight: FontWeight.bold,size: 16),
                           ),
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                             child: sText("${ widget.groupData!.description}",weight: FontWeight.normal,color: Colors.grey,align: TextAlign.left),
                           ),
                         ],
                       ),
                     ),

                    Divider(color: Colors.grey,),

                    SizedBox(height: 10,),
                    //features
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sText("Featured Reviews",size: 16,weight: FontWeight.bold),
                          sText("See all",size: 12,color: Colors.grey),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    listGroupRatingData.isNotEmpty ?
                    Container(
                      height: 170,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                          itemCount: listGroupRatingData.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index){
                            return Row(
                              children: [
                                Container(
                                  width: appWidth(context) * 0.7 ,
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey[200]!)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          displayImage("imagePath",radius: 20),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              sText("${listGroupRatingData[index].member!.name}"),
                                              Row(children: [
                                                for(int i =0; i < int.parse(listGroupRatingData[index].rating!); i++)
                                                Icon(Icons.star,color: Colors.yellow,size: 20,),

                                              ],),
                                              sText("${StringExtension.displayTimeAgoFromTimestamp(listGroupRatingData[index].createdAt.toString())}",size: 12,weight: FontWeight.w600),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        child: sText("${listGroupRatingData[index].review}",weight: FontWeight.normal,color: Colors.black,size: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            );
                          }),
                    ) : progressCode ? Container(height: 170,child: Center(child: progress(),),) : Container(height: 170,child: Center(child: sText("No review"),),) ,
                    // Divider(color: Colors.grey,),
                    // admin


                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child:  sText("Administrators",size: 16,weight: FontWeight.bold),
                    // ),
                    // SizedBox(height: 10,),
                    // Container(
                    //   width: appWidth(context) * 0.7 ,
                    //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    //
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           displayImage("imagePath",radius: 40),
                    //           SizedBox(width: 10,),
                    //           Container(
                    //             color: Colors.grey,
                    //             width: 1,
                    //             height: 80,
                    //           ),
                    //           SizedBox(width: 10,),
                    //           Expanded(
                    //             child: Container(
                    //               child: sText("Rev Shaddy is an experienced ICT Teacher who has over the years trained many student in preparing for their BECE exams.",weight: FontWeight.w500,color: Colors.grey,size: 14),
                    //             ),
                    //           ),
                    //         ],
                    //
                    //       ),
                    //
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 10,),
                    // Container(
                    //   height: 170,
                    //   margin: EdgeInsets.symmetric(horizontal: 20),
                    //
                    //   child: ListView.builder(
                    //       itemCount: 10,
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (BuildContext context, int index){
                    //         return Row(
                    //           children: [
                    //             Container(
                    //               width: appWidth(context) * 0.7 ,
                    //               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    //               decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   borderRadius: BorderRadius.circular(15),
                    //                   border: Border.all(color: Colors.grey[200]!)
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   Row(
                    //                     children: [
                    //                       displayImage("imagePath",radius: 20),
                    //                       SizedBox(width: 10,),
                    //                       Column(
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           sText("Victor Adatsi"),
                    //                           sText("2 Months",size: 12,weight: FontWeight.w600),
                    //                         ],
                    //                       )
                    //                     ],
                    //                   ),
                    //                   SizedBox(height: 10,),
                    //                   Container(
                    //                     child: sText("Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade.  Select your preferred upgrade.  Select your preferred upgrade.  Select your preferred upgrade.",weight: FontWeight.normal,color: Colors.black,size: 14),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(width: 10,),
                    //           ],
                    //         );
                    //       }),
                    // ),
                    Divider(color: Colors.grey,)
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

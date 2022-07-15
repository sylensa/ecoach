import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/controllers/subscribe_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/home/view/widgets/free_accessment_widget.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePageAnnex extends StatefulWidget {
  static const String routeName = '/home';
  final User user;
  Function? callback;
  final MainController controller;
  HomePageAnnex(
      this.user, {
        this.callback,
       required this.controller
      });

  @override
  State<HomePageAnnex> createState() => _HomePageAnnexState();
}

class _HomePageAnnexState extends State<HomePageAnnex> {
  SubscribeController subscribeController = Get.put(SubscribeController());
  var futureSubs;
  List<Plan> monthlyPlan = [];
  List<Plan> annuallyPlan = [];
  List<Bundle> bundleList = [];
  List<Subscription> subscriptions = [];
  uploadOfflineFlagQuestions()async{
    List<FlagData> results = await QuizDB().getAllFlagQuestions();
    if(results.isNotEmpty){
      for(int i =0; i < results.length; i++){
        FlagData flagData = await FlagData(reason: results[i].reason,type:results[i].type,questionId: results[i].questionId );
        await  QuizDB().saveOfflineFlagQuestion(flagData,flagData.questionId!);
      }
      List<FlagData> res = await QuizDB().getAllFlagQuestions();
      print("res len:${res.length}");
    }else{
      print("res len:${results.length}");

    }
  }
  getAllPlans() async{
    futurePlanItem =   await PlanDB().getAllPlans();
    if(futurePlanItem.isEmpty){
     await PlanController().getPlanOnly();
    }
    setState((){
    });
  }

  promoCodeModalBottomSheet(context,){
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 300;
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
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: sText(Platform.isAndroid ? "Enter your referral/discount code" : "Enter your referral code",weight: FontWeight.bold,size: 20,align: TextAlign.center)),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 40,),
                            Container(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      // autofocus: true,
                                      controller: productKeyController,
                                      // autofocus: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please check that you\'ve entered product key';
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        MaskedTextInputFormatter(mask: 'x-x-x-x-x-x'),
                                      ],
                                      textCapitalization: TextCapitalization.characters,
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
                                      textAlign: TextAlign.center,
                                      style: appStyle(weight: FontWeight.bold,size: 20),
                                      decoration: textDecorNoBorder(
                                        hintWeight: FontWeight.bold,

                                        hint: 'x-x-x-x-x-x',
                                        radius: 10,
                                        labelText: "Enter code",
                                        hintColor: Colors.black,
                                        borderColor: Colors.grey[400]!,
                                        fill: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40,),
                            GestureDetector(
                              onTap: ()async{
                                // Navigator.pop(context);
                                if(productKeyController.text.isNotEmpty && isActivated){
                                  stateSetter((){
                                    isActivated = false;
                                  });
                                  try{
                                    var res = await doPost(AppUrl.userPromoCodes, {'promo_code':productKeyController.text.replaceAll('-','')});
                                    print("res:$res");
                                    if(res["status"]){
                                     setState((){
                                       PromoCode promoCode = PromoCode.fromJson(res["data"]);
                                       widget.user.promoCode = promoCode;
                                       UserPreferences().setUser(widget.user);
                                     });
                                      Navigator.pop(context);
                                      showDialogOk(message: "You have ${res["data"]["discount"]} on all bundle purchase. The discount expires in ${res["data"]["validity_period"]}",context: context,dismiss: false,title: "${res["message"]}");
                                    }else{
                                      Navigator.pop(context);
                                      stateSetter((){
                                        isActivated = true;
                                      });
                                      showDialogOk(message: "${res["message"]}",context: context,dismiss: false);
                                    }
                                  }catch(e){
                                    Navigator.pop(context);
                                    stateSetter((){
                                      isActivated = true;
                                    });
                                    print("error:$e");
                                    showDialogOk(message: "Promo code is incorrect",context: context,dismiss: false);
                                  }
                                }else{
                                  toastMessage("Promo code is required");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sText("Apply code",color: Colors.white,align: TextAlign.center,weight: FontWeight.bold),
                                    SizedBox(width: 10,),
                                    isActivated ? Container() : progress()
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: isActivated ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
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

  isAlreadySubscribed(Plan plan){
    print("widget.user.subscriptions.length:${widget.user.subscriptions.length}");
    if(widget.user.subscriptions.isNotEmpty){
      for(int i = 0; i < widget.user.subscriptions.length; i++){
        if(widget.user.subscriptions[i].planId == plan.id){
          return  Text(
            Platform.isAndroid ? "Subscribed" : "Product Delivered",
            style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold

            ),
          );
        }
      }
      if(widget.user.promoCode != null){
        return    Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: Text(
                "${plan.currency} ${double.parse((plan.price! -  (widget.user.promoCode!.rate!  * plan.price!)).toStringAsFixed(2))}",
                style: TextStyle(
                    color: Color(0xFF2A9CEA),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            Container(
              child: Text(
                "${plan.currency} ${plan.price!.toStringAsFixed(2)}",
                style: TextStyle(
                    color: kAdeoGray3,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough
                ),
              ),
            ),
          ],
        );
      }
      else{
        return Text(
          "${plan.currency} ${plan.price}",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12,

          ),
        );
      }
    }else{
      if(plan.subscribed!){
        return  Text(
          "Subscribed",
          style: TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.bold

          ),
        );
      }
      else if(widget.user.promoCode != null){
        return    Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: Text(
                "${plan.currency} ${double.parse((plan.price! -  (widget.user.promoCode!.rate!  * plan.price!)).toStringAsFixed(2))}",
                style: TextStyle(
                    color: Color(0xFF2A9CEA),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            Container(
              child: Text(
                "${plan.currency} ${plan.price!.toStringAsFixed(2)}",
                style: TextStyle(
                    color: kAdeoGray3,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough
                ),
              ),
            ),
          ],
        );
      }
      else{
        return Text(
          "${plan.currency} ${plan.price}",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12,

          ),
        );
      }
    }



  }
  @override
  void initState() {
    if(futurePlanItem.isEmpty){
      getAllPlans();
    }
    UserPreferences().getUser().then((user) {
      setState(() {
        subscriptions = user!.subscriptions;
        widget.user.subscriptions = user.subscriptions;
        context.read<DownloadUpdate>().setSubscriptions(subscriptions);
      });
      print("object ${user!.subscriptions.length}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      body: Container(
        padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello,',
              style: TextStyle(fontSize: 12),
            ),
             Text(
              '${properCase(widget.user.name!)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 20),
             FreeAccessmentWidget(widget.user),
            const SizedBox(
              height: 20,
            ),
             Text(
              Platform.isAndroid ? 'Available bundles' : "Available courses",
              style: TextStyle(color: kSecondaryTextColor, fontSize: 15),
            ),
            const Divider(
              color: kSecondaryTextColor,
              thickness: 1,
              height: 0,
            ),
            SizedBox(height: 10,),

            GestureDetector(
              onTap: (){
                promoCodeModalBottomSheet(context);
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.user.promoCode != null ?
                    Container(
                      width: 200,
                      child: Text(
                        "Discounts expires in ${widget.user.promoCode!.validityPeriod}",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.blue),
                      ),
                    ) :
                    Container(),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        children: [
                         Image.asset("assets/images/gift.png",width: 20,),
                          Text(
                            "Apply code",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ) ,
            const SizedBox(
              height: 10,
            ),

            futurePlanItem.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: futurePlanItem.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  if(futurePlanItem[index].isActive! && futurePlanItem[index].price! > 0){
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: ListTile(
                        onTap: () {
                          if(futurePlanItem[index].subscribed!){
                            goTo(context, MainHomePage(widget.user,index: 2,planId: futurePlanItem[index].id!,),);
                          }
                          else if(!futurePlanItem[index].subscribed!){
                            goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: futurePlanItem[index],));
                          }else{
                            goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: futurePlanItem[index],));
                            // goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: futurePlanItem[index],));
                          }
                        },
                        title:  Text(
                          "${futurePlanItem[index].name}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle:  Text(
                          "${futurePlanItem[index].description}",
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        trailing:  isAlreadySubscribed(futurePlanItem[index])
                      ),
                    );
                  }else{
                    return Container();
                  }

                },
              ),
            ) :
            // futurePlanItem.isNotEmpty && Platform.isIOS ?
            // Expanded(
            //   child: ListView.builder(
            //     padding: EdgeInsets.zero,
            //     itemCount: futurePlanItem.length,
            //     shrinkWrap: true,
            //     physics: const ClampingScrollPhysics(),
            //     itemBuilder: (context, index) {
            //       if(futurePlanItem[index].isActive! && futurePlanItem[index].price! > 0){
            //         return Card(
            //           color: Colors.white,
            //           elevation: 0,
            //           margin: EdgeInsets.only(bottom: 2.h),
            //           child: ListTile(
            //             onTap: () {
            //               if(Platform.isAndroid){
            //                 goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: futurePlanItem[index],));
            //               }else{
            //                 // goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: futurePlanItem[index],));
            //               }
            //             },
            //             title:  Text(
            //               "${futurePlanItem[index].name}",
            //               style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //             subtitle:  Text(
            //               "${futurePlanItem[index].description}",
            //               style: TextStyle(
            //                 fontSize: 9,
            //                 color: Colors.grey,
            //                 fontStyle: FontStyle.italic,
            //               ),
            //             ),
            //             trailing:  Text(
            //               "",
            //               style: TextStyle(
            //                 color: Colors.blue,
            //                 fontSize: 12,
            //               ),
            //             ),
            //           ),
            //         );
            //       }else{
            //         return Container();
            //       }
            //
            //     },
            //   ),
            // ) :
            Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      progress(),
                      SizedBox(width: 10,),
                      sText(Platform.isAndroid ? "Loading Bundles" : "Loading Courses")
                    ],
                  )
                  ,))
          ],
        ),
      ),
    );
  }
}

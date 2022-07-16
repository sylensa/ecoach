import 'dart:io';

import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/revamp/features/payment/views/screens/preparing_download.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage(this.user, {Key? key, required this.controller})
      : super(key: key);
  final User user;
  final MainController controller;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  List<Subscription> subscriptions = [];
  List<SubscriptionItem> items = [];
  List listCoursesCount = [];
  bool progressCode = true;
  getSubscriptionItems() async{
    listCoursesCount.clear();
    if(context.read<DownloadUpdate>().plans != null){
      for(int i =0; i < context.read<DownloadUpdate>().plans.length; i++){
        print("len:${ context.read<DownloadUpdate>().plans.length}");
        List<Course> sItem = await SubscriptionItemDB().subscriptionCourses( context.read<DownloadUpdate>().plans[i].planId!);
        listCoursesCount.add(sItem.length);
      }
    }

    setState(() {
      print("listCoursesCount:$listCoursesCount");
      progressCode = false;
    });

  }
  @override
  void initState() {
    super.initState();
    UserPreferences().getUser().then((user) {
      setState(() {
        subscriptions = user != null ? user.subscriptions : [];
        context.read<DownloadUpdate>().setSubscriptions(subscriptions);
      });
      getSubscriptionItems();

    });
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
          Platform.isAndroid ? "Subscriptions" : "Courses",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
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
                          fontSize: 20.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  if(Platform.isAndroid)
                  Container(
                    width: 100,
                    child:  Text(
                      "Expiry",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
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
                      "Courses",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
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
            context.read<DownloadUpdate>().plans.isNotEmpty ?
            Expanded(
              flex: 8,
              child: ListView.builder(
                itemCount: context.read<DownloadUpdate>().plans.length,
                  itemBuilder: (BuildContext context, int index){
                  return  GestureDetector(
                    onTap: (){
                      Plan newPlan = Plan(
                        id: context.read<DownloadUpdate>().plans[index].planId,
                        updatedAt: context.read<DownloadUpdate>().plans[index].updatedAt,
                        name: context.read<DownloadUpdate>().plans[index].name,
                        createdAt: context.read<DownloadUpdate>().plans[index].createdAt,
                        currency: context.read<DownloadUpdate>().plans[index].currency,
                        description: context.read<DownloadUpdate>().plans[index].description,
                        invoiceInterval: context.read<DownloadUpdate>().plans[index].invoiceInterval,
                        invoicePeriod: context.read<DownloadUpdate>().plans[index].invoicePeriod,
                        isActive: true,
                        price: context.read<DownloadUpdate>().plans[index].price!.toDouble(),
                        signupFee: context.read<DownloadUpdate>().plans[index].price!.toDouble(),
                        tag: context.read<DownloadUpdate>().plans[index].tag,
                        tier: context.read<DownloadUpdate>().plans[index].tier,
                        trialInterval: context.read<DownloadUpdate>().plans[index].invoiceInterval,
                        trialPeriod: 1,

                      );
                      goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: newPlan,daysLeft: context.read<DownloadUpdate>().plans[index].timeLeft,));

                    },
                    child: Card(
                        color: Colors.white,
                        margin: bottomPadding(10),
                        elevation: 0,
                        child: ListTile(
                          title: Platform.isAndroid ? Container(
                            width: 100,
                            child: sText("${context.read<DownloadUpdate>().plans[index].timeLeft} days",color: Colors.black,weight: FontWeight.bold,align: TextAlign.center),

                             ) : Container(),

                          leading: Container(
                            width: 100,
                            child: sText("${context.read<DownloadUpdate>().plans[index].name}",color: Colors.black,weight: FontWeight.bold,align: TextAlign.center),
                          ),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                Text(
                                  "${listCoursesCount.isNotEmpty && context.read<DownloadUpdate>().plans.length == listCoursesCount.length ? listCoursesCount[index] : "0"} courses",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color:  Color(0XFF2D3E50),
                                    fontWeight: FontWeight.bold,
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
            progressCode ?
            Expanded(   flex: 8,child: Center(child: progress()))
            :
            Expanded(   flex: 8,child: Center(child: sText(Platform.isAndroid ? "You've no subscription available" : "You've no courses available contact your school",color:  Color(0XFF2D3E50),weight: FontWeight.bold,size: 16,align: TextAlign.center),)),
            Platform.isAndroid ?
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap:(){
                  paymentOptionModalBottomSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
                  decoration: BoxDecoration(
                      color: Color(0xFFE8F5FF),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock,color: Color(0xFF0367B4),),
                      SizedBox(width: 20,),
                      Text(
                        "Unlock Subscription",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0367B4),
                            height: 1.1,
                            fontFamily: "Poppins"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ) :
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap:(){
                  paymentOptionModalBottomSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
                  decoration: BoxDecoration(
                      color: Color(0xFFE8F5FF),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.lock,color: Color(0xFF0367B4),),
                      // SizedBox(width: 20,),
                      Expanded(
                        child: Text(
                          "Enter Course Key and Proceed to Checkout",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0367B4),
                              height: 1.1,
                              fontFamily: "Poppins"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ) ,
          ],
        ),
      ),
    );
  }
  paymentOptionModalBottomSheet(context){
    bool generateLink = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      border: Border.all(color: Color(0xFFBBCFD6,),width: 2),
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
                        child: sText("Which Option do you prefer",weight: FontWeight.bold,size: 20),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            // SizedBox(height: 20,),
                            // GestureDetector(
                            //   onTap: (){
                            //     authorisePayment(context,);
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.all(20),
                            //     margin: EdgeInsets.symmetric(horizontal: 30),
                            //     child: sText("Direct Pay",color: Colors.grey,align: TextAlign.center,weight: FontWeight.bold),
                            //     decoration: BoxDecoration(
                            //         color: Colors.grey[200],
                            //         borderRadius: BorderRadius.circular(10),
                            //         border: Border.all(color:  Color(0xFFBBCFD6,))
                            //     ),
                            //   ),
                            // ),
                            //
                            // SizedBox(height: 20,),
                            // GestureDetector(
                            //   onTap: ()async{
                            //     stateSetter(() {
                            //       generateLink = false;
                            //     });
                            //     String? link = await getUrlFrmInitialization(
                            //       amount: totalAmount,
                            //     );
                            //     stateSetter(() {
                            //       generatedLink = link != null ? link : "";
                            //       print("generatedLink:$generatedLink");
                            //     });
                            //     Navigator.pop(context);
                            //     paymentLinkModalBottomSheet(context,link: generatedLink);
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.all(20),
                            //     margin: EdgeInsets.symmetric(horizontal: 30),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         sText("Generate Payment Link",color: Colors.grey,align: TextAlign.center,weight: FontWeight.bold),
                            //         SizedBox(width: 10,),
                            //         generateLink ? Container() : progress()
                            //       ],
                            //     ),
                            //     decoration: BoxDecoration(
                            //         color: Colors.grey[200],
                            //         borderRadius: BorderRadius.circular(10),
                            //         border: Border.all(color:  Color(0xFFBBCFD6,))
                            //     ),
                            //   ),
                            // ),

                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                productKeyModalBottomSheet(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: sText("Enter Product Key",color: Colors.grey,align: TextAlign.center,weight: FontWeight.bold),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color:  Color(0xFFBBCFD6,))
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: ()async{
                                Navigator.pop(context);
                                customerCare();

                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sText("Contact customer care",color: Colors.grey,align: TextAlign.center,weight: FontWeight.bold),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color:  Color(0xFFBBCFD6,))
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
  productKeyModalBottomSheet(context,){
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 300;
    showModalBottomSheet(
        context: context,
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
                        child: sText("Enter Product Key",weight: FontWeight.bold,size: 20),
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
                                      onSaved: (value) {
                                        setState(() {
                                          productKeyController.text = value!;
                                        });
                                      },
                                      inputFormatters: [
                                        MaskedTextInputFormatter(mask: 'XXX-XXX-XXX-XXX-XXX'),
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'[ ]'),
                                        ),
                                        FilteringTextInputFormatter.deny(
                                          RegExp('\n'),
                                        ),
                                        FilteringTextInputFormatter.allow(
                                          RegExp('[A-Z0-9-]'),
                                        ),
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

                                        hint: 'XXX-XXX-XXX-XXX-XXX',
                                        radius: 10,
                                        labelText: "XXX-XXX-XXX-XXX-XXX",
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
                                if(productKeyController.text.isNotEmpty && isActivated){
                                  stateSetter((){
                                    isActivated = false;
                                  });
                                  try{
                                    var res = await doPost(AppUrl.productKey, {'product-key':productKeyController.text,'user-id': widget.user.id,'reference-id':"${generateRandom()}"});
                                    print("res:$res");
                                    if(res["code"].toString() == "200"){
                                      if(res["data"] != null){
                                        Subscription subRes = Subscription.fromJson(res["data"]);
                                        Plan newPlan = Plan(
                                          id: subRes.planId,
                                          updatedAt: subRes.updatedAt,
                                          name: subRes.name,
                                          createdAt: subRes.createdAt,
                                          currency:subRes.currency,
                                          description: subRes.description,
                                          invoiceInterval: subRes.invoiceInterval,
                                          invoicePeriod: subRes.invoicePeriod,
                                          isActive: true,
                                          price:subRes.price!.toDouble(),
                                          signupFee: subRes.price!.toDouble(),
                                          tag: subRes.tag,
                                          tier: subRes.tier,
                                          trialInterval: subRes.invoiceInterval,
                                          trialPeriod: 1,
                                        );
                                       await getSubscriptionPlans(newPlan,subRes);

                                      }else{
                                        stateSetter((){
                                          isActivated = true;
                                        });
                                        showDialogOk(message: "${res["message"]}",context: context,dismiss: false);
                                      }

                                    }else  if(res["code"].toString() == "404"){
                                      stateSetter((){
                                        isActivated = true;
                                      });
                                      showDialogOk(message: "${res["message"]}",context: context,dismiss: false);
                                    }
                                    else{
                                      stateSetter((){
                                        isActivated = true;
                                      });
                                      showDialogOk(message: "Product key is incorrect",context: context,dismiss: false);
                                    }
                                  }catch(e){
                                    stateSetter((){
                                      isActivated = true;
                                    });
                                    print("error:$e");
                                    showDialogOk(message: "Product key is incorrect",context: context,dismiss: false);
                                  }
                                }else{
                                  toastMessage("Product key is required");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sText("Activate",color: Colors.white,align: TextAlign.center,weight: FontWeight.bold),
                                    SizedBox(width: 10,),
                                    isActivated ? Container() : progress()
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: isActivated ? Colors.green : Colors.grey,
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
  getSubscriptionPlans(Plan plan,Subscription subscription)async{
    items =  await PlanDB().planItems(plan.id!);
    if(items.isEmpty){
      await PlanController().getSubscriptionPlan(plan.id!);
      items =  await PlanDB().planItems(plan.id!);
    }
    toastMessage("Bundle key redeemed successfully.");
    List<Subscription> listSub = [];
    listSub.add(subscription);
    context.read<DownloadUpdate>().plans.add(subscription);
    await SubscriptionItemDB().insertAll(items);
    await SubscriptionDB().insert(subscription);
    await getSubscriptionItems();
    setState((){

    });
    Navigator.pop(context);
    await goTo(context, PreparingDownload(widget.user,selectedTableRows: items,controller: widget.controller,bundle: plan,));
  }
}

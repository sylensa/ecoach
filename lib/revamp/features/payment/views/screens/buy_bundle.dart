import 'dart:io';

import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/features/payment/views/screens/preparing_download.dart';
import 'package:ecoach/revamp/features/payment/views/widgets/payment_options_widget.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/get_bundle_plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:convert';

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/core/utils/text_styles.dart';
import 'package:ecoach/revamp/features/payment/views/widgets/generated_link_widget.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:ecoach/views/user_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyBundlePage extends StatefulWidget {
  BuyBundlePage(this.user, {Key? key, required this.bundle, required this.controller,this.daysLeft = ""}) : super(key: key);
  final Plan bundle;
  User user;
  MainController controller;
  String daysLeft;

  @override
  State<BuyBundlePage> createState() => _BuyBundlePageState();
}

class _BuyBundlePageState extends State<BuyBundlePage> {
  List<SubscriptionItem> selectedTableRows = [];
  List<SubscriptionItem> items = [];
  List<SubscriptionItem> listSubscriptionItem = [];
  bool isPressedDown = false;
  bool progressCode = true;
  bool isSubscribed = false;
  List que = [];
  List<Subscription> subscriptions = [];
  late String subName;
  List<BundleByPlanData> bundleByPlanData = [];
  double totalAmount = 0.0;

  late String generatedLink = '';

  Future<String?> getUrlFrmInitialization({String? email, required double amount, List<String>? metadata}) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Initializing payment information ..."),
    ));
    String? url;
    String? email = widget.user.email;
    if (email == null || email.isEmpty) {
      email = "${widget.user.phone}@ecoach.com";
    }
    try {
      final Map<String, dynamic> paymentData = {
        'email': email,
        'phone': widget.user.phone,
        'amount': amount,
        "plan_id": widget.bundle.id,
        'metadata':
        json.encode("{purpose: buying book, description: I want to learn}"),
      };
      print("making call..........");
      print(amount);
      http.Response response = await http.post(
        Uri.parse(AppUrl.payment_initialize),
        body: json.encode(paymentData),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'api-token': widget.user.token!
        },
      );

      print(response.body);

      final Map<String, dynamic> responseData = json.decode(response.body);

      print("url = $responseData['data']");
      if (responseData['status'] == true) {
        url = responseData['data']['authorization_url'];
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      }
    } catch (e, m) {
      print(e);
      print(m);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "There was a problem initializing payment. Please try again later"),
      ));
    }

    return url;
  }

  authorisePayment(BuildContext context) async {
    String? authorizationUrl = await getUrlFrmInitialization(email: widget.user.email, amount: totalAmount);
    if (authorizationUrl == null) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: authorizationUrl,
          navigationDelegate: (navigation) async {
            //Listen for callback URL
            if (navigation.url.contains('https://standard.paystack.co/close')) {
              Navigator.of(context).pop(); //close webview
            }
            if (navigation.url.contains(AppUrl.payment_callback)) {
              Navigator.of(context).pop(); //close webview

              setState(() {});

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserSetup(widget.user)),
                      (Route<dynamic> route) => false);
            }
            return NavigationDecision.navigate;
          },
        );
      },
    );
  }
  paymentLinkModalBottomSheet(context,{String link = ""}){
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
                      border: Border.all(color:  Color(0xFFBBCFD6,),width: 2),
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
                        child: sText("Payment Link",weight: FontWeight.bold,size: 20),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: sText("Payment link successfully generated below",weight: FontWeight.bold,color: Colors.grey),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 20,),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: sText("$link",color: Colors.grey,align: TextAlign.center,weight: FontWeight.bold),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color:  Color(0xFFBBCFD6,))
                              ),
                            ),

                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                Clipboard.setData(ClipboardData(text: "$link"));
                                Navigator.pop(context);
                                toastMessage("Link copied to clipboard");
                                // goTo(context, MainHomePage(widget.user,index: 1,),replace: true);
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: sText("Copy Link",color: Colors.white,align: TextAlign.center,weight: FontWeight.bold),
                                decoration: BoxDecoration(
                                  color: Colors.green,
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
                                // Navigator.pop(context);
                                if(productKeyController.text.isNotEmpty && isActivated){
                                  stateSetter((){
                                    isActivated = false;
                                  });
                                  try{
                                    var token = (await UserPreferences().getUserToken());
                                    print("token:$token");
                                    var res = await doPost(AppUrl.productKey, {'product-key':productKeyController.text,'user-id': widget.user.id,'reference-id':"1234"});
                                    print("res:$res");
                                    if(res["code"].toString() == "200"){
                                      if(res["data"] != null){
                                        Subscription subRes = Subscription.fromJson(res["data"]);
                                        await getSubscriptionPlans(widget.bundle,subRes);
                                      }else{
                                        stateSetter((){
                                          isActivated = true;
                                        });
                                        showDialogOk(message: "${res["message"]}",context: context,dismiss: false);
                                      }


                                      // goTo(context, MainHomePage(widget.user),replace: true);
                                    }else  if(res["code"].toString() == "404"){
                                      stateSetter((){
                                        isActivated = true;
                                      });
                                      showDialogOk(message: "${res["message"]}",context: context,dismiss: false);
                                    }else{
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
    await SubscriptionItemDB().insertAll(items);
    await SubscriptionDB().insert(subscription);
    await getSubscriptionItems();
    setState((){

    });
    Navigator.pop(context);
    await goTo(context, PreparingDownload(widget.user,selectedTableRows: items,controller: widget.controller,bundle: plan,));
  }


  @override
  void initState() {
    super.initState();
    subName = widget.bundle.name!;
    subName = subName.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();
    totalAmount = double.parse(widget.bundle.price.toString());
    UserPreferences().getUser().then((user) {
      setState(() {
        subscriptions = user!.subscriptions;
        context.read<DownloadUpdate>().setSubscriptions(subscriptions);
      });
    });

    getSubscriptionItems();
    // getSubscriptionItems();
  }
  getSubscriptionPlanAnnex()async{
    var js = await doGet('${AppUrl.plans}/${widget.bundle.id}');
    print("res plans: $js");
    if(js["status"] && js["data"].isNotEmpty){
      bundleByPlanData.add(BundleByPlanData.fromJson(js["data"])) ;
      if(bundleByPlanData.isNotEmpty){
        for(int i = 0; i < bundleByPlanData[0].features.length; i++){
          items.add(bundleByPlanData[0].features[i]);
        }
      }

    }

    setState(() { });

  }
  getSubscriptionPlan()async{
    items =  await PlanDB().planItems(widget.bundle.id!);
    if(items.isEmpty){
      await PlanController().getSubscriptionPlan(widget.bundle.id!);
      items =  await PlanDB().planItems(widget.bundle.id!);
    }
    setState(() {
      print("items:${items.length}");
      progressCode = false;
    });

  }
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }
  getSubscriptionItems() {
    SubscriptionItemDB().subscriptionItems(widget.bundle.id!).then((items) {
      setState(() {
        this.items = items;
        if(this.items.isEmpty){
           // getSubscriptionPlan();
          getSubscriptionPlan();
        }else{
          isSubscribed = true;
          progressCode = false;
        }
        print("object:$items");
        // toast("object:$items");
      });
    });

  }

  clearList() {
    items.clear();
    selectedTableRows.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
      context.watch<DownloadUpdate>().isDownloading ?
      Container(
        height: MediaQuery.of(context).size.height * .25,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 24, color: Color(0x4D000000))
          ],
        ),
        child: Column(
          children: [
            context.read<DownloadUpdate>().percentage > 0 &&
                context.read<DownloadUpdate>().percentage < 100
                ? LinearPercentIndicator(
              percent:
              context.read<DownloadUpdate>().percentage /
                  100,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 0),
              lineHeight: 4,
            )
                : LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Text(
                context
                    .read<DownloadUpdate>()
                    .message!
                    .toTitleCase(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            items.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                shrinkWrap: true,
                itemCount: context
                    .read<DownloadUpdate>()
                    .doneDownloads
                    .length,
                itemBuilder: (context, index) {
                  return Text(
                    context
                        .read<DownloadUpdate>()
                        .doneDownloads[index],
                    style: TextStyle(color: kAdeoGray2),
                  );
                },
              ),
            ) :
            Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      progress(),
                      SizedBox(width: 10,),
                      sText("Loading Courses")
                    ],
                  )
                  ,))
          ],
        ),
      )
          :
      isSubscribed ?
      InkWell(
      onTap: () {
        setState(() {
          for(int i = 0; i< items.length; i++){
            selectedTableRows.add(items[i]);
          }
        });
        if (context.read<DownloadUpdate>().isDownloading) {
          print("hey: ${context.watch<DownloadUpdate>().isDownloading}");

          return;
        }
        setState(
              () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Download bundle",
                    style: TextStyle(color: Colors.black),
                  ),
                  content: Text(
                    "Do you want to re download this bundle?",
                    style: TextStyle(color: Colors.black),
                    softWrap: true,
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.controller.downloadSubscription(
                          selectedTableRows,
                              (success) {
                            UserPreferences().getUser().then(
                                  (user) {
                                setState(() {
                                  widget.user = user!;
                                });
                              },
                            );
                            clearList();
                            getSubscriptionItems();
                          },
                        );

                      },
                      child: Text("Yes"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      child: Container(
        color: Color(0xFF2A9CEA),
        height: 56,
        child:  Center(
          child: Text(
            'Redownload Bundle',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    ) :
      InkWell(
      onTap: () {
        paymentOptionModalBottomSheet(context);
      },
      child: Container(
        color: const Color(0xFF00C9B9),
        height: 56,
        child:  Center(
          child: Text(
            'Buy Bundle',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    ) ,
        body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w, bottom: 4),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon:  Icon(Icons.arrow_back)),
                   Expanded(
                    child: Text(
                      "${widget.bundle.name}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 29,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  isSubscribed ?
                      IconButton(onPressed: (){
                        setState(() {
                          for(int i = 0; i< items.length; i++){
                            selectedTableRows.add(items[i]);
                          }
                        });
                        if (context.read<DownloadUpdate>().isDownloading) {
                          return;
                        }
                        setState(
                              () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Download bundle",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Text(
                                    "Do you want to re download this bundle?",
                                    style: TextStyle(color: Colors.black),
                                    softWrap: true,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        widget.controller.downloadSubscription(
                                          selectedTableRows,
                                              (success) {
                                            UserPreferences().getUser().then(
                                                  (user) {
                                                setState(() {
                                                  widget.user = user!;
                                                });
                                              },
                                            );
                                            clearList();
                                            getSubscriptionItems();
                                          },
                                        );
                                      },
                                      child: Text("Yes"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }, icon: Icon(Icons.download,color: Colors.green,)) :
                  SizedBox(
                    height: 27,
                    width: 27,
                    child: Stack(
                      children: [
                        Container(
                          width: 21,
                          height: 21,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(width: 2, color: Colors.black),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
             Text(
              "Rev Shaddy Consult",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
             Text(
              "${widget.bundle.currency}${widget.bundle.price}",
              style: TextStyle(
                  color: Color(0xFF2A9CEA),
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            ),
            widget.daysLeft.isNotEmpty ?
             Text(
              "${widget.daysLeft} days left",
              style: TextStyle(fontSize: 11, color: Color(0xFF8E8E8E)),
            ) : Container(),
            SizedBox(
              height: 2.h,
            ),
            items.isNotEmpty ?
            Expanded(
                child: Container(
              height: 651,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        Text(
                          "${properCase(widget.bundle.description!)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E8E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xFFB8B8B8),
                    thickness: 2,
                  ),

                  ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 32, top: 27, right: 32, bottom: 20),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            // final SubscriptionItem course = items[index];
                            if(isSubscribed){
                              if(items[index].downloadStatus == "downloaded"){
                                setState(() {
                                  selectedTableRows.add(items[index]);
                                });
                                if (context.read<DownloadUpdate>().isDownloading) {
                                  print("hey: ${context.watch<DownloadUpdate>().isDownloading}");

                                  return;
                                }
                                setState(
                                      () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Download Course",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          content: Text(
                                            "Are you sure you want to redownload this course?",
                                            style: TextStyle(color: Colors.black),
                                            softWrap: true,
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                widget.controller.downloadSubscription(
                                                  selectedTableRows,
                                                      (success) {
                                                    UserPreferences().getUser().then(
                                                          (user) {
                                                        setState(() {
                                                          widget.user = user!;
                                                        });
                                                      },
                                                    );
                                                    clearList();
                                                    getSubscriptionItems();
                                                  },
                                                );
                                              },
                                              child: Text("Yes"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("No"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                              else{
                                setState(() {
                                  selectedTableRows.add(items[index]);
                                });
                                if (context.read<DownloadUpdate>().isDownloading) {
                                  print("hey: ${context.watch<DownloadUpdate>().isDownloading}");

                                  return;
                                }
                                setState(
                                      () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Download course",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          content: Text(
                                            "Do you want to download this course?",
                                            style: TextStyle(color: Colors.black),
                                            softWrap: true,
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                widget.controller.downloadSubscription(
                                                  selectedTableRows,
                                                      (success) {
                                                    UserPreferences().getUser().then(
                                                          (user) {
                                                        setState(() {
                                                          widget.user = user!;
                                                        });
                                                      },
                                                    );
                                                    clearList();
                                                    getSubscriptionItems();
                                                  },
                                                );
                                              },
                                              child: Text("Yes"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("No"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              }

                            }else{
                              paymentOptionModalBottomSheet(context);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Card(
                                elevation: 0,
                                child: ListTile(
                                  title:  Text(
                                    "${items[index].name}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                  subtitle:  Text(
                                    "Topic: ${items[index].topicCount != null  ? items[index].topicCount! : "0"} | Quizes: ${items[index].quizCount!} | Questions: ${items[index].questionCount!}",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 9),
                                  ),
                                  leading: Text(
                                    "0${index + 1}",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.25),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 29,
                                    ),
                                  ),
                                  trailing: Image.asset(
                                    "assets/images/download.png",
                                    color:
                                    items[index].downloadStatus == "downloaded"  && isSubscribed && items[index].questionCount! > 0 ? Colors.green : Colors.grey,
                                    height: 27,
                                    width: 27,
                                  ),
                                )),
                          ),
                        );
                      })
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.w),
                  topRight: Radius.circular(5.w),
                ),
                color: const Color(0xFFF5F5F5),
              ),
            )) :
                !progressCode ?
                    Expanded(child: Center(child: sText("Plan not found"),))
                : progress()
          ],
        ),
      ),
    );
  }
}

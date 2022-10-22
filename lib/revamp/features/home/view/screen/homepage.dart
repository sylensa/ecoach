import 'dart:io';

import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/home/view/widgets/free_assessment_widget.dart';
import 'package:ecoach/revamp/features/home/view/widgets/groups.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:ecoach/widgets/progress_chart.dart';
import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  static const String routeName = '/home';
  final User user;
  final Function? callback;

  final MainController controller;

  HomePage2(
    this.user, {
    this.callback,
    required this.controller,
  });

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardContent(user: widget.user),
    );
  }
}

class DashboardContent extends StatefulWidget {
  final User user;
  DashboardContent({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardContent> createState() => _HomePage2ContentState();
}

class _HomePage2ContentState extends State<DashboardContent> {
  bool notificationsToggled = false;
  bool progressCode = true;
  SubscriptionItem? subscription;
  List<TestTaken> selectedTests = [];

  List<Plan> monthlyPlan = [];
  List<Plan> annuallyPlan = [];
  List<Bundle> bundleList = [];
  List<SubscriptionItem> subscriptions = [];

  uploadOfflineFlagQuestions() async {
    List<FlagData> results = await QuizDB().getAllFlagQuestions();
    if (results.isNotEmpty) {
      for (int i = 0; i < results.length; i++) {
        FlagData flagData = await FlagData(
            reason: results[i].reason,
            type: results[i].type,
            questionId: results[i].questionId);
        await QuizDB().saveOfflineFlagQuestion(flagData, flagData.questionId!);
      }
      List<FlagData> res = await QuizDB().getAllFlagQuestions();
      print("res len:${res.length}");
    } else {
      print("res len:${results.length}");
    }
  }

  getAllPlans() async {
    // futurePlanItem =   await PlanDB().getAllPlans();
    if (futurePlanItem.isEmpty) {
      await PlanDB().deleteAllPlans();
      await PlanDB().deleteAllPlanItem();
      await PlanController().getPlanOnly();
    }

    if (mounted) setState(() {});
  }

  promoCodeModalBottomSheet(
    context,
  ) {
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
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
                      color: Colors.white,
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
                            child: sText(
                                Platform.isAndroid
                                    ? "Enter your referral/discount code"
                                    : "Enter your referral code",
                                weight: FontWeight.bold,
                                size: 20,
                                align: TextAlign.center)),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        MaskedTextInputFormatter(
                                            mask: 'x-x-x-x-x-x'),
                                      ],
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      onFieldSubmitted: (value) {
                                        stateSetter(() {
                                          sheetHeight = 300;
                                        });
                                      },
                                      onTap: () {
                                        stateSetter(() {
                                          sheetHeight = 650;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      style: appStyle(
                                          weight: FontWeight.bold, size: 20),
                                      decoration: textDecorNoBorder(
                                        hintWeight: FontWeight.bold,
                                        hint: 'x-x-x-x-x-x',
                                        radius: 10,
                                        labelText: "Enter code",
                                        hintColor: Colors.black,
                                        borderColor: Colors.grey[400]!,
                                        fill: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Navigator.pop(context);
                                if (productKeyController.text.isNotEmpty &&
                                    isActivated) {
                                  stateSetter(() {
                                    isActivated = false;
                                  });
                                  try {
                                    var res = await doPost(
                                        AppUrl.userPromoCodes, {
                                      'promo_code': productKeyController.text
                                          .replaceAll('-', '')
                                    });
                                    print("res:$res");
                                    if (res["status"]) {
                                      setState(() {
                                        PromoCode promoCode =
                                            PromoCode.fromJson(res["data"]);
                                        widget.user.promoCode = promoCode;
                                        UserPreferences().setUser(widget.user);
                                      });
                                      Navigator.pop(context);
                                      showDialogOk(
                                          message:
                                              "You have ${res["data"]["discount"]} on all bundle purchase. The discount expires in ${res["data"]["validity_period"]}",
                                          context: context,
                                          dismiss: false,
                                          title: "${res["message"]}");
                                    } else {
                                      Navigator.pop(context);
                                      stateSetter(() {
                                        isActivated = true;
                                      });
                                      showDialogOk(
                                          message: "${res["message"]}",
                                          context: context,
                                          dismiss: false);
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    stateSetter(() {
                                      isActivated = true;
                                    });
                                    print("error:$e");
                                    showDialogOk(
                                        message: "Promo code is incorrect",
                                        context: context,
                                        dismiss: false);
                                  }
                                } else {
                                  toastMessage("Promo code is required");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sText("Apply code",
                                        color: Colors.white,
                                        align: TextAlign.center,
                                        weight: FontWeight.bold),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    isActivated ? Container() : progress()
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isActivated ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            },
          );
        });
  }

  isAlreadySubscribed(Plan plan) {
    print(
        "widget.user.subscriptions.length:${widget.user.subscriptions.length}");
    if (widget.user.subscriptions.isNotEmpty) {
      for (int i = 0; i < widget.user.subscriptions.length; i++) {
        if (widget.user.subscriptions[i].planId == plan.id) {
          return Text(
            Platform.isAndroid ? "Subscribed" : "Product Delivered",
            style: TextStyle(
                color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
          );
        }
      }
      if (widget.user.promoCode != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "${plan.currency} ${double.parse((plan.price! - (widget.user.promoCode!.rate! * plan.price!)).toStringAsFixed(2))}",
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
                    decoration: TextDecoration.lineThrough),
              ),
            ),
          ],
        );
      } else {
        return Text(
          "${plan.currency} ${plan.price}",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12,
          ),
        );
      }
    } else {
      if (plan.subscribed!) {
        return Text(
          Platform.isAndroid ? "Subscribed" : "Product Delivered",
          style: TextStyle(
              color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
        );
      } else if (widget.user.promoCode != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "${plan.currency} ${double.parse((plan.price! - (widget.user.promoCode!.rate! * plan.price!)).toStringAsFixed(2))}",
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
                    decoration: TextDecoration.lineThrough),
              ),
            ),
          ],
        );
      } else {
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
  void dispose() {
    super.dispose();
  }

  getCourseById(int id) {
    // return CourseDB().getCourseById(id);
  }

  @override
  void initState() {
    super.initState();
    SubscriptionItemDB().allSubscriptionItems().then((List<SubscriptionItem> subscriptions) {
      if (subscriptions.length > 0) {
        this.subscriptions = subscriptions;
        this.subscription = subscriptions[0];
      }
      setState(() {
        progressCode = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPageBackgroundGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: kPageBackgroundGray,
                          padding: EdgeInsets.only(
                            top: 60,
                            bottom: 60,
                            // right: 40,
                            // left: 40,
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      spacing: 60,
                                      runSpacing: 16,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hello,',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              widget.user.name!,
                                              style: TextStyle(
                                                fontFamily: 'PoppinsMedium',
                                                fontSize: 32,
                                                height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 560,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              promoCodeModalBottomSheet(
                                                  context);
                                            },
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  widget.user.promoCode != null
                                                      ? Container(
                                                          width: 200,
                                                          child: Text(
                                                            "Discounts expires in ${widget.user.promoCode!.validityPeriod}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        )
                                                      : Container(),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[400]!),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/gift.png",
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          "Apply code",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  constraints: BoxConstraints(
                                    maxHeight: 520,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        child:
                                            FreeAssessmentWidget(widget.user),
                                      ),
                                      // SizedBox(
                                      //   height: 32,
                                      // ),
                                      Expanded(
                                        child: GroupClass(
                                          user: widget.user,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 42),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: ProgressChart(
                                    subscriptions: subscriptions,
                                    selectedSubscription: subscription,
                                    updateState: (s) {
                                      setState(() {
                                        subscription = s['item'];
                                        selectedTests = s['selectedTests'];
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 42),
                                // DashboardAvailableBundles(
                                //   user: widget.user,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

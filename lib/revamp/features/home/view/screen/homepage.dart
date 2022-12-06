import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/autopilot_db.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/completed_activity.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/revamp/features/home/components/completed_activities_tab.dart';
import 'package:ecoach/revamp/features/home/components/ongoing_activities_tab.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/home/view/widgets/free_accessment_widget.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:ecoach/widgets/progress_chart.dart';

class HomePage2 extends StatefulWidget {
  static const String routeName = '/home';
  final User user;
  final Function? callback;

  final MainController controller;
  int? planId;

  HomePage2(
    this.user, {
    this.callback,
    required this.controller,
    this.planId,
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
      body: DashboardContent(
        user: widget.user,
        mainController: widget.controller,
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  final User user;
  final MainController mainController;
  int? planId;
  DashboardContent({
    Key? key,
    required this.user,
    required this.mainController,
    this.planId,
  }) : super(key: key);

  @override
  State<DashboardContent> createState() => _HomePage2ContentState();
}

class _HomePage2ContentState extends State<DashboardContent>
    with SingleTickerProviderStateMixin {
  bool notificationsToggled = false;
  bool progressCode = true;
  SubscriptionItem? subscription;
  List<TestTaken> selectedTests = [];

  List<Plan> monthlyPlan = [];
  List<Plan> annuallyPlan = [];
  List<Bundle> bundleList = [];
  List<SubscriptionItem> subscriptions = [];
  late TabController _tabController;
  late List<String> _tabs;
  late String _activeTab;
  bool isActiveTab = false;

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
    _tabController.dispose();
    super.dispose();
  }

  getSubscriptionItem() {
    SubscriptionItemDB()
        .allSubscriptionItems()
        .then((List<SubscriptionItem> subscriptions) {
      if (subscriptions.length > 0) {
        this.subscriptions = subscriptions;
        this.subscription = subscriptions[0];
      } else {
        getSubscriptionItem();
      }
      if(mounted)
      setState(() {
        progressCode = false;
      });
    });
  }

  late Topic? topic;
  late Topic? completedActivitiesTopic;
// Ongoing Activities
  List<TestActivity> allOngoingActivities = [];

  Future<List<TestActivity>> getOngoingMarathons() async {
    late List<TestActivity> ongoingMarathonActivities = [];

    late TestActivityList ongoingMarathons;
    await MarathonDB().ongoingMarathons().then((mList) async {
      List<Marathon> marathons = mList;
      Map<String, dynamic> ongoingMarathonsMap = {
        "marathons": marathons,
      };
      ongoingMarathons = TestActivityList.fromJson(ongoingMarathonsMap);
      for (Marathon ongoingMarathon in ongoingMarathons.marathons!) {
        if (ongoingMarathon.topicId != null) {
          topic = await TopicDB().getTopicById(ongoingMarathon.topicId!);
          if (topic == null) {
            continue;
          }
          Map<String, dynamic> completedMarathonJSON = {
            "activityType": TestActivityType.MARATHON,
            "courseId": ongoingMarathon.courseId,
            "activityStartTime": ongoingMarathon.startTime!.toIso8601String(),
            "marathon": ongoingMarathon,
            "topic": topic,
          };

          TestActivity completedMarathonObject =
              TestActivity.fromJson(completedMarathonJSON);
          ongoingMarathonActivities.add(completedMarathonObject);
        }
      }
    });
    return ongoingMarathonActivities;
  }

  Future<List<TestActivity>> getOngoingAutopilots() async {
    List<TestActivity> ongoingAutopilotActivities = [];
    late TestActivityList ongoingAutopilots;
    await AutopilotDB().ongoingAutopilots().then((mList) async {
      List<Autopilot> autopilots = mList;
      Map<String, dynamic> ongoingAutopilotsMap = {
        "autopilots": autopilots,
      };

      ongoingAutopilots = TestActivityList.fromJson(ongoingAutopilotsMap);
      for (var ongoingAutopilot in ongoingAutopilots.autopilots!) {
        Map<String, dynamic> ongoingAutopilotJSON = {
          "activityType": TestActivityType.AUTOPILOT,
          "courseId": ongoingAutopilot.courseId,
          "activityStartTime": ongoingAutopilot.startTime!.toIso8601String(),
          "autopilot": ongoingAutopilot,
          // "topic": null,
        };

        TestActivity ongoingAutopilotObject =
            TestActivity.fromJson(ongoingAutopilotJSON);
        ongoingAutopilotActivities.add(ongoingAutopilotObject);
      }
    });
    return ongoingAutopilotActivities;
  }

  Future<List<TestActivity>> getOngoingTreadmills() async {
    List<TestActivity> ongoingTreadmillActivities = [];

    try {
      late TestActivityList ongoingTreadmills;
      await TestController().getOngoingTreadmill().then((mList) async {
        List<Treadmill> treadmills = mList;
        print("ongoing Tred: ${treadmills}");

        Map<String, dynamic> ongoingTreamillsMap = {
          "ongoing_treadmills": treadmills,
        };

        ongoingTreadmills = TestActivityList.fromJson(ongoingTreamillsMap);

        for (var ongoingTreadmill in ongoingTreadmills.ongoingTreadmills!) {
          print("ttttt: ${ongoingTreadmill.toJson()}");
          // int topicId =
          //     jsonDecode(ongoingTreadmill.responses)["Q1"]["topic_id"];
          // topic = await TopicDB().getTopicById(ongoingTreadmill.topicId!);

          Map<String, dynamic> ongoingTreadmillJSON = {
            "activityType": TestActivityType.TREADMILL,
            "courseId": ongoingTreadmill.courseId,
            "activityStartTime": ongoingTreadmill.startTime!.toIso8601String(),
            "ongoing_treadmill": ongoingTreadmill,
            // "topic": topic,
          };

          TestActivity ongoingTreadmillObject =
              TestActivity.fromJson(ongoingTreadmillJSON);
          ongoingTreadmillActivities.add(ongoingTreadmillObject);
        }
      });
    } catch (e) {
      print("error: ${e}");
    }

    return ongoingTreadmillActivities;
  }

  loadOngoingActivities() async {
    List<TestActivity> ongoingMarathonActivities = await getOngoingMarathons();
    List<TestActivity> ongoingAutopilotActivities =
        await getOngoingAutopilots();
    List<TestActivity> ongoingTreadmillActivities =
        await getOngoingTreadmills();

    List<TestActivity> ongoingActivities = [
      ...ongoingMarathonActivities,
      ...ongoingAutopilotActivities,
      ...ongoingTreadmillActivities,
    ];

    setState(() {
      allOngoingActivities = ongoingActivities;
    });
  }

// End of Ongoing Activities

// Completed Activities //
  late List<TestActivity> allCompletedActivities = [];

  getCompletedAutopilots() async {
    List<TestActivity> completedAutopilotActivities = [];
    late TestActivityList completedAutopilots;
    await AutopilotDB().completedAutopilots().then((mList) async {
      List<Autopilot> autopilots = mList;

      Map<String, dynamic> completedAutopilotsMap = {
        "autopilots": autopilots,
      };
      completedAutopilots = TestActivityList.fromJson(completedAutopilotsMap);
      for (var completedAutopilot in completedAutopilots.autopilots!) {
        Map<String, dynamic> completedAutopilotJSON = {
          "activityType": TestActivityType.AUTOPILOT,
          "courseId": completedAutopilot.courseId,
          "activityStartTime": completedAutopilot.startTime!.toIso8601String(),
          "autopilot": completedAutopilot,
          // "topic": null,
        };

        TestActivity completedAutopilotObject =
            TestActivity.fromJson(completedAutopilotJSON);
        completedAutopilotActivities.add(completedAutopilotObject);
      }
    });
    return completedAutopilotActivities;
  }

  getCompletedMarathons() async {
    List<TestActivity> completedMarathonActivities = [];
    late TestActivityList completedMarathons;
    await MarathonDB().completedMarathons().then((mList) async {
      List<Marathon> marathons = mList;

      Map<String, dynamic> completedMarathonsMap = {
        "marathons": marathons,
      };
      completedMarathons = TestActivityList.fromJson(completedMarathonsMap);
      for (var completedMarathon in completedMarathons.marathons!) {
        if (completedMarathon.topicId != null) {
          completedActivitiesTopic =
              await TopicDB().getTopicById(completedMarathon.topicId!);
          if (completedActivitiesTopic == null) {
            continue;
          }
          Map<String, dynamic> completedMarathonJSON = {
            "activityType": TestActivityType.MARATHON,
            "courseId": completedMarathon.courseId,
            "activityStartTime": completedMarathon.startTime!.toIso8601String(),
            "marathon": completedMarathon,
            "topic": completedActivitiesTopic,
          };
          TestActivity completedMarathonObject =
              TestActivity.fromJson(completedMarathonJSON);
          completedMarathonActivities.add(completedMarathonObject);
        }
      }
    });
    return completedMarathonActivities;
  }

  getCompletedTreadmills() async {
    List<TestActivity> completedTreadmillActivities = [];
    late TestActivityList completedTreadmills;
    await TestTakenDB().courseTestsTaken().then((mList) async {
      List<TestTaken> treadmills = mList;

      Map<String, dynamic> completedTreadmillsMap = {
        "treadmills": treadmills,
      };
      completedTreadmills = TestActivityList.fromJson(completedTreadmillsMap);
      for (var completedTreadmill in completedTreadmills.treadmills!) {
        int topicId =
            jsonDecode(completedTreadmill.responses)["Q1"]["topic_id"];
        completedActivitiesTopic = await TopicDB().getTopicById(topicId);
        if (completedActivitiesTopic == null) {
          continue;
        }
        Map<String, dynamic> completedTreadmillJSON = {
          "activityType": TestActivityType.TREADMILL,
          "courseId": completedTreadmill.courseId,
          "activityStartTime": completedTreadmill.updatedAt!.toIso8601String(),
          "treadmill": completedTreadmill,
          "topic": completedActivitiesTopic,
        };

        TestActivity completedTreadmillObject =
            TestActivity.fromJson(completedTreadmillJSON);
        completedTreadmillActivities.add(completedTreadmillObject);
      }
    });

    return completedTreadmillActivities;
  }

  loadCompletedActivities() async {
    List<TestActivity> completedMarathonActivities =
        await getCompletedMarathons();
    List<TestActivity> completedAutopilotActivities =
        await getCompletedAutopilots();
    List<TestActivity> completedTreadmillActivities =
        await getCompletedTreadmills();

    List<TestActivity> completedActivities = [
      ...completedMarathonActivities,
      ...completedTreadmillActivities,
      ...completedAutopilotActivities,
    ];

    if (mounted) {
      setState(() {
        allCompletedActivities = completedActivities;
      });
    }
  }

  bool _swipeIsInProgress = false;
  bool _tapIsBeingExecuted = false;
  double currentIndicatorLineWidth = 40;
  double tempWidth = 0;

  @override
  void initState() {
    _tabs = [
      "Home",
      "Ongoing",
      "Completed",
    ];

    _tabController = TabController(length: 3, vsync: this);
    _tabController.animation?.addListener(() {
      print("Offset: ${_tabController.offset}");
      if (_tabController.offset >= 0.5 || _tabController.offset <= -0.5) {
        _swipeIsInProgress = true;
      } else {
        if (!_tapIsBeingExecuted &&
            _swipeIsInProgress &&
            ((_tabController.offset < 0.5 && _tabController.offset > 0) ||
                (_tabController.offset > -0.5 && _tabController.offset < 0))) {
          _swipeIsInProgress = false;
        }
      }
      if (_swipeIsInProgress) {
        tempWidth = --currentIndicatorLineWidth;
        if (tempWidth >= 0) currentIndicatorLineWidth = tempWidth;
      } else {
        tempWidth = 0;
        currentIndicatorLineWidth = 40;
      }
      setState(() {});
    });
    _tabController.addListener(() {
      _swipeIsInProgress = false;
      setState(() {
        currentIndicatorLineWidth = 40;
        isActiveTab = _tabController.index == _tabs.indexOf(_activeTab);
      });
      if (_tapIsBeingExecuted == true) {
        _tapIsBeingExecuted = false;
      } else {
        if (_tabController.indexIsChanging) {
          _tapIsBeingExecuted = true;
        }
      }
    });
    loadOngoingActivities();
    loadCompletedActivities();

    SubscriptionItemDB()
        .allSubscriptionItems()
        .then((List<SubscriptionItem> subscriptions) {
      if (subscriptions.length > 0) {
        this.subscriptions = subscriptions;
        this.subscription = subscriptions[0];
      } else {
        getSubscriptionItem();
      }
      setState(() {
        progressCode = false;
      });
    });

    uploadOfflineFlagQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 164.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  child: FreeAccessmentWidget(widget.user),
                                ),
                              ],
                            ),
                            SizedBox(height: 32),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: ProgressChart(
                                user: widget.user,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: OngoingActivitiesTab(
                        mainController: widget.mainController,
                        planId: widget.planId,
                        user: widget.user,
                        allOngoingActivities: allOngoingActivities,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: CompletedActivitiesTab(
                        mainController: widget.mainController,
                        planId: widget.planId,
                        user: widget.user,
                        allCompletedActivities: allCompletedActivities,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 54,
              ),
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: 60,
                          runSpacing: 16,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: appWidth(context) * 0.6,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Hello, ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.user.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        promoCodeModalBottomSheet(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[400]!),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/gift.png",
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Apply code",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            if (widget.user.promoCode != null)
                              Container(
                                width: appWidth(context),
                                child: Text(
                                  "Discounts expires in ${widget.user.promoCode!.validityPeriod}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    //  TabBar
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: kAdeoGreen4,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 1,
                          ),
                          unselectedLabelColor: Colors.black87,
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.w500),
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent,
                          ),
                          onTap: (x) {
                            setState(() {
                              // isActiveTab = _tabController.index == x;
                            });
                          },
                          indicatorColor: Colors.transparent,
                          tabs: _tabs.map((tab) {
                            isActiveTab =
                                _tabController.index == _tabs.indexOf(tab);
                            if (isActiveTab) {
                              _activeTab = tab;
                              setState(() {});
                            }
                            return Tab(
                              child: UnselectedTabIndicator(
                                label: tab,
                                isActive: isActiveTab,
                                indicatorWidth: currentIndicatorLineWidth,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class UnselectedTabIndicator extends StatefulWidget {
  const UnselectedTabIndicator({
    Key? key,
    required this.label,
    this.isActive = false,
    this.indicatorWidth,
  }) : super(key: key);

  final String label;
  final bool isActive;
  final double? indicatorWidth;

  @override
  State<UnselectedTabIndicator> createState() => _UnselectedTabIndicatorState();
}

class _UnselectedTabIndicatorState extends State<UnselectedTabIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 11.0,
          ),
          child: Text(
            widget.label,
            style: TextStyle(fontFamily: "Poppins", fontSize: 16),
          ),
        ),
        widget.isActive
            ? Column(
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 20),
                    width: widget.indicatorWidth,
                    height: 2,
                    constraints: BoxConstraints(
                      minWidth: 0,
                    ),
                    decoration: BoxDecoration(
                      color: kAdeoGreen4,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                  ),
                ],
              )
      ],
    );
  }
}

// class CircleTabIndicator extends Decoration {
//   CircleTabIndicator({required this.color, required this.radius});
//   final Color color;
//   final double radius;

//   //override createBoxPainter

//   @override
//   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
//     return _CirclePainter(color: color, radius: radius);
//   }
// }

// class _CirclePainter extends BoxPainter {
// //override paint
//   final Color color;
//   final double radius;

//   _CirclePainter({
//     required this.color,
//     required this.radius,
//   });

//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
//     late Paint _paint;
//     _paint = Paint()
//       ..color = color
//       ..isAntiAlias = true;

//     final Offset circleOffset =
//         offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius - 5);
//     canvas.drawCircle(circleOffset, radius, _paint);
//   }
// }

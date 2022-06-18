import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/subscribe_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/lib/core/utils/app_colors.dart';
import 'package:ecoach/lib/features/home/view/widgets/free_accessment_widget.dart';
import 'package:ecoach/lib/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:flutter/material.dart';
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
  Future? futureItem;
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
  getSubscriptionItems() async{
    for(int i =0; i < context.read<DownloadUpdate>().plans!.length; i++){
      int count = 0;
      print("len:${ context.read<DownloadUpdate>().plans!.length}");
      List<SubscriptionItem> sItem = await SubscriptionItemDB().subscriptionItems( context.read<DownloadUpdate>().plans![i].planId!);
      for(int t = 0; t < sItem.length; t++){
        List<Question> question = await TestController().getSavedTests(sItem[t].course!,limit: sItem[t].questionCount);
        print("object:${question.length}");
        count += question.length;
      }
    }


  }
  @override
  void initState() {
    super.initState();
    futureItem = ApiCall<Plan>(
      AppUrl.plans,
      user: widget.user,
      create: (dataItem) {
        return Plan.fromJson(dataItem);
      },
    ).get(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      body: ListView(
        padding: EdgeInsets.only(top: 6.h, bottom: 2.h, left: 2.h, right: 2.h),
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
          const SizedBox(height: 37.5),
           FreeAccessmentWidget(widget.user),
          const SizedBox(
            height: 37.5,
          ),
          const Text(
            'Available bundles',
            style: TextStyle(color: kSecondaryTextColor, fontSize: 15),
          ),
          const Divider(
            color: kSecondaryTextColor,
            thickness: 1,
            height: 0,
          ),
          const SizedBox(
            height: 20.5,
          ),
          FutureBuilder(
            future: futureItem,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );

                case ConnectionState.done:
                  if (snapshot.data != null) {
                    annuallyPlan.clear();
                    List<Plan> plans = snapshot.data as List<Plan>;
                    plans.forEach((plan) {
                      if (plan.invoiceInterval == "year") {
                        annuallyPlan.add(plan);
                      }
                    });
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: annuallyPlan.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          margin: EdgeInsets.only(bottom: 2.h),
                          child: ListTile(
                            onTap: () {
                              goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: annuallyPlan[index],));
                            },
                            title:  Text(
                              "${annuallyPlan[index].name}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle:  Text(
                              "${annuallyPlan[index].description}",
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            trailing:  Text(
                              "${annuallyPlan[index].currency}${annuallyPlan[index].price}",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "A problem ocurred",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "There are no items in the store",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}

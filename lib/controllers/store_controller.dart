import 'package:ecoach/api/api_response.dart';
import 'package:ecoach/api2/api_call.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/plan2.dart' as planModel;
import 'package:ecoach/models/store_search.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/components/subscription/subscribe_to_plan.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/blur_dialog.dart';
import 'package:flutter/material.dart';

class StoreController {
  List featuredTests = [
    {
      "id": "1",
      "testName": "English 1.0",
      "imgUrl": "assets/images/store/store-img-4.png",
    },
    {
      "id": "2",
      "testName": "Speed Test",
      "imgUrl": "assets/images/store/store-img-3.png",
    },
  ];

  Future<List<planModel.Plan>> searchPlans(BuildContext context,
      {String query = ""}) async {
    List<planModel.Plan> plans = [];
    try {
      var response = await ApiCall<StoreSearch>(context).get(
        AppUrl.searchPlans,
        isList: false,
        params: {"search_query": query},
        create: (dataItem) {
          return StoreSearch.fromJson(dataItem);
        },
      );
      plans = response.data.bundles;
    } catch (e) {
      toastMessage(
        "Ooops! Something went wrong",
        long: true,
        background: kAnalysisInfoSnippetBackground1,
        textColor: dDarkText,
      );
      print("Store - Bundles Search Error: $e");
    }
    return plans;
  }

  Future<List<planModel.Plan>> filterPlans(BuildContext context,
      {List<String>? query}) async {
    var response = await ApiCall<planModel.Plan>(context).post(
      AppUrl.filterPlans,
      isList: true,
      params: {"topics": query ?? []},
      create: (dataItem) {
        return planModel.Plan.fromJson(dataItem);
      },
    );

    // plans = response.data!;
    return response.data!;
  }

  // void setFilteredPlans(List<Plan>? filteredPlans) {
  //   plans = filteredPlans!;
  // }

  Future<List<planModel.Plan>> getPlans(BuildContext context) async {
    var response = await ApiCall<planModel.Plan>(context).get(
      AppUrl.plans,
      create: (dataItem) {
        return planModel.Plan.fromJson(dataItem);
      },
    );
    return response.data;
  }

  Future<planModel.Plan> getPlanDetails(BuildContext context, int planId) async {
    final ApiResponse<planModel.Plan> response = await ApiCall<planModel.Plan>(context).get(
      "${AppUrl.planDetails}/$planId",
      isList: false,
      create: (dataItem) {
        return planModel.Plan.fromJson(dataItem);
      },
    );
    return response.data;
  }

  showSubscriptionModal(BuildContext context, String bundleName, planModel.Plan plan) {
    return showDialogWithBlur(
      backgroundColor: Colors.transparent,
      context: context,
      child: Container(
        padding: EdgeInsets.only(
          top: 28,
          right: 26,
          left: 26,
          bottom: 42,
        ),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width, maxHeight: 800),
        decoration: BoxDecoration(
          color: kAdeoRoyalBlue,
          borderRadius: BorderRadius.circular(
            kAdeoBorderRadiusValueLg,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bundleName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'PoppinsSemiBold',
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 42,
            ),
            FutureBuilder<User?>(
              future: UserPreferences().getUser(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return SizedBox(
                      width: 18,
                      height: 18,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: kAdeoGreen4,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else if (snapshot.data != null) {
                      User user = snapshot.data!;
                      return Expanded(
                        child: SingleChildScrollView(
                          child: SubscribeToPlan(
                            user,
                            plan,
                            key: UniqueKey(),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:ecoach/database/plan.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';

class PlanController{

  getPlanOnly()async{
    futurePlanItem.clear();
    futurePlanItem = await PlanDB().getAllPlans();
    if(futurePlanItem.isEmpty){
      String? token = await UserPreferences().getUserToken();
      token != null ? token = token : token = '';
      print("token:$token");
      var js = await doGet('${AppUrl.plans}',token);
      print("res plans: $js");
      if(js["status"] && js["data"].isNotEmpty){
        for(int i = 0; i < js["data"].length; i++){
          Plan plan = Plan.fromJson(js["data"][i]);
          futurePlanItem.add(plan);
        }
        PlanDB().insertAll(futurePlanItem);
      }
    }

  }

  getPlan()async{
    futurePlanItem.clear();
    futurePlanItem = await PlanDB().getAllPlans();
    if(futurePlanItem.isEmpty){
      String? token = await UserPreferences().getUserToken();
      token != null ? token = token : token = '';
      print("token:$token");
      var js = await doGet('${AppUrl.plans}',token);
      print("res plans: $js");
      if(js["status"] && js["data"].isNotEmpty){
        for(int i = 0; i < js["data"].length; i++){
          Plan plan = Plan.fromJson(js["data"][i]);
          futurePlanItem.add(plan);
        }
        await PlanDB().insertAll(futurePlanItem);
        print("futurePlanItem len:${futurePlanItem.length}");

        for(int t =0 ; t < futurePlanItem.length; t++){
          await getSubscriptionPlan(futurePlanItem[t].id!);
        }
      }
    }

  }

  getSubscriptionPlan(int bundleId)async {
    String? token = await UserPreferences().getUserToken();
    token != null ? token = token : token = '';
    print("token:$token");
    var js = await doGet('${AppUrl.plans}/$bundleId', token);
    print("res plans items: $js");
    if (js["status"] && js["data"]["features"].isNotEmpty) {
      for (int i = 0; i < js["data"]["features"].length; i++) {
        SubscriptionItem subscriptionItem = SubscriptionItem.fromJson(
            js["data"]["features"][i]);
        await PlanDB().insert(subscriptionItem);
      }
    }
  }
}
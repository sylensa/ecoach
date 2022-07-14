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
    List<Plan> listPlans = [];
    futurePlanItem = await PlanDB().getAllPlans();
    if(futurePlanItem.isEmpty){
      String? token = await UserPreferences().getUserToken();
      token != null ? token = token : token = '';
      print("token:$token");
      var js = await doGet('${AppUrl.plans}');
      print("res plans: $js");
      if(js["status"] && js["data"].isNotEmpty){
        for(int i = 0; i < js["data"].length; i++){
          Plan plan = Plan.fromJson(js["data"][i]);
          if(plan.subscribed!){
            listPlans.add(plan);
          }else{
            futurePlanItem.add(plan);
          }
          for(int t = 0; t < js["data"][i]["features"].length; t++){
            SubscriptionItem subscriptionItem = SubscriptionItem.fromJson(js["data"][i]["features"][t]);
            await PlanDB().insert(subscriptionItem);
          }
        }
        futurePlanItem.insertAll(0, listPlans);
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
      var js = await doGet('${AppUrl.plans}');
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
   try{
     var js = await doGet('${AppUrl.plans}/$bundleId');
     print("res plans items: $js");
     if (js["status"] && js["data"]["features"].isNotEmpty) {
       for (int i = 0; i < js["data"]["features"].length; i++) {
         SubscriptionItem subscriptionItem = SubscriptionItem.fromJson(
             js["data"]["features"][i]);
         await PlanDB().insert(subscriptionItem);
       }
     }
   }catch(e){
     print("error");
   }
  }
}
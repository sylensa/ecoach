import 'package:ecoach/api/google_signin_call.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Logout extends StatefulWidget {
  static const String routeName = '/logout';

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      futurePlanItem.clear();
      listActivePackageData.clear();
      await PlanDB().deleteAllPlans();
      await SubscriptionDB().deleteAll();
      await SubscriptionItemDB().deleteAll();
      await QuestionDB().deleteAllSavedTest();
      await QuestionDB().deleteAllQuestions();
      var status = await UserPreferences().getLoginWith() ;
       await UserPreferences().removeUser();
      if(status){
        await GoogleSignInApi().signOut();
      }else{
        print("status:$status");
      }
      // showDialogOk(message: "status:$status",context: context);
      Navigator.of(context).pushReplacementNamed("/login");
    });
    // it will navigate to login page as soon as this state is built
  }

  @override
  Widget build(BuildContext context) {
    // UserPreferences().removeUser();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(child: Text("Thank you")),
          SizedBox(height: 100),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
              child: Text('Login again'))
        ],
      ),
    );
  }
}

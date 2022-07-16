import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/revamp/features/payment/views/screens/preparing_download.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/saved_questions/saved_course_questions.dart';
import 'package:ecoach/views/subscribe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SavedQuestionsPage extends StatefulWidget {
  const SavedQuestionsPage(this.user, {Key? key, required this.controller})
      : super(key: key);
  final User user;
  final MainController controller;

  @override
  State<SavedQuestionsPage> createState() => _SavedQuestionsPageState();
}

class _SavedQuestionsPageState extends State<SavedQuestionsPage> {
  List<Subscription> subscriptions = [];
  List<SubscriptionItem> items = [];
  List listCoursesCount = [];
  bool progressCode = true;
  List que = [];
  List queList = [];
  getSubscriptionItems() async{
    que.clear();
    if(context.read<DownloadUpdate>().plans != null){
      for(int i =0; i < context.read<DownloadUpdate>().plans.length; i++){
        int count = 0;
        print("len:${ context.read<DownloadUpdate>().plans.length}");
        List<SubscriptionItem> sItem = await SubscriptionItemDB().subscriptionItems( context.read<DownloadUpdate>().plans[i].planId!);
        for(int t = 0; t < sItem.length; t++){
          if(sItem[t].course != null){
            List<Question> question = await TestController().getSavedTests(sItem[t].course!,limit: sItem[t].questionCount);
            print("object:${question.length}");
            count += question.length;
          }
        }
        que.add(count);
      }
    }

    setState(() {
      progressCode = false;
      print("que:${que.length}");
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
          "Saved Questions",
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
                  Text(
                    "Bundle Name",
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "Questions",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                      height: 1.1,
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
                      onTap: ()async{
                        if(que.isNotEmpty){
                          if(que[index] > 0){
                            await  goTo(context, SavedCoursePage(widget.user, controller: widget.controller,bundle: context.read<DownloadUpdate>().plans[index],));
                            getSubscriptionItems();
                          }else{
                            toastMessage("No saved questions for this bundle");
                          }
                        }else{
                          toastMessage("No saved questions for this bundle");
                        }

                      },
                      child: Card(
                          color: Colors.white,
                          margin: bottomPadding(10),
                          elevation: 0,

                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: sText("${context.read<DownloadUpdate>().plans[index].name}",color: Colors.black,weight: FontWeight.bold,align: TextAlign.center),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${que.length == context.read<DownloadUpdate>().plans.length && que.isNotEmpty ? que[index] : "0"} Q",
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
                              ],
                            ),
                          )

                      ),
                    );
                  }),
            ) :
            progressCode ?
            Expanded(   flex: 8,child: Center(child: progress()))
                :
            Expanded(   flex: 8,child: Center(child: sText("You've no saved questions",color:  Color(0XFF2D3E50),weight: FontWeight.bold,size: 16),)),

            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap:(){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Saved questions",
                          style: TextStyle(color: Colors.black),
                        ),
                        content: Text(
                          "Are you sure you want to remove all saved questions?",
                          style: TextStyle(color: Colors.black),
                          softWrap: true,
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async{
                              Navigator.pop(context);
                              await  QuestionDB().deleteAllSavedTest();
                              setState((){
                                getSubscriptionItems();
                              });

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
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFEDEA),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_forever,color: Color(0xFFC25D47),),
                      SizedBox(width: 20,),
                      Text(
                        "Clear Saved Questions",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC25D47),
                            height: 1.1,
                            fontFamily: "Poppins"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

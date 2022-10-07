import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesPage extends StatefulWidget {
  static const String routeName = '/courses';
  CoursesPage(this.user, this.controller, {Key? key, this.planId = -1})
      : super(key: key);
  User user;
  int planId;
  final MainController controller;

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool progressCode = true;

  getUserSubscriptions()async{
    context.read<DownloadUpdate>().plans = await widget.controller.makeSubscriptionsCall();
    setState(() {
      progressCode = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    if(context.read<DownloadUpdate>().plans.isEmpty){
      getUserSubscriptions();
    }

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: sText("Select Your Subscription",weight: FontWeight.bold,size: 20,color: kAdeoGray3),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            context.read<DownloadUpdate>().plans.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                  itemCount:  context.read<DownloadUpdate>().plans.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index){
                    return MaterialButton(
                      onPressed: (){
                        print("object");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CoursesDetailsPage();
                            },
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: appWidth(context),
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: sText("${ context.read<DownloadUpdate>().plans[index].name}",weight: FontWeight.bold,size: 20,color: kAdeoGray3,align: TextAlign.center),
                          ),
                          SizedBox(height: 15,)
                        ],
                      ),
                    );
              }),
            ) :
            context.read<DownloadUpdate>().plans.isEmpty && progressCode ?
            Expanded(child: Center(child: progress(),)) :
            Expanded(child: Center(child: sText("You've no subscriptions"),))
          ],
        ),
      ),
    );
  }
}

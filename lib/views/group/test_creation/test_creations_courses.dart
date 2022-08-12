import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group/test_creation/test_creation_test_type.dart';
import 'package:flutter/material.dart';

class TestCreationCourses extends StatefulWidget {
  Subscription? subscription;
   TestCreationCourses({this.subscription});

  @override
  State<TestCreationCourses> createState() => _TestCreationCoursesState();
}

class _TestCreationCoursesState extends State<TestCreationCourses> {
  List<Course> futureItems = [];
  bool progressCode = true;

  getSubscriptionCourse()async{
    futureItems = await SubscriptionItemDB().subscriptionCourses(widget.subscription!.planId!);
    if(futureItems.isEmpty){
      ApiCall<Data>(AppUrl.new_user_data, isList: false,
          create: (Map<String, dynamic> json) {
            return Data.fromJson(json);
          }, onCallback: (data) async{
            if (data != null) {
              await LevelDB().insertAll(data!.levels!);
              await CourseDB().insertAll(data!.courses!);
            }
            await getSubscriptionCourse();
          }, onError: (e) {
          }).get(context);
    }else{
      setState((){
        progressCode = false;
      });
    }


  }
  @override
void  initState(){
    getSubscriptionCourse();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.white,
        title: sText("Test Creation",color: Colors.black,weight: FontWeight.bold,size: 20),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: Stack(
                  children:  const [
                    CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                      value: 0.6,
                    ),
                    Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: appWidth(context),
            child: sText("Select your source for the test",color: kAdeoGray2,align: TextAlign.center),
          ),
          SizedBox(height: 20,),
          futureItems.isNotEmpty ?
          Expanded(
            child: ListView.builder(
                itemCount: futureItems.length,
                itemBuilder: (BuildContext context, int index){
                return   Container(
                  padding: appPadding(20),
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  decoration: BoxDecoration(
                    color: kAdeoGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: (){
                                groupTestCourse = futureItems[index].name.toString();
                                goTo(context, TestCreationTestType(course: futureItems[index],));
                              },
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: appWidth(context) * 0.70,
                                      child: sText("${futureItems[index].name}",size: 16,weight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      width: appWidth(context) * 0.65,

                                      child: sText("Pick a quiz from your existing subscription",size: 12,color: kAdeoGray2),
                                    )

                                  ],
                                ),
                              ),
                            ),
                            Image.asset("assets/images/stopwatch.png",width: 30,)
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(color: Color(0XFF00C9B9),height: 5,),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                                color: Color(0XFF0367B4),height: 5
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                );
            }),
          ) :
          progressCode ?
          Center(child: sText("Loading courses"),) : Center(child: sText("Empty courses"))


        ],
      ),
    );
  }
}

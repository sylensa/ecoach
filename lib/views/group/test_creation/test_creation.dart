import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group/test_creation/test_configuration.dart';
import 'package:ecoach/views/group/test_creation/test_creation_subscriptions.dart';
import 'package:ecoach/views/group/test_creation/test_creation_test_type.dart';
import 'package:ecoach/views/group/test_creation/test_creation_test_type_list.dart';
import 'package:ecoach/views/group/test_creation/test_creations_courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestCreation extends StatefulWidget {
  const TestCreation({Key? key}) : super(key: key);

  @override
  State<TestCreation> createState() => _TestCreationState();
}

class _TestCreationState extends State<TestCreation> {
  int _currentPage = 0;
  List<Course> futureItems = [];
  bool progressCode = true;
  List<TestNameAndCount> listTopics = [];
  Course? course;
  getTypeList(String type,)async{
    if(type == "exam"){
      listTopics = await TestController().getExamTests(course!);
    }else if(type == "topic"){
      listTopics = await TestController().getTopics(course!,);
    }else if(type == "bank"){
      listTopics = await TestController().getBankTest(course!);
    }
    setState((){
      print("listTopics:$listTopics");
      groupTestType = type;
      _currentPage++;
    });
  }
  getSubscriptionCourse(int planId )async{
    futureItems = await SubscriptionItemDB().subscriptionCourses(planId);
    if(futureItems.isEmpty){
      ApiCall<Data>(AppUrl.new_user_data, isList: false,
          create: (Map<String, dynamic> json) {
            return Data.fromJson(json);
          }, onCallback: (data) async{
            if (data != null) {
              await LevelDB().insertAll(data!.levels!);
              await CourseDB().insertAll(data!.courses!);
            }
            await getSubscriptionCourse(planId);
          }, onError: (e) {
          }).get(context);
    }else{
      setState((){
        progressCode = false;
        _currentPage++;
      });
    }


  }
  Map<String, Widget> getPage() {
    switch (_currentPage) {
      case 0:
        return {'': getTestSource()};
      case 1:
        return {'': getTestSubscriptions()};
      case 2:
        return {'': getTestCourses()};
      case 3:
        return {'': getTestType()};
      case 4:
        return {'': getTestTypeList()};
    }
    return {'': Container()};
  }
  @override
  Widget build(BuildContext context) {
    return getPage().values.first;
  }

  getTestSource(){
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
                      value: 0.2,
                    ),
                    Center(
                      child: Text(
                        "1",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: appWidth(context),
              child: sText("Select your source for the test",color: kAdeoGray2,align: TextAlign.center),
            ),
            SizedBox(height: 20,),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                if(context.read<DownloadUpdate>().plans.isNotEmpty){
                  groupTestSource = "subscription";
                  setState((){
                    _currentPage++;
                  });
                  // goTo(context, TestCreationSubscriptions());
                }else{
                  toastMessage("You have no subscriptions");
                }
              },
              child: Container(
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
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: sText("Subscription",size: 20,weight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: appWidth(context) * 0.65,

                                  child: sText("Pick a quiz from your existing subscription",size: 12,color: kAdeoGray2),
                                )

                              ],
                            ),
                          ),
                          Image.asset("assets/images/stopwatch.png")
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
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                groupTestSource = "editor";
              },
              child: Container(
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
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: sText("Editor",size: 20,weight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: appWidth(context) * 0.65,
                                  child: sText("Pick a quiz you created with your questions",size: 12,color: kAdeoGray2),
                                )

                              ],
                            ),
                          ),
                          Image.asset("assets/images/stopwatch.png",)
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
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                groupTestSource = "testgen";
              },
              child: Container(
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
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: sText("Testgen",size: 20,weight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: appWidth(context) * 0.65,
                                  child: sText("Pick a quiz you generated from our questions database",size: 12,color: kAdeoGray2),
                                )

                              ],
                            ),
                          ),
                          Image.asset("assets/images/stopwatch.png",)
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTestSubscriptions(){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          setState((){
            _currentPage--;
          });
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
                      value: 0.4,
                    ),
                    Center(
                      child: Text(
                        "2",
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
          Expanded(
            child: ListView.builder(
                itemCount: context.read<DownloadUpdate>().plans.length,
                itemBuilder: (BuildContext context, int index){
                  if(context.read<DownloadUpdate>().plans[index].price != 0){
                    return  Container(
                      padding: appPadding(20),
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      decoration: BoxDecoration(
                        color: kAdeoGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: ()async{
                              groupTestBundle = context.read<DownloadUpdate>().plans[index].name.toString();
                             await  getSubscriptionCourse(context.read<DownloadUpdate>().plans[index].planId!);
                              // goTo(context, TestCreationCourses(subscription: context.read<DownloadUpdate>().plans[index],));
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: appWidth(context) * 0.70,

                                          child: sText("${context.read<DownloadUpdate>().plans[index].name}",size: 16,weight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: appWidth(context) * 0.65,

                                          child: sText("Pick a quiz from your existing subscription",size: 12,color: kAdeoGray2),
                                        )

                                      ],
                                    ),
                                  ),
                                  Image.asset("assets/images/stopwatch.png",width: 30,)
                                ],
                              ),
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
                  }
                  return Container();
                }),
          )

        ],
      ),
    );
  }

  getTestCourses(){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          setState((){
            _currentPage--;
          });
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
                                  course = futureItems[index];
                                  setState((){
                                    _currentPage++;
                                  });
                                  // goTo(context, TestCreationTestType(course: futureItems[index],));
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

  getTestType(){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          setState((){
            _currentPage--;
          });
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
                      value: 0.8,
                    ),
                    Center(
                      child: Text(
                        "4",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: appWidth(context),
              child: sText("Select your source for the test",color: kAdeoGray2,align: TextAlign.center),
            ),
            SizedBox(height: 20,),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: ()async{

               await  getTypeList("exam");
              },
              child: Container(
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
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: sText("Exams",size: 16,weight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: appWidth(context) * 0.65,

                                  child: sText("Pick a quiz from your existing subscription",size: 12,color: kAdeoGray2),
                                )

                              ],
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
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: ()async{
                await  getTypeList("topic");
              },
              child: Container(
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
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: sText("Topics",size: 16,weight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: appWidth(context) * 0.65,
                                  child: sText("Pick a quiz you created with your questions",size: 12,color: kAdeoGray2),
                                )

                              ],
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
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: ()async{
                await  getTypeList("bank");
              },
              child: Container(
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
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: sText("Banks",size: 16,weight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: appWidth(context) * 0.65,
                                  child: sText("Pick a quiz you generated from our questions database",size: 12,color: kAdeoGray2),
                                )

                              ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTestTypeList(){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          setState((){
            _currentPage--;
          });
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
                      value: 0.9,
                    ),
                    Center(
                      child: Text(
                        "5",
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
          listTopics.isNotEmpty ?
          Expanded(
            child: ListView.builder(
                itemCount: listTopics.length,
                itemBuilder: (BuildContext context, int index){
                  return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      groupTestId = listTopics[index].id.toString();
                      goTo(context, TestConfigurations(testName: listTopics[index].name,));
                    },
                    child: Container(
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
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: appWidth(context) * 0.70,
                                        child: sText("${listTopics[index].name}",size: 16,weight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        width: appWidth(context) * 0.65,

                                        child: sText("Pick a quiz from your existing subscription",size: 12,color: kAdeoGray2),
                                      )

                                    ],
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
                    ),
                  );
                }),
          ) : Expanded(child: Center(child: sText("No ${properCase(groupTestType)}s",weight: FontWeight.w500),))

        ],
      ),
    );
  }

}

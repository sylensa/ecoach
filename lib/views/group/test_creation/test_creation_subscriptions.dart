import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group/test_creation/test_creations_courses.dart';
import 'package:flutter/material.dart';

class TestCreationSubscriptions extends StatefulWidget {
  const TestCreationSubscriptions({Key? key}) : super(key: key);

  @override
  State<TestCreationSubscriptions> createState() => _TestCreationSubscriptionsState();
}

class _TestCreationSubscriptionsState extends State<TestCreationSubscriptions> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: appWidth(context),
              child: sText("Select your source for the test",color: kAdeoGray2,align: TextAlign.center),
            ),
            SizedBox(height: 20,),
            Container(
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
                    onPressed: (){
                      goTo(context, TestCreationCourses());
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
                                  child: sText("Primary 1",size: 20,weight: FontWeight.bold),
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
            Container(
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
                                child: sText("Primary 2",size: 20,weight: FontWeight.bold),
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
            Container(
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
                                child: sText("Primary 3",size: 20,weight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}

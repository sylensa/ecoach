import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group/test_creation/test_creation_subscriptions.dart';
import 'package:ecoach/views/group/test_creation/test_creations_courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestCreation extends StatefulWidget {
  const TestCreation({Key? key}) : super(key: key);

  @override
  State<TestCreation> createState() => _TestCreationState();
}

class _TestCreationState extends State<TestCreation> {
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
                        if(context.read<DownloadUpdate>().plans.isNotEmpty){
                          goTo(context, TestCreationSubscriptions());
                        }else{
                          toastMessage("You have no subscriptions");
                        }
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
            ],
          ),
        ),
    );
  }
}

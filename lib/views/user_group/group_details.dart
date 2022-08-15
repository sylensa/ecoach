import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupDetails extends StatefulWidget {
  static const String routeName = '/user_group';
  GroupDetails(this.user, {Key? key}) : super(key: key);
  User user;
  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h, right: 2.h),
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 3.h,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                           child: Icon(Icons.arrow_back,color: Colors.black,),
                       ),
                        GestureDetector(
                          onTap: ()async{

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                            child: sText("JOIN",color: Colors.white,weight: FontWeight.bold),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText("Afram's SAT",weight: FontWeight.w500,size: 20),
                      SizedBox(height: 0,),
                      sText("by Mr. Afram Dzidefo",weight: FontWeight.w500,size: 12,color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              child: Icon(Icons.groups,color: Colors.grey,size: 20,),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              child: sText("2412",size: 12,weight: FontWeight.bold,),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              child: Icon(Icons.star,color: Colors.orange,size: 20,),
                            ),
                            SizedBox(width: 0,),
                            Container(
                              child: sText("4.0",size: 10,weight: FontWeight.bold,),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              child: sText("(200 reviews)",size: 10,weight: FontWeight.normal,),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              child: Icon(Icons.lock,color: Colors.red,size: 12,),
                            ),
                            SizedBox(width: 0,),
                            Container(
                              child: sText("\$99",size: 12,weight: FontWeight.bold,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: kHomeBackgroundColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),)
                ),
                child: ListView(
                    padding:EdgeInsets.zero,
                  children: [
                     Container(
                       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             child: sText("Description",weight: FontWeight.bold,size: 16),
                           ),
                         ],
                       ),
                     ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                          child: sText("Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade.",weight: FontWeight.normal,color: Colors.grey),
                        ),
                        Divider(color: Colors.grey,)
                      ],
                    ),
                    SizedBox(height: 10,),
                    //features
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sText("Featured Reviews",size: 16,weight: FontWeight.bold),
                          sText("See all",size: 12,color: Colors.grey),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 170,
                      margin: EdgeInsets.symmetric(horizontal: 20),

                      child: ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index){
                            return Row(
                              children: [
                                Container(
                                  width: appWidth(context) * 0.7 ,
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey[200]!)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          displayImage("imagePath",radius: 20),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              sText("Victor Adatsi"),
                                              Row(children: [
                                                Icon(Icons.star,color: Colors.yellow,size: 20,),
                                                Icon(Icons.star,color: Colors.yellow,size: 20,),
                                                Icon(Icons.star,color: Colors.yellow,size: 20,),
                                                Icon(Icons.star,color: Colors.yellow,size: 20,),
                                                Icon(Icons.star,color: Colors.yellow,size: 20,),

                                              ],),
                                              sText("2 Months",size: 12,weight: FontWeight.w600),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        child: sText("Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade.  Select your preferred upgrade.  Select your preferred upgrade.  Select your preferred upgrade.",weight: FontWeight.normal,color: Colors.black,size: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            );
                          }),
                    ),
                    Divider(color: Colors.grey,),
                    // admin

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child:  sText("Administrators",size: 16,weight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 170,
                      margin: EdgeInsets.symmetric(horizontal: 20),

                      child: ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index){
                            return Row(
                              children: [
                                Container(
                                  width: appWidth(context) * 0.7 ,
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey[200]!)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          displayImage("imagePath",radius: 20),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              sText("Victor Adatsi"),
                                              sText("2 Months",size: 12,weight: FontWeight.w600),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        child: sText("Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade. Select your preferred upgrade.  Select your preferred upgrade.  Select your preferred upgrade.  Select your preferred upgrade.",weight: FontWeight.normal,color: Colors.black,size: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            );
                          }),
                    ),
                    Divider(color: Colors.grey,)
                  ],
                ),
              ),
            )
          ],
        ),

      ),

    );
  }
}

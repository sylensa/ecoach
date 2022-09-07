import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_activities/group_activity.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoGroupActivity extends StatefulWidget {
  static const String routeName = '/user_group';
  NoGroupActivity( {Key? key}) : super(key: key);
  @override
  State<NoGroupActivity> createState() => _NoGroupActivityState();
}

class _NoGroupActivityState extends State<NoGroupActivity> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        color: Color(0XFFE2EFF3),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h, right: 2.h),
              decoration: BoxDecoration(
                color: Color(0XFFE2EFF3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4.h,),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        ),
                        SizedBox(width: 20,),
                        sText("Afram's SAT",weight: FontWeight.bold,size: 20),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        color: Color(0XFFF7B06E),
                      ),
                      SizedBox(width: 10,),
                      sText("20 days remaining",weight: FontWeight.w500,size: 12,color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 10,),
                  sText("Welcome, Victor",weight: FontWeight.w500,size: 20,color: Colors.black),

                ],
              ),
            ),
            Expanded(
              child: Container(
                width: appWidth(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Column(
                      children: [
                        Image.asset("assets/images/no_data.png"),
                        sText("Sorry you have"),
                        SizedBox(height: 10,),
                        sText("NO activity",weight: FontWeight.bold,size: 20,color: Color(0XFF757575)),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: appWidth(context),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        decoration: BoxDecoration(
                            color: Color(0XFF00C9B9),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(child: sText("Contact Group Admin",color: Colors.white,weight: FontWeight.w500)),
                      ),
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
}

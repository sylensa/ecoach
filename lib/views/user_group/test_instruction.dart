import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_activity.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TestInstruction extends StatefulWidget {
  static const String routeName = '/user_group';
  TestInstruction({Key? key}) : super(key: key);
  @override
  State<TestInstruction> createState() => _TestInstructionState();
}

class _TestInstructionState extends State<TestInstruction> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        color: Color(0XFFE2EFF3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        ),
                        SizedBox(width: 20,),
                        sText("Test",weight: FontWeight.bold,size: 20),

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
                      SizedBox(width: 20,),
                      sText("09:30 - 10:30 am",weight: FontWeight.w500,size: 12,color: Colors.black),
                      Expanded(child: Container()),
                      sText("03:59",weight: FontWeight.w500,size: 18,color: Color(0XFF8ED4EB)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  sText("Maths Assessment",weight: FontWeight.w500,size: 20,color: Colors.black),
                  SizedBox(height: 5,),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset("assets/images/question-mark.png"),
                              SizedBox(width: 5,),
                              sText("30Q",weight: FontWeight.w500,size: 12,color: Colors.black),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          child: Row(
                            children: [
                              Image.asset("assets/images/clock.png"),
                              SizedBox(width: 5,),
                              sText("1 hour",weight: FontWeight.w500,size: 12,color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                width: appWidth(context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        sText("Instruction",weight: FontWeight.bold,size: 16,align: TextAlign.left),
                        sText("This test is your final assessment before your actual exam. Ensure to answer every question. Any wrongly answered question attracts a mark of -1 Any unanswered question attracts a mark of -1 The test comprises of 30 questions.Your pass mark for the test is 60%. Good luck candidates."),

                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        goTo(context, GroupActivity());
                      },
                      child: Container(
                        width: appWidth(context),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        decoration: BoxDecoration(
                            color: Color(0XFF00C9B9),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(child: sText("Start Test",color: Colors.white,weight: FontWeight.w500)),
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

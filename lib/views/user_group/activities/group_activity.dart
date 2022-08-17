import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/views/user_group/test_instruction.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index){
                if(index == 0){
                  return GestureDetector(
                    onTap: (){
                      goTo(context, TestInstruction());
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                color: Colors.red,
                                width: 5,
                                height: 60,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sText("ANNOUNCEMENT",),
                                    SizedBox(height: 5,),
                                    Container(
                                       width: 150,
                                        child: sText("Prepare for your upcoming group test",weight: FontWeight.bold,size: 10),
                                    ),
                                    SizedBox(height: 10,),
                                    sText("RevShady SAT",weight: FontWeight.normal,size: 12),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    sText("03 : 59",weight: FontWeight.bold,color: Color(0XFF8ED4EB)),
                                    sText("remaining",weight: FontWeight.normal,size: 10),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    sText("10h",weight: FontWeight.normal),
                                    SizedBox(height: 20,),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else if(index == 1){
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              color: Colors.red,
                              width: 5,
                              height: 60,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("ANNOUNCEMENT",),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: 150,
                                    child: sText("Prepare for your upcoming group test",weight: FontWeight.bold,size: 10),
                                  ),
                                  SizedBox(height: 10,),
                                  sText("RevShady SAT",weight: FontWeight.normal,size: 12),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  sText("80%",weight: FontWeight.bold,color: Color(0XFF00C9B9)),
                                  sText("40 out of 50",weight: FontWeight.normal,size: 10),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  sText("10h",weight: FontWeight.normal),
                                  SizedBox(height: 20,),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.red,
                            width: 5,
                            height: 60,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sText("ANNOUNCEMENT",),
                                SizedBox(height: 5,),
                                sText("Prepare for your upcoming group test",weight: FontWeight.bold,size: 10),
                                SizedBox(height: 10,),
                                sText("RevShady SAT",weight: FontWeight.normal,size: 12),
                              ],
                            ),
                          ),

                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                sText("10h",weight: FontWeight.normal),
                                SizedBox(height: 20,),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
            }),
          )
        ],
      ),
    );
  }
}

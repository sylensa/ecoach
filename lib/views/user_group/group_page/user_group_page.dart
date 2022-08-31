import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_page/group_details.dart';
import 'package:ecoach/views/user_group/group_activities/no_activity.dart';
import 'package:ecoach/views/user_group/group_notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserGroupPage extends StatefulWidget {
  static const String routeName = '/user_group';
  UserGroupPage(this.user, {Key? key}) : super(key: key);
  User user;
  @override
  State<UserGroupPage> createState() => _UserGroupPageState();
}

class _UserGroupPageState extends State<UserGroupPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h,),
              decoration: BoxDecoration(
                color: Color(0XFFDBF1A8),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 3.h,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  sText("Hi, Victor",size: 20,weight: FontWeight.bold),
                                  SizedBox(width: 5,),
                                  Icon(Icons.hide_image,color: Colors.yellow,)
                                ],
                              ),
                              sText("Let's start learning!",size: 16,weight: FontWeight.w400),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            goTo(context, GroupNotificationActivity(widget.user));
                          },
                          child: Container(
                            child: Image.asset("assets/images/schedule_top.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only( right: 2.h,),

                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 0,right: 0,top: 0),
                            child:  TextField(
                              controller: searchController,
                              decoration: textDecorSuffix(
                                  size: 15,
                                  icon: Icon(Icons.search,color: Colors.grey),
                                  suffIcon: Icon(Icons.filter_alt,color: Colors.white,),
                                  label: "Search for learning groups",
                                  enabled: true
                              ),


                              onChanged:(val){
                              } ,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            goTo(context, NoGroupActivity(widget.user));
                          },
                            child: Image.asset("assets/images/schedule.png"),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                 Container(
                   padding: EdgeInsets.all(20),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // my groups
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             sText("My Groups",size: 16,weight: FontWeight.bold),
                             sText("See all",size: 16,color: Colors.grey[400]!),
                           ],
                         ),
                       ),
                       SizedBox(height: 10,),
                       Container(
                         height: 170,
                         child: ListView.builder(
                             itemCount: 10,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (BuildContext context, int index){
                               return Row(
                                 children: [
                                   Container(
                                     width: appWidth(context) * 0.7 ,
                                     padding: EdgeInsets.all(10),
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Container(
                                           padding: EdgeInsets.all(10),
                                           decoration: BoxDecoration(
                                               color: Colors.grey[100],
                                               borderRadius: BorderRadius.circular(10)
                                           ),
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Icon(Icons.arrow_back_ios,color: Colors.white,),
                                               Container(
                                                 width: 150,
                                                 child: sText("Physics Assignment due",weight: FontWeight.w500,size: 14,maxLines: 1),
                                               ),
                                               Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,),
                                             ],
                                           ),
                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   sText("Afram's SAT",weight: FontWeight.w500,size: 20),
                                                   SizedBox(height: 0,),
                                                   sText("by Mr. Afram Dzidefo",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                                 ],
                                               ),

                                               Row(
                                                 children: [
                                                   Center(
                                                     child: SizedBox(
                                                       height: 22,
                                                       width: 22,
                                                       child: Stack(
                                                         children: [
                                                           Container(
                                                             decoration: BoxDecoration(
                                                                 color: Color(0XFF00C9B9),
                                                                 shape: BoxShape.circle
                                                             ),
                                                           ),
                                                           Center(
                                                             child: Text(
                                                               "1",
                                                               style: TextStyle(
                                                                 fontSize: 12,
                                                                 color: Colors.white,
                                                                 fontWeight: FontWeight.bold
                                                               ),
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ],
                                           ),
                                         ),
                                         Container(
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   SizedBox(height: 10,),
                                                   Container(
                                                     child: Row(
                                                       children: [
                                                         Image.asset("assets/images/user_group.png"),
                                                         SizedBox(width: 5,),
                                                         sText("1,309 members",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                                       ],
                                                     ),
                                                   ),
                                                   SizedBox(height: 10,),
                                                   Container(
                                                     child: Row(
                                                       children: [
                                                         Image.asset("assets/images/calendar.png"),
                                                         SizedBox(width: 5,),
                                                         sText("20 days remaining",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                                       ],
                                                     ),
                                                   ),
                                                   SizedBox(height: 10,),
                                                 ],
                                               ),
                                               Container(
                                                 padding: EdgeInsets.all(10),
                                                 child: Icon(Icons.arrow_forward),
                                                 decoration: BoxDecoration(
                                                   color: Colors.grey[200],
                                                   borderRadius: BorderRadius.circular(10)
                                                 ),
                                               )
                                             ],
                                           ),
                                         )

                                       ],
                                     ),
                                   ),
                                   SizedBox(width: 10,),
                                 ],
                               );
                             }),
                       ),
                       // categories
                       SizedBox(height: 30,),
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             sText("Categories",size: 16,weight: FontWeight.bold),
                             sText("See all",size: 16,color: Colors.grey[400]!),
                           ],
                         ),
                       ),
                       Container(
                         height: 70,
                         child: ListView.builder(
                             itemCount: 4,
                             padding: EdgeInsets.zero,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (BuildContext context, int index){
                               return Row(
                                 children: [
                                   Container(
                                       width: 130 ,
                                       padding: EdgeInsets.all(10),
                                       decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(10),
                                       ),
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                          Image.asset("assets/images/lower.png"),
                                           sText("Ages 6-9",size: 16,weight: FontWeight.bold),
                                         ],
                                       )
                                   ),
                                   SizedBox(width: 10,),
                                 ],
                               );
                             }),
                       ),
                       SizedBox(height: 0,),
                     ],
                   ),
                 ),
                 Container(
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
                   ),
                   child: Column(
                     children: [
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 20),
                         height: 50,
                         child: ListView.builder(
                           padding: EdgeInsets.zero,
                             itemCount: 5,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (BuildContext context, int index){
                               if(index == 0){
                                 return Row(
                                   children: [
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                       decoration: BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.circular(20),
                                           border: Border.all(color: Colors.white)
                                       ),
                                       child: Image.asset("assets/images/up-and-down-arrow.png"),

                                     ),
                                     SizedBox(width: 10,),
                                   ],
                                 );
                               }
                               return Row(
                                 children: [
                                   Container(
                                     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(20),
                                         border: Border.all(color: Colors.black)
                                     ),
                                     child: sText("Popularity",size: 14,weight: FontWeight.normal,align: TextAlign.center),

                                   ),
                                   SizedBox(width: 5,),
                                 ],
                               );
                             }),
                       ),
                       Container(
                         color: Colors.grey[400],
                         width: appWidth(context),
                         height: 1,
                       ),
                       SizedBox(height: 10,),
                       for(int i =0; i < 10; i++)

                         MaterialButton(
                           padding: EdgeInsets.zero,
                           onPressed: (){
                             goTo(context, GroupDetails(widget.user));
                           },
                           child: Container(
                             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                             margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                             decoration: BoxDecoration(
                               color: Color(0XFFF5F5F5),
                               borderRadius: BorderRadius.circular(10)
                             ),
                             child: Row(
                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   child: Image.asset("assets/images/fCvBipe.png"),
                                 ),
                                 SizedBox(width: 5,),
                                 Container(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Container(
                                         child: Row(
                                           children: [
                                             Container(
                                               child: sText("RevShady SAT",size: 14,weight: FontWeight.bold),
                                             ),
                                             SizedBox(width: 5,),
                                             Container(
                                               child: sText("by Afram Dzidefo",size: 10,weight: FontWeight.normal,color: Colors.grey),
                                             ),
                                           ],
                                         ),
                                       ),
                                       Row(
                                         children: [
                                           Container(
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: Icon(Icons.groups,color: Colors.grey,size: 14,),
                                                 ),
                                                 SizedBox(width: 5,),
                                                 Container(
                                                   child: sText("2412",size: 10,weight: FontWeight.normal,),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           SizedBox(width: 5,),
                                           Container(
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: Icon(Icons.star,color: Colors.orange,size: 14,),
                                                 ),
                                                 SizedBox(width: 0,),
                                                 Container(
                                                   child: sText("4.0",size: 10,weight: FontWeight.w400,),
                                                 ),
                                                 SizedBox(width: 5,),
                                                 Container(
                                                   child: sText("(200 reviews)",size: 10,weight: FontWeight.normal,),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           SizedBox(width: 5,),
                                           Container(
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: Image.asset("assets/images/label.png"),
                                                 ),
                                                 SizedBox(width: 5,),
                                                 Container(
                                                   child: sText("\$99",size: 10,weight: FontWeight.bold,),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),
                                 Expanded(child: Container()),
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
                         )
                     ],
                   ),
                 )
                ],
              ),
            )
          ],
        ),

      ),

    );
  }
}

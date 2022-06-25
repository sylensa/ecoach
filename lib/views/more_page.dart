import 'dart:io';

import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/logout.dart';
import 'package:ecoach/views/profile_page.dart';
import 'package:ecoach/views/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  static const String routeName = '/more';
  const MorePage(this.user, {Key? key, required this.controller})
      : super(key: key);
  final User user;
  final MainController controller;
  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Container(
              margin: rightPadding(0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFCEFFE7),
                      borderRadius: BorderRadius.circular(64.0),
                      border: Border.all(
                        width: 2.0,
                        color: Color(0xFF00C664),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32.0,
                      backgroundColor: Colors.redAccent,
                      child: Text(widget.user.initials),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        widget.user.name != null ? properCase(widget.user.name!) : "",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color:  Color(0XFF2D3E50),
                          height: 1.1,
                        ),
                      ),

                    ],
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: rightPadding(0),
                    child: IconButton(onPressed: (){
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                            return Logout();
                          }), (route) => false);
                    }, icon: Icon(Icons.logout,color: Colors.black,)),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Divider(color: Colors.grey[200],),
            Expanded(
              flex: 7,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 20,top: 20,bottom: 20),
                      child: Row(
                        children: [
                          Icon(Icons.card_giftcard,color: Colors.black,),
                          SizedBox(width: 20,),
                          Text(
                            "Coupons",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color:  Color(0XFF2D3E50),
                              height: 1.1,
                              fontFamily: "Poppins"
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: 16,)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      goTo(context, SubscriptionPage(widget.user,controller: widget.controller,));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 20,top: 20,bottom: 20),
                      child: Row(
                        children: [
                          Icon(Icons.video_collection,color: Colors.black,),
                          SizedBox(width: 20,),
                          Text(
                            "Subscriptions",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color:  Color(0XFF2D3E50),
                                height: 1.1,
                                fontFamily: "Poppins"
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: 16,)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 20,top: 20,bottom: 20),
                      child: Row(
                        children: [
                          Icon(Icons.bookmark,color: Colors.black,),
                          SizedBox(width: 20,),
                          Text(
                             "Saved Questions",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color:  Color(0XFF2D3E50),
                                height: 1.1,
                                fontFamily: "Poppins"
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: 16,)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 20,top: 20,bottom: 20),
                      child: Row(
                        children: [
                          Icon(Icons.stars_rounded,color: Colors.black,),
                          SizedBox(width: 20,),
                          Text(
                             "Points",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color:  Color(0XFF2D3E50),
                                height: 1.1,
                                fontFamily: "Poppins"
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: 16,)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 20,top: 20,bottom: 20),
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on,color: Colors.black,),
                          SizedBox(width: 20,),
                          Text(
                           "Commissions",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color:  Color(0XFF2D3E50),
                                height: 1.1,
                                fontFamily: "Poppins"
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: 16,)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                        goTo(context, ProfilePage(user: widget.user,));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 20,top: 20,bottom: 20),
                      child: Row(
                        children: [
                          Icon(Icons.person,color: Colors.black,),
                          SizedBox(width: 20,),
                          Text(
                            "Profile",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color:  Color(0XFF2D3E50),
                                height: 1.1,
                                fontFamily: "Poppins"
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: 16,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: ()async{
                  customerCare();
                },
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFddfffc),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.headset_mic_outlined,color: Color(0xFF00C9B9),),
                      SizedBox(width: 20,),
                      Text(
                        "How can we help you?",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C9B9),
                            height: 1.1,
                            fontFamily: "Poppins"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

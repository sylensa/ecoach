import 'dart:io';

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadFailed extends StatefulWidget {
  const DownloadFailed({Key? key}) : super(key: key);

  @override
  State<DownloadFailed> createState() => _DownloadFailedState();
}

class _DownloadFailedState extends State<DownloadFailed> {

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset( "assets/images/sad.png"),
                  SizedBox(height: 40,),
                  sText("We're sorry the download file failed",size: 18,weight: FontWeight.normal,color: Color(0XFF2D3E50),align: TextAlign.center),
                  SizedBox(height: 10,),
                  sText("Please try again",size: 18,weight: FontWeight.normal,color: Color(0XFF2D3E50),align: TextAlign.center),
                ],
              ),



              Column(
                children: [
                  GestureDetector(
                    onTap: ()async{
                      customerCare();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      width: appWidth(context),
                      child: sText("Customer Care",color: Colors.white,size: 16,align: TextAlign.center,weight: FontWeight.bold),
                      decoration: BoxDecoration(
                          color: Color(0XFF00C9B9),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  sText("or",weight: FontWeight.bold,color: Color(0XFF2D3E50),align: TextAlign.center,size: 20),
                  SizedBox(height: 40,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      width: appWidth(context),
                      child: sText("Return to App",color: Colors.grey[400]!,size: 16,align: TextAlign.center,weight: FontWeight.bold),
                      decoration: BoxDecoration(
                          color: kAdeoGray,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

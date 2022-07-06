import 'dart:io';

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class PointsMainPage extends StatefulWidget {
  static const String routeName = '/group';
  PointsMainPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  State<PointsMainPage> createState() => _PointsMainPageState();
}

class _PointsMainPageState extends State<PointsMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: reviewBackgroundColors,
      appBar: AppBar(
        backgroundColor: Color(0xFF0367B4),
        automaticallyImplyLeading: Platform.isAndroid ? false  : true,
        elevation: 0,
        title: Platform.isIOS ? sText("Points",color: Colors.white,size: 25) : Container(),
      ),
      body: Container(
        child: Image.asset("assets/images/points_image.png",fit: BoxFit.fitWidth,width: appWidth(context),),
      ),
    );
  }
}

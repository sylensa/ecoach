import 'dart:io';

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class CoupounMainPage extends StatefulWidget {
  static const String routeName = '/group';
  CoupounMainPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  State<CoupounMainPage> createState() => _CoupounMainPageState();
}

class _CoupounMainPageState extends State<CoupounMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: reviewBackgroundColors,
      appBar: AppBar(
        backgroundColor: Color(0xFF0367B4),
        automaticallyImplyLeading: Platform.isAndroid ? false  : true,

        elevation: 0,
        title: Platform.isIOS ? sText("Coupon",color: Colors.white,size: 25) : Container(),
      ),
      body: Container(
        child: Image.asset("assets/images/coupon_image.png",fit: BoxFit.fitWidth,width: appWidth(context),),
      ),
    );
  }
}

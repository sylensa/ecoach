import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class GroupMainPage extends StatefulWidget {
  static const String routeName = '/group';
  GroupMainPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  State<GroupMainPage> createState() => _GroupMainPageState();
}

class _GroupMainPageState extends State<GroupMainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/images/group.png",fit: BoxFit.fitWidth,width: appWidth(context),),
    );
  }
}

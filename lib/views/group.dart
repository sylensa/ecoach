import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  static const String routeName = '/group';
  GroupPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/images/group.png",fit: BoxFit.fitWidth,width: appWidth(context),),
    );
  }
}

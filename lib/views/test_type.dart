import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class TestTypeView extends StatefulWidget {
  TestTypeView(this.user, this.course, {Key? key}) : super(key: key);
  User user;
  Course course;

  @override
  _TestTypeViewState createState() => _TestTypeViewState();
}

class _TestTypeViewState extends State<TestTypeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFFF6F6F6),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

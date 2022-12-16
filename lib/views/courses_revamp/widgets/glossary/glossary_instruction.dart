import 'dart:convert';

import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlossaryInstruction extends StatefulWidget {
  GlossaryInstruction({
    required this.user,
    required this.course,
    required this.listCourseKeywordsData,

    Key? key,
  }) : super(key: key);
  final User user;
  final Course course;
  List<CourseKeywords> listCourseKeywordsData;

  @override
  State<GlossaryInstruction> createState() => _GlossaryInstructionState();
}

class _GlossaryInstructionState extends State<GlossaryInstruction> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF00D289),
      appBar: AppBar(
        backgroundColor: Color(0XFF00D289),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            margin: topPadding(70),
            child: Image.asset(
              'assets/images/glossary_path.png',
              height: appHeight(context) * 0.7 ,
              width: appWidth(context) ,
              fit: BoxFit.fitHeight,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/saved_progress.png"),
                      SizedBox(width: 40,),
                      sText(
                        'Save progress',
                        weight: FontWeight.w500,
                        align: TextAlign.center,
                        color: Colors.white
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/save_definition.png"),
                      SizedBox(width: 40,),
                      sText(
                          'Save definitions',
                          weight: FontWeight.w500,
                          align: TextAlign.center,
                          color: Colors.white
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Image.asset("assets/images/add_comments.png"),
                      SizedBox(width: 40,),
                      sText(
                          'Add comments',
                          weight: FontWeight.w500,
                          align: TextAlign.center,
                          color: Colors.white
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Image.asset("assets/images/share_definitions.png"),
                      SizedBox(width: 40,),
                      sText(
                          'Share definitions',
                          weight: FontWeight.w500,
                          align: TextAlign.center,
                          color: Colors.white
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Center(
          child: Container(
            child: Column(
              children: [
                sText("Instructions",color: Colors.white,size: 30,weight: FontWeight.bold),
                SizedBox(height: 20,),

                Container(
                  child: sText("In this mode , you will be able to View both definitions and meanings at the same time",color: Colors.black,weight: FontWeight.bold,align: TextAlign.center,lHeight: 2),
                ),
                SizedBox(height: 20,),


              ],
            ),
          ),
        ),
          Positioned(
            bottom: 20,
            left: appWidth(context) * 0.3,
            child: GestureDetector(
              onTap: ()async{
                print(widget.course.id!);
                List<GlossaryData> listGlossaryData =  await GlossaryDB().getGlossariesById(widget.course.id!);

                print("listGlossaryData:${listGlossaryData[0].toJson()}");

                Get.to(() => GlossaryView(user: widget.user,course: widget.course,listGlossaryData: listGlossaryData,));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                child: sText("Start",color: Colors.white,weight: FontWeight.w500),
                decoration: BoxDecoration(
                    color: Color(0XFF15996B),
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}

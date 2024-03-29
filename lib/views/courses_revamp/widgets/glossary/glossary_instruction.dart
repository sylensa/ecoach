import 'dart:convert';

import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/glossary_progress_model.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_quiz_view.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_topic_study.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class GlossaryInstruction extends StatefulWidget {
  GlossaryInstruction({
    required this.user,
    required this.course,
    required this.listCourseKeywordsData,
    required this.studyGlossaryProgressData,
    required this.listTryGlossaryProgressData,
    this.topic,
    Key? key,
  }) : super(key: key);
  final User user;
  Topic? topic;
  final Course course;
  List<CourseKeywords> listCourseKeywordsData;
  GlossaryProgressData? studyGlossaryProgressData ;
  List<GlossaryProgressData> listTryGlossaryProgressData ;

  @override
  State<GlossaryInstruction> createState() => _GlossaryInstructionState();
}

class _GlossaryInstructionState extends State<GlossaryInstruction> {
  bool isViewed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Color(0XFF00D289),)),
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
              color: Color(0XFF00D289),
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
                Container(
                  color: Colors.white38,
                  height: 1,
                  width: 200,
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
                Container(
                  color: Colors.white38,
                  height: 1,
                  width: 200,
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
                Container(
                  color: Colors.white38,
                  height: 1,
                  width: 200,
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
                const SizedBox(height: 10),
                Container(
                  color: Colors.white38,
                  height: 1,
                  width: 200,
                ),
              ],
            ),
          ),
          Center(
          child: Container(
            child: Column(
              children: [
                sText("Instructions",color: Color(0XFF00D289),size: 30,weight: FontWeight.bold),
                SizedBox(height: 20,),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: sText("In this mode , you will be able to View both definitions and meanings at the same time",color: Colors.grey,weight: FontWeight.bold,align: TextAlign.center,lHeight: 2),
                ),
                SizedBox(height: 20,),


              ],
            ),
          ),
        ),

          Positioned(
            bottom: 20,
            child: Container(
              width: appWidth(context),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ConfirmationSlider(
                onConfirmation:()async{
                  print(widget.course.id!);
                  List<GlossaryData> listGlossaryData = [];
                  List topicIds = [];
                  print("isTopicSelected:$isTopicSelected");
                  // await GlossaryDB().deleteAllGlossaryTryProgress();

                  if(isViewed){
                    if(studySelected){
                      widget.studyGlossaryProgressData =   await GlossaryDB().getGlossaryStudyProgressByCourseId(widget.course.id!);
                    }else{
                      widget.listTryGlossaryProgressData =   await GlossaryDB().getGlossaryTryProgressByCourseId(widget.course.id!);
                    }
                  }
                  if(isTopicSelected){
                    // await GlossaryDB().deleteAllGlossaryTopic();
                    // await GlossaryDB().deleteAll();
                    listGlossaryData =  await GlossaryDB().getGlossariesByTopicId(widget.course.id!,[widget.topic!.id]);
                  }
                  else{
                    listGlossaryData =  await GlossaryDB().getGlossariesById(widget.course.id!);
                  }
                  if(listGlossaryData.isEmpty){
                    toastMessage("No glossary for this course");
                  }else{
                    if(studySelected){
                      if(widget.topic == null){
                        await  Get.to(() => GlossaryView(user: widget.user,course: widget.course,listGlossaryData: listGlossaryData,glossaryProgressData: widget.studyGlossaryProgressData,));
                      }else{
                        await  Get.to(() => GlossaryTopicView(user: widget.user,course: widget.course,listGlossaryData: listGlossaryData,glossaryProgressData: widget.studyGlossaryProgressData,topic: widget.topic,));
                      }
                      setState(() {
                        isViewed = true;
                      });
                    }else{
                      for(int glossaryIndex = 0; glossaryIndex < listGlossaryData.length; glossaryIndex++){
                        for(int progressIndex = 0; progressIndex < widget.listTryGlossaryProgressData.length; progressIndex++){
                          if(listGlossaryData[glossaryIndex].id == widget.listTryGlossaryProgressData[progressIndex].id){
                            listGlossaryData.removeAt(glossaryIndex);
                          }
                        }
                      }

                      await   Get.to(() => GlossaryQuizView(user: widget.user,course: widget.course,listGlossaryData: listGlossaryData,glossaryProgressData: widget.listTryGlossaryProgressData,));
                      setState(() {
                        isViewed = true;
                      });
                    }
                  }

                } ,
                backgroundColor: Colors.white,
                text: "Swipe to Start",
                textStyle: appStyle(col: Colors.grey,weight: FontWeight.bold,size: 18),
                shadow: BoxShadow(color: Colors.white,),
                iconColor: Color(0xFF0367B4),
                sliderButtonContent: Icon(Icons.keyboard_double_arrow_right,color: Colors.white,),
                stickToEnd: false,
                foregroundColor: Color(0XFF00D289),
                backgroundColorEnd:   Color(0XFF00D289),


              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}

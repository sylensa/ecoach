import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';

class ReadSavedQuestions extends StatefulWidget {
  ReadSavedQuestions(this.user,
      {Key? key, required this.course,this.questionCount = 0})
      : super(key: key);

  final Course course;
  User user;
  int questionCount;
  @override
  State<ReadSavedQuestions> createState() => _ReadSavedQuestionsState();
}

class _ReadSavedQuestionsState extends State<ReadSavedQuestions> {
  List<Question> question = [];
  bool progressCode = true;
  getSubscriptionItems() async{
    try{
      question  = await TestController().getSavedTests(widget.course,limit: widget.questionCount);
    }catch(e){
      print("error:$e");
    }
    setState(() {
      print("que:${question.length}");
      widget.questionCount = question.length;
      progressCode = false;
    });
  }

  @override
 void initState(){
    getSubscriptionItems();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color:  Color(0XFF2D3E50),)),
        title:    Text(
          "${widget.course.name}",
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color:  Color(0XFF2D3E50),
              height: 1.1,
              fontFamily: "Poppins"
          ),
        ),
        centerTitle: true,
      ),
      body: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                child: sText("${widget.questionCount} Questions",align: TextAlign.center,weight: FontWeight.bold,color: kAdeoGray3,size: 20),
              ),
            ),
            SizedBox(height: 20,),
            question.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: question.length,
                  itemBuilder: (BuildContext context, int index){
                  return Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30,right: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 280,

                                        child: AdeoHtmlTex(
                                          widget.user,
                                          question[index].text!.replaceAll("https", "http"),
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.left,
                                          fontSize: 16,
                                          useLocalImage: false,
                                          removeTags: question.contains("src") ? false : true,
                                          textColor: Color(0XFF707070),
                                        ),
                                      ),

                                      SizedBox(height: 10,),
                                      Container(
                                        width: 280,

                                        child: sText("${question[index].topicName}", color:  Color(0XFF2D3E50), weight: FontWeight.bold,align: TextAlign.right,size: 12,),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10,),
                                  Icon(Icons.arrow_forward_ios,color: kAdeoGray3,)
                                ],
                              ),


                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: sText("${index + 1}. ", color:  Color(0XFF2D3E50), weight: FontWeight.bold,align: TextAlign.right),
                        )
                      ],
                    ),
                  );
              }),
            ) :
            progressCode ?
            Expanded(   flex: 8,child: Center(child: progress()))
                :
            Expanded(   flex: 8,child: Center(child: sText("You've no saved questions",color:  Color(0XFF2D3E50),weight: FontWeight.bold,size: 16),)),

            GestureDetector(
              onTap:(){
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Saved questions",
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Text(
                        "Are you sure you want to remove these questions under this course from saved questions?",
                        style: TextStyle(color: Colors.black),
                        softWrap: true,
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async{
                            Navigator.pop(context);
                            await  QuestionDB().deleteSavedTestByCourseId(widget.course.id!);
                            setState((){
                              getSubscriptionItems();
                            });

                          },
                          child: Text("Yes"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
                decoration: BoxDecoration(
                    color: Color(0xFFFFEDEA),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_forever,color: Color(0xFFC25D47),),
                    SizedBox(width: 20,),
                    Text(
                      "Clear Saved Questions",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC25D47),
                          height: 1.1,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

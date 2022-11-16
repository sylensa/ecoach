import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/notes_read_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/notes_read.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/notes/note_view.dart';
import 'package:flutter/material.dart';

class NoteWidget extends StatefulWidget {
   NoteWidget({Key? key,required this.course,required this.user,required this.subscription, required this.controller, required this.topics}) : super(key: key);
  Course course;
  User user;
   Plan subscription;
   List<Topic> topics;
   final MainController controller;
  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  int selectedTopicIndex = 0;
  Course? course;
  // List<Topic> topics = [];
  bool topicsProgressCode = true;
  bool isTopicSelected = true;
  getNotesTopics()async{
    widget.topics = await TestController().getTopicsAndNotes(widget.course);
    setState(() {
      topicsProgressCode = false;
      print("topics:${widget.topics.length}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotesTopics();
  }
  @override
  Widget build(BuildContext context) {
    // getNotesTopics();
    return
      widget.topics.isNotEmpty ?
      Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount:  widget.topics.length,
                itemBuilder: (BuildContext context, int index){
                  return Column(
                    children: [
                      MaterialButton(
                        onPressed: (){
                          NotesReadDB().insert(NotesRead(
                              courseId:  widget.topics[index].courseId,
                              name:  widget.topics[index].name,
                              notes:  widget.topics[index].notes,
                              topicId:  widget.topics[index].id,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now()));

                          showDialog(
                              context: context,
                              builder: (context) {
                                return NoteView(widget.user, widget.topics[index]);
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: appWidth(context) * 0.70,
                                    child: sText("${widget.topics[index].name}"),
                                  ),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('assets/icons/courses/learn.png',width: 35,height: 35,),
                                  SizedBox(height: 10,),
                                  Container(
                                    child: Icon(Icons.check,color: Colors.white,),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                    ],
                  );
                }),
          ),


        ],
      ) :
      topicsProgressCode ?
      Center(child: progress()) :
      MaterialButton(
        onPressed: ()async{
          await goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: widget.subscription,));
          setState(() {
            widget.topics.clear();
            topicsProgressCode = true;
            getNotesTopics();
          });

        },
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            width: appWidth(context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                sText(""),
                Container(
                  width: appWidth(context) * 0.70,
                  child: sText("DOWNLOAD ${course != null ? course!.name : widget.course.name}  TOPICS",color: kAdeoGray3,weight: FontWeight.bold,size: 16,align: TextAlign.left),
                ),
                SizedBox(width: 10,),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ) ;
  }
}

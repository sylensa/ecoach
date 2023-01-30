import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/glossary_progress_model.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_countdown.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_instruction.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlossaryTopics extends StatefulWidget {
  List<GlossaryData> glossaryData = [];
  Course course;
  User user;
  List<CourseKeywords> listCourseKeywordsData;
   GlossaryTopics({Key? key,required this.glossaryData,required this.course, required this.user,required this.listCourseKeywordsData}) : super(key: key);

  @override
  State<GlossaryTopics> createState() => _GlossaryTopicsState();
}

class _GlossaryTopicsState extends State<GlossaryTopics> {
  GlossaryProgressData? glossaryProgressData ;
  var continueSelected;
  List<GlossaryProgressData> listGlossaryProgressData = [];
  List<Topic> topics = [];

  studyTryModalBottomSheet(context,Topic topic) async{
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sText("Full Course",
                                    color: kAdeoGray3,
                                    weight: FontWeight.w500,
                                    align: TextAlign.center,
                                    size: 20),
                                sText("${widget.glossaryData.length} terms",
                                    color: kAdeoGray3,
                                    weight: FontWeight.bold,
                                    align: TextAlign.center,
                                    size: 20),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Center(
                                child: Image.asset("assets/icons/courses/sort-az.png")),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      MaterialButton(
                        onPressed: ()async{
                          print("object");
                          stateSetter(() {
                            studySelected = true;
                          });
                          showLoaderDialog(context);
                          glossaryProgressData =   await GlossaryDB().getGlossaryStudyProgressByCourseIdTopicId(widget.course.id!,topic.id!);
                          Navigator.pop(context);
                          if(glossaryProgressData != null){
                            Navigator.pop(context);
                            continueRestartModalBottomSheet(context,topic);
                          }else{
                            Navigator.pop(context);
                            Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,studyGlossaryProgressData: glossaryProgressData,listTryGlossaryProgressData: [],topic: topic,));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          width: appWidth(context),
                          child: sText("Study",color:  studySelected == true ? Colors.white : Colors.black,weight: FontWeight.w500,size: 25,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color: studySelected == true  ? Colors.green : Colors.white,
                              border: Border.all(color: studySelected  == true ? Colors.transparent : Colors.black,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),

                      MaterialButton(
                        onPressed: (){
                          stateSetter(() {
                            studySelected = false;
                          });
                          Navigator.pop(context);
                          scoreNonScoreModalBottomSheet(context,topic);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          width: appWidth(context),
                          child: sText("Try",color:  studySelected == false ? Colors.white : Colors.black,weight: FontWeight.w500,size: 25,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color: studySelected  == false ? Colors.green : Colors.white,
                              border: Border.all(color: studySelected  == false ? Colors.transparent : Colors.black,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      )

                    ],
                  ));
            },
          );
        });
  }

  continueRestartModalBottomSheet(context,Topic topic) {
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sText("Full Course",
                                    color: kAdeoGray3,
                                    weight: FontWeight.w500,
                                    align: TextAlign.center,
                                    size: 20),
                                sText("${widget.glossaryData.length} terms",
                                    color: kAdeoGray3,
                                    weight: FontWeight.bold,
                                    align: TextAlign.center,
                                    size: 20),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Center(
                                child: Image.asset("assets/icons/courses/sort-az.png")),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      MaterialButton(
                        onPressed: ()async{
                          if(studySelected){
                            glossaryProgressData =   await GlossaryDB().getGlossaryStudyProgressByCourseIdTopicId(widget.course.id!,topic.id!);
                            if(glossaryProgressData != null){
                              stateSetter(() {
                                continueSelected = true;
                              });
                              Navigator.pop(context);
                              Get.to(() => GlossaryCountdown(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,studyGlossaryProgressData: glossaryProgressData,listTryGlossaryProgressData: [],topic: topic,));
                            }else{
                              toastMessage("You've no save progress");
                            }
                          }else{
                            listGlossaryProgressData=   await GlossaryDB().getGlossaryTryProgressByCourseIdTopicId(widget.course.id!,topic.id!);
                            if(listGlossaryProgressData.isNotEmpty){
                              stateSetter(() {
                                continueSelected = true;
                              });
                              Navigator.pop(context);
                              Get.to(() => GlossaryCountdown(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,listTryGlossaryProgressData: listGlossaryProgressData,studyGlossaryProgressData: null,topic: topic,));
                            }else{
                              toastMessage("You've no save progress");
                            }
                          }


                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          width: appWidth(context),
                          child: sText("Continue",color:  continueSelected == true ? Colors.white : Colors.black,weight: FontWeight.w500,size: 25,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color: continueSelected == true  ? Colors.green : Colors.white,
                              border: Border.all(color: continueSelected  == true ? Colors.transparent : Colors.black,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),

                      MaterialButton(
                        onPressed: ()async{
                          if(studySelected){
                            await GlossaryDB().deleteGlossaryStudyProgress(widget.course.id!);
                          }else{
                            await GlossaryDB().deleteGlossaryTryProgress(widget.course.id!);
                          }
                          stateSetter(() {
                            continueSelected = false;
                          });
                          Navigator.pop(context);
                          Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,studyGlossaryProgressData: null,listTryGlossaryProgressData: [],topic: topic,));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          width: appWidth(context),
                          child: sText("Restart",color:  continueSelected == false ? Colors.white : Colors.black,weight: FontWeight.w500,size: 25,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color: continueSelected  == false ? Colors.green : Colors.white,
                              border: Border.all(color: continueSelected  == false ? Colors.transparent : Colors.black,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      )

                    ],
                  ));
            },
          );
        });
  }

  scoreNonScoreModalBottomSheet(context,Topic topic) {
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sText("Full Course",
                                    color: kAdeoGray3,
                                    weight: FontWeight.w500,
                                    align: TextAlign.center,
                                    size: 20),
                                sText("${ widget.glossaryData.length} terms",
                                    color: kAdeoGray3,
                                    weight: FontWeight.bold,
                                    align: TextAlign.center,
                                    size: 20),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Center(
                                child: Image.asset("assets/icons/courses/sort-az.png")),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: ()async{
                          print("object");
                          stateSetter(() {
                            scoreSelected = true;
                          });
                          showLoaderDialog(context);
                          listGlossaryProgressData =   await GlossaryDB().getGlossaryTryProgressByCourseIdTopicId(widget.course.id!,topic.id!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          if(listGlossaryProgressData.isNotEmpty){
                            continueRestartModalBottomSheet(context,topic);
                          }else{
                            Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,listTryGlossaryProgressData: listGlossaryProgressData,studyGlossaryProgressData: null,topic: topic,));
                          }

                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          width: appWidth(context),
                          child: sText("Score",color:  scoreSelected == true ? Colors.white : Colors.black,weight: FontWeight.w500,size: 25,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color: scoreSelected == true  ? Colors.green : Colors.white,
                              border: Border.all(color: scoreSelected  == true ? Colors.transparent : Colors.black,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),

                      MaterialButton(
                        onPressed: ()async{
                          stateSetter(() {
                            scoreSelected = false;
                          });
                          print("object");
                          showLoaderDialog(context);
                          listGlossaryProgressData =   await GlossaryDB().getGlossaryTryProgressByCourseIdTopicId(widget.course.id!,topic.id!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          if(listGlossaryProgressData.isNotEmpty){
                            continueRestartModalBottomSheet(context,topic);
                          }else{
                            Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,listTryGlossaryProgressData: listGlossaryProgressData,studyGlossaryProgressData: null,topic: topic,));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          width: appWidth(context),
                          child: sText("Non-Score",color:  scoreSelected == false ? Colors.white : Colors.black,weight: FontWeight.w500,size: 25,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color: scoreSelected  == false ? Colors.green : Colors.white,
                              border: Border.all(color: scoreSelected  == false ? Colors.transparent : Colors.black,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      )

                    ],
                  ));
            },
          );
        });
  }
  getGlossaryTopics() async {
    topics = await TestController().getTopicsAndNotes(widget.course);
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGlossaryTopics();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5FA),
      appBar: AppBar(
        title: sText("Topics",size: 18, weight: FontWeight.bold),
        backgroundColor: Color(0xFFF2F5FA),
        centerTitle: true,
        elevation: 0,

      ),
      body: Column(
        children: [
          topics.isNotEmpty ?
               Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 26, bottom: 12),
                itemCount:topics.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return MaterialButton(
                    onPressed: () async {
                      showLoaderDialog(context);
                      widget.glossaryData =   await GlossaryDB().getGlossariesByTopicId(widget.course.id!,[topics[index].id]);
                      Navigator.pop(context);
                      if( widget.glossaryData .isNotEmpty){
                        studyTryModalBottomSheet(context,topics[index]);
                      }else{
                        toastMessage("Empty terms");
                      }

                    },
                    child: Column(
                      children: [
                        Container(
                          width: appWidth(context),
                          constraints: BoxConstraints(minHeight: 70),
                          padding: EdgeInsets.all(18),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: sText(
                                    "${topics[index].name}",
                                    weight: FontWeight.w600,
                                    size: 15,
                                    color: kAdeoDark,
                                    align: TextAlign.left,
                                    lHeight: 1.8),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF2F5FA),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey.shade400,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ) :
              Expanded(child: Center(child: progress()))

        ],
      ),
    );
  }
}

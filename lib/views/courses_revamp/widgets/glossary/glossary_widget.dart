import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/performance_gragh.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/conquest_test_taken_db.dart';
import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/glossary_progress_model.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_introit.dart';
import 'package:ecoach/views/conquest/conquest_onboarding.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_countdown.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_instruction.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_view.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/personalised_saved/index.dart';
import 'package:ecoach/views/courses_revamp/widgets/knowledge_test/topic_test.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/keyword/keyword_assessment.dart';
import 'package:ecoach/views/keyword/keyword_graph.dart';
import 'package:ecoach/views/keyword/keyword_quiz_cover.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/review/review_onboarding.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/speed/speed_quiz_cover.dart';
import 'package:ecoach/views/test/test_challenge_list.dart';
import 'package:ecoach/views/test/test_type_list.dart';
import 'package:ecoach/views/treadmill/treadmill_save_resumption_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GlossaryWidget extends StatefulWidget {
  GlossaryWidget(
      {Key? key,
        required this.course,
        required this.user,
        required this.subscription,
        required this.controller,
        required this.listCourseKeywordsData,
        required this.glossaryData,
        required this.glossaryProgressData,
      })
      : super(key: key);
  Course course;
  User user;
  Plan subscription;
 
  List<GlossaryData> glossaryData = [];
  List<CourseKeywords> listCourseKeywordsData;
  GlossaryProgressData? glossaryProgressData ;
  final MainController controller;

  @override
  State<GlossaryWidget> createState() => _GlossaryWidgetState();
}

class _GlossaryWidgetState extends State<GlossaryWidget> {

 var continueSelected;
 TextEditingController searchGlossaryController = TextEditingController();
 String searchGlossary = '';
 bool searchTap = false;
 List<GlossaryData> searchGlossaryData = [];
 getAllGlossaryData()async{
   allGlossaryData =   await GlossaryDB().getGlossariesById(widget.course.id!);
   setState(() {
      print("allGlossaryData:${allGlossaryData.length}");
   });

 }

  studyTryModalBottomSheet(context,) async{
    widget.glossaryData =   await GlossaryDB().getGlossariesById(widget.course.id!);
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
                          widget.glossaryProgressData =   await GlossaryDB().getGlossaryStudyProgressByCourseId(widget.course.id!);
                          Navigator.pop(context);
                          if(widget.glossaryProgressData != null){
                            Navigator.pop(context);
                            continueRestartModalBottomSheet(context);
                          }else{
                            Navigator.pop(context);
                            Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,glossaryProgressData: widget.glossaryProgressData,));
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
                          scoreNonScoreModalBottomSheet(context);
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

 continueRestartModalBottomSheet(context,) {
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
                           widget.glossaryProgressData =   await GlossaryDB().getGlossaryStudyProgressByCourseId(widget.course.id!);
                           if(widget.glossaryProgressData != null){
                             stateSetter(() {
                               continueSelected = true;
                             });
                             Get.to(() => GlossaryCountdown(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,glossaryProgressData: widget.glossaryProgressData,));
                           }else{
                             toastMessage("You've no save progress");
                           }
                         }else{
                           widget.glossaryProgressData =   await GlossaryDB().getGlossaryTryProgressByCourseId(widget.course.id!);
                           if(widget.glossaryProgressData != null){
                             stateSetter(() {
                               continueSelected = true;
                             });
                             Get.to(() => GlossaryCountdown(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,glossaryProgressData: widget.glossaryProgressData,));
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
                         await GlossaryDB().deleteGlossaryTryProgress(widget.course.id!);
                         stateSetter(() {
                           continueSelected = false;
                         });
                         Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,glossaryProgressData: null,));
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

 scoreNonScoreModalBottomSheet(
     context,
     ) {
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
                         widget.glossaryProgressData =   await GlossaryDB().getGlossaryTryProgressByCourseId(widget.course.id!);
                         Navigator.pop(context);
                         Navigator.pop(context);
                         if(widget.glossaryProgressData != null){
                           continueRestartModalBottomSheet(context);
                         }else{
                           Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,glossaryProgressData: widget.glossaryProgressData,));
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
                         widget.glossaryProgressData =   await GlossaryDB().getGlossaryTryProgressByCourseId(widget.course.id!);
                         Navigator.pop(context);
                         Navigator.pop(context);
                         if(widget.glossaryProgressData != null){
                           continueRestartModalBottomSheet(context);
                         }else{
                           Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,glossaryProgressData: widget.glossaryProgressData,));
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

 searchGlossaryModalBottomSheet(
     context,
     ) async {
   searchGlossaryDefinition(String definition)async{
     if(allGlossaryData.isEmpty){
       allGlossaryData =   await GlossaryDB().getGlossariesById(widget.course.id!);
     }
     searchGlossaryData.clear();
     for(int i =0; i < allGlossaryData.length; i++){
       if(allGlossaryData[i].term!.toLowerCase().contains(definition.toLowerCase())){
         searchGlossaryData.add(allGlossaryData[i]);
       }
     }


   }
   showModalBottomSheet(
       context: context,
       isDismissible: true,
       backgroundColor: Colors.transparent,
       isScrollControlled: true,
       builder: (BuildContext context) {
         return StatefulBuilder(
           builder: (BuildContext context, StateSetter stateSetter) {
             return AnimatedContainer(
                 padding: EdgeInsets.symmetric(horizontal: 10),
                 height: appHeight(context) * 0.7,

                 decoration: BoxDecoration(
                   color: kAdeoGray4,
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(24),
                     topRight: Radius.circular(24),
                   ),
                 ),
                 duration: Duration(milliseconds: 20),
                 curve: Curves.easeInOut,
                 child: Column(
                   children: [
                     SizedBox(
                       height: 20,
                     ),
                     Container(
                       color: Colors.grey,
                       height: 3,
                       width: 84,
                     ),
                     SizedBox(
                       height: 20,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 20),
                           child: Center(
                               child: Image.asset(
                                 'assets/icons/courses/glossary.png',
                                 width: 30,
                                 height: 30,
                               )),
                         ),
                       ],
                     ),
                     SizedBox(
                       height: 10,
                     ),
                     Container(
                       padding: EdgeInsets.symmetric(horizontal: 20),
                       child: sText(
                         "Glossary Search",
                         color: Colors.black,
                         weight: FontWeight.w400,
                         align: TextAlign.center,
                         size: 24,
                       ),
                     ),
                     SizedBox(
                       height: 20,
                     ),
                     Container(
                       padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                       child: TextFormField(
                         controller: searchGlossaryController,
                         onChanged: (String value) async {
                           stateSetter(() {
                             if(value.isEmpty){
                               searchGlossaryData.clear();
                               searchGlossary = '';
                             }else{
                               searchGlossary = value.trim();

                             }

                           });
                          await searchGlossaryDefinition(searchGlossary);
                           stateSetter(() {

                           });
                         },
                         decoration: textDecorSuffix(
                           fillColor: Color(0xFFEEEEEE),
                           showBorder: false,
                           size: 60,
                           icon: IconButton(
                               onPressed: () async {

                               },
                               icon: Icon(
                                 Icons.search,
                                 color: Colors.grey,
                               )),
                           suffIcon: null,
                           label: "Search definitions",
                           enabled: true,
                         ),
                       ),
                     ),


                       Expanded(
                         child: Container(
                             child: Padding(
                               padding: EdgeInsets.only(
                                 left: 20.0,
                                 right: 15.0,
                                 top: 26,
                                 bottom: 14,
                               ),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   SingleChildScrollView(
                                     child: Container(
                                       child: searchGlossary.isEmpty
                                           ?
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           sText("Recent Searches", weight: FontWeight.w600),
                                           SizedBox(
                                             height: 10,
                                           ),
                                          Container(
                                            color: Colors.grey[400],
                                            width: appWidth(context) * 0.85,
                                            height: 2,
                                          ),
                                           SizedBox(
                                             height: 20,
                                           ),
                                            for(int i =0; i <allGlossaryData.length; i++)
                                              GestureDetector(
                                                onTap: ()async{
                                                  await  Get.to(() => GlossaryView(user: widget.user,course: widget.course,listGlossaryData: [allGlossaryData[i]],glossaryProgressData: null,));

                                                },
                                                child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  sText("${properCase(allGlossaryData[i].term!)}",color: Colors.black,weight: FontWeight.bold),
                                                  sText("${allGlossaryData[i].keywordAppearance} appearances",color: Colors.grey,weight: FontWeight.w500),
                                                  SizedBox(height: 10,),
                                                ],
                                            ),
                                              )
                                         ],
                                       )
                                           :
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           sText("Searches Results", weight: FontWeight.w600),
                                           SizedBox(
                                             height: 10,
                                           ),
                                           Container(
                                             color: Colors.grey[400],
                                             width: appWidth(context) * 0.85,
                                             height: 2,
                                           ),
                                           SizedBox(
                                             height: 20,
                                           ),
                                           for(int i =0; i <searchGlossaryData.length; i++)
                                             GestureDetector(
                                               onTap: ()async{
                                                 await  Get.to(() => GlossaryView(user: widget.user,course: widget.course,listGlossaryData: [searchGlossaryData[i]],glossaryProgressData: null,));
                                               },
                                               child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   sText("${properCase(searchGlossaryData[i].term!)}",color: Colors.black,weight: FontWeight.bold),
                                                   sText("${searchGlossaryData[i].keywordAppearance} appearances",color: Colors.grey,weight: FontWeight.w500),
                                                   SizedBox(height: 10,),
                                                 ],
                                               ),
                                             )
                                         ],
                                       )
                                     ),
                                   ),

                                 ],
                               ),
                             )),
                       ),

                   ],
                 ));
           },
         );
       });
 }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllGlossaryData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        MultiPurposeCourseCard(
          title: 'Full Course',
          subTitle: 'from A-Z, all terms throughout the course',
          iconURL: 'assets/icons/courses/sort-az.png',
          onTap: () async {
            if(checkQuestions.isEmpty){
              showLoaderDialog(context);
              checkQuestions  = await QuestionDB().getQuestionsByCourseId(widget.course.id!);
              Navigator.pop(context);
              if (checkQuestions.isNotEmpty) {
                isTopicSelected = false;
                studyTryModalBottomSheet(context);
              }
              else {
                showDialogYesNo(
                    context: context,
                    message: "Download questions for ${widget.course.name}",
                    target: BuyBundlePage(
                      widget.user,
                      controller: widget.controller,
                      bundle: widget.subscription,
                    ));
              }
            }else{
              isTopicSelected = false;
              studyTryModalBottomSheet(context);
            }

          },
        ),
        MultiPurposeCourseCard(
          title: 'Topics',
          subTitle: 'Terms based on topics',
          iconURL: 'assets/icons/courses/alphabet.png',
          onTap: () async {
            if(checkQuestions.isEmpty){
              showLoaderDialog(context);
              checkQuestions  = await QuestionDB().getQuestionsByCourseId(widget.course.id!);
              Navigator.pop(context);
              if (checkQuestions.isNotEmpty) {
                isTopicSelected = true;
                studyTryModalBottomSheet(context);
              }
              else {
                showDialogYesNo(
                    context: context,
                    message: "Download questions for ${widget.course.name}",
                    target: BuyBundlePage(
                      widget.user,
                      controller: widget.controller,
                      bundle: widget.subscription,
                    ));
              }
            }else{
              isTopicSelected = true;
              studyTryModalBottomSheet(context);
            }


          },
        ),
        MultiPurposeCourseCard(
          title: 'Saved',
          subTitle: 'Definitions that matter to you',
          iconURL: 'assets/icons/courses/quest.png',
          onTap: () async {
            if(checkQuestions.isEmpty){
              showLoaderDialog(context);
              checkQuestions  = await QuestionDB().getQuestionsByCourseId(widget.course.id!);
              Navigator.pop(context);
              if (checkQuestions.isNotEmpty) {
                Get.to(() => PersonalisedSavedPage(currentIndex: 1,course: widget.course,user: widget.user,));
              }
              else {
                showDialogYesNo(
                    context: context,
                    message: "Download questions for ${widget.course.name}",
                    target: BuyBundlePage(
                      widget.user,
                      controller: widget.controller,
                      bundle: widget.subscription,
                    ));
              }
            }else{
              Get.to(() => PersonalisedSavedPage(currentIndex: 1,course: widget.course,user: widget.user,));
            }

          },
        ),
        MultiPurposeCourseCard(
          title: 'Personalised',
          subTitle: 'Create and view definitions',
          iconURL: 'assets/icons/courses/idea.png',
          onTap: () async {
            if(checkQuestions.isEmpty){
              showLoaderDialog(context);
              checkQuestions  = await QuestionDB().getQuestionsByCourseId(widget.course.id!);
              Navigator.pop(context);
              if (checkQuestions.isNotEmpty) {
                Get.to(() => PersonalisedSavedPage(currentIndex: 0,course: widget.course,user: widget.user,));
              }
              else {
                showDialogYesNo(
                    context: context,
                    message: "Download questions for ${widget.course.name}",
                    target: BuyBundlePage(
                      widget.user,
                      controller: widget.controller,
                      bundle: widget.subscription,
                    ));
              }
            }else{
              Get.to(() => PersonalisedSavedPage(currentIndex: 0,course: widget.course,user: widget.user,));
            }

          },
        ),
        MultiPurposeCourseCard(
          title: 'Quick Search',
          subTitle: 'Create and view definitions',
          iconURL: 'assets/icons/courses/search.png',
          onTap: () async {
            if(checkQuestions.isEmpty){
              showLoaderDialog(context);
              checkQuestions  = await QuestionDB().getQuestionsByCourseId(widget.course.id!);
              Navigator.pop(context);
              if (checkQuestions.isNotEmpty) {
                searchGlossaryModalBottomSheet(context);
              }
              else {
                showDialogYesNo(
                    context: context,
                    message: "Download questions for ${widget.course.name}",
                    target: BuyBundlePage(
                      widget.user,
                      controller: widget.controller,
                      bundle: widget.subscription,
                    ));
              }
            }else{
              searchGlossaryModalBottomSheet(context);
            }

          },
        ),

      ],
    );
  }
}



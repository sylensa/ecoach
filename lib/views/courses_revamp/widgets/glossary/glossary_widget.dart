import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/performance_gragh.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/conquest_test_taken_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_introit.dart';
import 'package:ecoach/views/conquest/conquest_onboarding.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_countdown.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_instruction.dart';
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
        required this.listCourseKeywordsData
      })
      : super(key: key);
  Course course;
  User user;
  Plan subscription;
  List<CourseKeywords> listCourseKeywordsData;
  final MainController controller;

  @override
  State<GlossaryWidget> createState() => _GlossaryWidgetState();
}

class _GlossaryWidgetState extends State<GlossaryWidget> {
 var studySelected;
 var continueSelected;
 var scoreSelected;
  studyTryModalBottomSheet(
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
                                sText("2000 terms",
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
                        onPressed: (){
                          stateSetter(() {
                            studySelected = true;
                          });
                          continueRestartModalBottomSheet(context);
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

 continueRestartModalBottomSheet(
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
                               sText("2000 terms",
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
                       onPressed: (){
                         stateSetter(() {
                           continueSelected = true;
                         });
                            Get.to(() => GlossaryCountdown(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,));
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
                       onPressed: (){
                         stateSetter(() {
                           continueSelected = false;
                         });
                         Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,));
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
                               sText("2000 terms",
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
                       onPressed: (){
                         stateSetter(() {
                           scoreSelected = true;
                         });
                         Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,));
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
                       onPressed: (){
                         stateSetter(() {
                           scoreSelected = false;
                         });
                         Get.to(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,));
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            List<Question> questions =
            await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              studyTryModalBottomSheet(context);
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Topics',
          subTitle: 'Terms based on topics',
          iconURL: 'assets/icons/courses/alphabet.png',
          onTap: () async {
            List<Question> questions =
            await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              setState(() {});
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }

          },
        ),
        MultiPurposeCourseCard(
          title: 'Saved',
          subTitle: 'Definitions that matter to you',
          iconURL: 'assets/icons/courses/quest.png',
          onTap: () async {
            List<Question> questions =
            await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Get.to(() => PersonalisedSavedPage(currentIndex: 1,));
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Personalised',
          subTitle: 'Create and view definitions',
          iconURL: 'assets/icons/courses/idea.png',
          onTap: () async {
            List<Question> questions =
            await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
             Get.to(() => PersonalisedSavedPage(currentIndex: 0,));
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Quick Search',
          subTitle: 'Create and view definitions',
          iconURL: 'assets/icons/courses/search.png',
          onTap: () async {
            List<Question> questions =
            await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AutopilotIntroit(widget.user, widget.course);
                  },
                ),
              );
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),

      ],
    );
  }
}



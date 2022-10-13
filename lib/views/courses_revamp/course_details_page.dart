import 'dart:convert';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/notes_read_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/notes_read.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/report.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/autopilot/autopilot_introit.dart';
import 'package:ecoach/views/autopilot/autopilot_topic_menu.dart';
import 'package:ecoach/views/courses_revamp/widgets/games_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/learn_mode_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/live_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/note_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/progress_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/test_type_widget.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/notes/note_view.dart';
import 'package:ecoach/views/notes/notes_topics.dart';
import 'package:ecoach/views/review/review_onboarding.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/test/test_challenge_list.dart';
import 'package:ecoach/views/treadmill/treadmill_save_resumption_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoursesDetailsPage extends StatefulWidget {
  static const String routeName = '/courses/details1';
  CoursesDetailsPage({Key? key, required this.courses,required this.user,required this.subscription,required this.controller,}) : super(key: key);
  List<Course> courses;
   Plan subscription;
  User user;
   final MainController controller;
  @override

  State<CoursesDetailsPage> createState() => _CoursesDetailsPageState();
}

class _CoursesDetailsPageState extends State<CoursesDetailsPage> {
  List<CourseDetail> listCourseDetails = [];
  int _currentPage = 0;
  int selectedTopicIndex = 0;
  Course? course;
  List<Topic> topics = [];
  bool topicsProgressCode = true;
  bool isTopicSelected = true;
  PageController pageController = PageController();
  Future? stats;
  Map<String, Widget> getPage() {
    switch (_currentPage) {
      case 0:
        return {'Learn Mode': LearnModeWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course!,)};
      case 1:
        return {'Note': NoteWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course!,topics: topics,)};

      case 2:
        return {'Test Type': TestTypeWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course!,)};

      case 3:
        return {'Live': LiveWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course!,)};
      case 4:
        return {'Games': GameWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course!,)};

      case 5:
        return {'Progress': ProgressWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course!,stats: stats,)};

    }
    return {'': Container()};
  }
  List<CourseDetail> courseDetails = [
    CourseDetail(
      title: 'Learn',
      subTitle: 'Different modes to help you master a course',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Notes',
      subTitle: 'Self-explanatory notes on various topics',
      iconURL: 'assets/icons/courses/notes.png',
    ),
    CourseDetail(
      title: 'Tests',
      subTitle: 'Different test modes to get you exam-ready',
      iconURL: 'assets/icons/courses/tests.png',
    ),
    CourseDetail(
      title: 'Live',
      subTitle: 'Live sessions',
      iconURL: 'assets/icons/courses/live.png',
    ),
    CourseDetail(
      title: 'Games',
      subTitle: 'Educational games based on the course',
      iconURL: 'assets/icons/courses/games.png',
    ),
    CourseDetail(
      title: 'Progress',
      subTitle: 'Track your progress',
      iconURL: 'assets/icons/courses/progress.png',
    ),
  ];
  List<CourseDetail> learnModeDetails = [
    CourseDetail(
      title: 'Revision',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Course Completion',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Speed Enhancement',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Matery Improvement',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
  ];

    getNotesTopics(Course course)async{
      topics = await TestController().getTopicsAndNotes(course);
      setState(() {
        topicsProgressCode = false;
          print("topics:${topics.length}");
      });
    }
    getAnalysisStats(){
      SubscriptionItemDB().allSubscriptionItems().then((List<SubscriptionItem> subscriptions) {
        if (subscriptions.length > 0) {
          stats = getCourseStats(course!.id!);
        }

        setState(() {

        });
      });
    }
  getCourseStats(int courseId) {
    return ApiCall<Report>(
      AppUrl.report,
      user: widget.user,
      params: {'course_id': jsonEncode(courseId)},
      isList: false,
      create: (data) {
        setState((){
        });
        return Report.fromJson(data);
      },
    ).get(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotesTopics(widget.courses[0]);
    course = widget.courses[0];
    listCourseDetails.add(courseDetails[0]);
    getAnalysisStats();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:kAdeoGray,
      body: Container(
        padding: EdgeInsets.only(top: 5.h, bottom: 2.h,),
      child: Column(
          children: [
            Row(
              children: [
               IconButton(onPressed: (){
                Navigator.pop(context);
               }, icon: Icon(Icons.arrow_back,color: Colors.black,),),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kHomeBackgroundColor,
                          border: Border.all(color: kHomeBackgroundColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(right: 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Course>(
                          value:course == null ? widget.courses[0] : course,
                          itemHeight: 50,
                          style: TextStyle(
                            fontSize: 16,
                            color: kDefaultBlack,
                          ),
                          onChanged: (Course? value)async{
                            setState((){
                              topics.clear();
                              topicsProgressCode = true;
                              course = value;
                              getAnalysisStats();
                            });
                           await getNotesTopics(course!);
                          },
                          items: widget.courses.map(
                                (item) => DropdownMenuItem<Course>(
                              value: item,
                              child: Container(
                                width: appWidth(context) * 0.54,
                                child: sText(
                                  "${item.name}",
                                 color: kAdeoGray3,
                                  size: 18,
                                  align: TextAlign.center
                                ),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                    margin: rightPadding(20),
                    height: 50,
                    child: Icon(Icons.school,color: kAdeoGray3,),
                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                      color: kHomeBackgroundColor
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height:20,),
            Container(
              height: 120,
              padding: EdgeInsets.only(left: 2.h,top: 2.h,bottom: 2.h),

              color: kHomeBackgroundColor,
              child:  ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: courseDetails.length,
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  itemBuilder: (BuildContext context, int index){
                    return    GestureDetector(
                      onTap: (){
                        if(index >= _currentPage){
                          pageController.animateTo(appWidth(context)/10, duration: new Duration(microseconds: 1), curve: Curves.easeIn);
                        }else{
                          pageController.jumpTo(0.0);
                        }
                        setState(() {
                          _currentPage = index;
                          if(!listCourseDetails.contains(courseDetails[index])){
                            listCourseDetails.clear();
                            listCourseDetails.add(courseDetails[index]);
                          }


                        });
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2.0,
                                    color: listCourseDetails.contains(courseDetails[index]) ? Color(0xFF2692E4) : Colors.transparent,
                                  ),
                                ),
                                child: Container(
                                    padding: EdgeInsets.all(7.0),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: listCourseDetails.contains(courseDetails[index]) ? Color(0xFF2692E4) : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2.0,
                                        color: listCourseDetails.contains(courseDetails[index]) ? Color(0xFFFFFFF) : Colors.transparent,
                                      ),
                                    ),
                                    child:Image.asset("${courseDetails[index].iconURL}")
                                ),
                              ),
                              SizedBox(height: 5,),
                              sText("${courseDetails[index].title}",color: listCourseDetails.contains(courseDetails[index]) ? Colors.blue : Colors.grey,weight: FontWeight.w500,size: 12)
                            ],
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20,),
            getPage().values.first
          ],
        ),
      ),
    );
  }


  // learnModeWidget(){
  //   return  Expanded(
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 24.0, right: 24.0),
  //             child: CourseDetailCard(
  //               courseDetail: learnModeDetails[0],
  //               onTap: () {
  //                 },
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(left: 24.0, right: 24.0),
  //             child: CourseDetailCard(
  //               courseDetail: learnModeDetails[1],
  //               onTap: () async {
  //
  //               },
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(left: 24.0, right: 24.0),
  //             child: CourseDetailCard(
  //               courseDetail: learnModeDetails[2],
  //               onTap: () {
  //
  //               },
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(left: 24.0, right: 24.0),
  //             child: CourseDetailCard(
  //               courseDetail: learnModeDetails[3],
  //               onTap: () {
  //               },
  //             ),
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // noteWidget(){
  //   return
  //     topics.isNotEmpty ?
  //     Expanded(
  //     child: Column(
  //       children: [
  //         Expanded(
  //           child: ListView.builder(
  //             padding: EdgeInsets.zero,
  //               itemCount: topics.length,
  //               itemBuilder: (BuildContext context, int index){
  //                 return Column(
  //                   children: [
  //                     MaterialButton(
  //                       onPressed: (){
  //                         NotesReadDB().insert(NotesRead(
  //                             courseId: topics[index].courseId,
  //                             name: topics[index].name,
  //                             notes: topics[index].notes,
  //                             topicId: topics[index].id,
  //                             createdAt: DateTime.now(),
  //                             updatedAt: DateTime.now()));
  //
  //                         showDialog(
  //                             context: context,
  //                             builder: (context) {
  //                               return NoteView(widget.user, topics[index]);
  //                             });
  //                       },
  //                       child: Container(
  //                         padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(10)
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Column(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   width: appWidth(context) * 0.70,
  //                                   child: sText("${topics[index].name}"),
  //                                 ),
  //                               ],
  //                             ),
  //
  //                             Column(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Image.asset('assets/icons/courses/learn.png',width: 35,height: 35,),
  //                                 SizedBox(height: 10,),
  //                                 Container(
  //                                   child: Icon(Icons.check,color: Colors.white,),
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.green,
  //                                     shape: BoxShape.circle
  //                                   ),
  //                                 )
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 15,),
  //                   ],
  //                 );
  //           }),
  //         ),
  //
  //
  //       ],
  //     )
  //     ) :
  //         topicsProgressCode ?
  //     Center(child: progress()) :
  //         MaterialButton(
  //           onPressed: ()async{
  //            await goTo(context, BuyBundlePage(widget.user, controller: widget.controller, bundle: widget.subscription,));
  //            setState(() {
  //              topics.clear();
  //              topicsProgressCode = true;
  //               getNotesTopics(course!);
  //            });
  //
  //           },
  //           child: Center(
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
  //                 width: appWidth(context),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       sText(""),
  //                       Container(
  //                         width: appWidth(context) * 0.70,
  //                           child: sText("DOWNLOAD ${course != null ? course!.name : widget.courses[0].name}  TOPICS",color: kAdeoGray3,weight: FontWeight.bold,size: 16,align: TextAlign.left),
  //                       ),
  //                       SizedBox(width: 10,),
  //                       Icon(Icons.arrow_forward_ios)
  //                     ],
  //                   ),
  //               ),
  //           ),
  //         ) ;
  // }
  // testTypeWidget(){
  //   return   Expanded(
  //     child: ListView(
  //       padding: EdgeInsets.symmetric(horizontal: 20),
  //       children: [
  //         MultiPurposeCourseCard(
  //           title: 'Speed',
  //           subTitle:
  //           'Accuracy matters , don\'t let the clock run down',
  //           iconURL: 'assets/icons/courses/speed.png',
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return SpeedTestIntro(
  //                     user: widget.user,
  //                     course: course!,
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Knowledge',
  //           subTitle: 'Standard test',
  //           iconURL: 'assets/icons/courses/knowledge.png',
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return TestChallengeList(
  //                     testType: TestType.KNOWLEDGE,
  //                     course: course!,
  //                     user: widget.user,
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Marathon',
  //           subTitle: 'Race to complete all questions',
  //           iconURL: 'assets/icons/courses/marathon.png',
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return MarathonIntroit(widget.user, course!);
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Autopilot',
  //           subTitle: 'Completing a course one topic at a time',
  //           iconURL: 'assets/icons/courses/autopilot.png',
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return AutopilotIntroit(
  //                       widget.user, course!);
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Treadmill',
  //           subTitle: 'Crank up the speed, how far can you go?',
  //           iconURL: 'assets/icons/courses/treadmill.png',
  //           onTap: () async {
  //             Treadmill? treadmill = await TestController()
  //                 .getCurrentTreadmill(course!);
  //             if (treadmill == null) {
  //               return Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => TreadmillWelcome(
  //                     user: widget.user,
  //                     course: course!,
  //                   ),
  //                 ),
  //               );
  //             }
  //             else {
  //               return Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) =>
  //                       TreadmillSaveResumptionMenu(
  //                         controller: TreadmillController(
  //                           widget.user,
  //                           course!,
  //                           name: course!.name!,
  //                           treadmill: treadmill,
  //                         ),
  //                       ),
  //                 ),
  //               );
  //             }
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Customised',
  //           subTitle: 'Create your own kind of quiz',
  //           iconURL: 'assets/icons/courses/customised.png',
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return CustomizedTestIntroit(
  //                     user: widget.user,
  //                     course: course!,
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Timeless',
  //           subTitle: 'Practice mode, no pressure.',
  //           iconURL: 'assets/icons/courses/untimed.png',
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return TestChallengeList(
  //                     testType: TestType.UNTIMED,
  //                     course: course!,
  //                     user: widget.user,
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Review',
  //           subTitle: 'Know the answer to every question',
  //           iconURL: 'assets/icons/courses/review.png',
  //           onTap: () {
  //             goTo(
  //                 context,
  //                 ReviewOnBoarding(
  //                   user: widget.user,
  //                   course: course!,
  //                   testType: TestType.NONE,
  //                 ));
  //           },
  //         ),
  //         MultiPurposeCourseCard(
  //           title: 'Conquest',
  //           subTitle: 'Prepare for battle, attempt everything',
  //           iconURL: 'assets/icons/courses/conquest.png',
  //           onTap: () {
  //             return showDialog(
  //               context: context,
  //               builder: (BuildContext context) {
  //                 return AdeoDialog(
  //                   title: 'Conquest',
  //                   content:
  //                   'Prepare for battle, attempt everything. Feature coming soon.',
  //                   actions: [
  //                     AdeoDialogAction(
  //                       label: 'Dismiss',
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // progressWidget(){
  //     return  Column(
  //       children: [
  //         MaterialButton(
  //           onPressed: ()async{
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return AnalysisView(
  //                     user: widget.user,
  //                     course: course,
  //                   );
  //                 },
  //               ),
  //             );
  //
  //           },
  //           child: Center(
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
  //               width: appWidth(context),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   sText(""),
  //                   Container(
  //                     width: appWidth(context) * 0.70,
  //                     child: sText("CHECK ${course != null ? course!.name : widget.courses[0].name}  STATS",color: kAdeoGray3,weight: FontWeight.bold,size: 16,align: TextAlign.center),
  //                   ),
  //                   SizedBox(width: 10,),
  //                   Icon(Icons.arrow_forward_ios)
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  // }
}

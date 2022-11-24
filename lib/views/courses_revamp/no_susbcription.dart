import 'dart:convert';
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/report.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses_revamp/available_bundles.dart';
import 'package:ecoach/views/courses_revamp/widgets/games_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/learn_mode_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/live_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/note_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/progress_widget.dart';
import 'package:ecoach/views/courses_revamp/widgets/test_type_widget.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoSubscriptionsPage extends StatefulWidget {
  static const String routeName = '/no-subscription';
  NoSubscriptionsPage({Key? key,  this.courses,required this.user, this.subscription,required this.controller,}) : super(key: key);
  List<Course>? courses;
  Plan? subscription;
  User user;
  final MainController controller;
  @override

  State<NoSubscriptionsPage> createState() => _NoSubscriptionsPageState();
}

class _NoSubscriptionsPageState extends State<NoSubscriptionsPage> {
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
        return {'Learn Mode': learnModeWidget()};
      case 1:
        return {'Note': noteWidget()};

      case 2:
        return {'Test Type': testTypeWidget()};

      case 3:
        return {'Live': LiveWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course,)};
      case 4:
        return {'Games': GameWidget(controller: widget.controller,subscription: widget.subscription,user: widget.user,course: course,)};

      case 5:
        return {'Progress': progressWidget()};

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
    CourseDetail(
      title: 'Efficiency Mode',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Prep Mode',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Custom Mode',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
  ];

  List<CourseDetail> testTypeDetails = [
    CourseDetail(
      title: 'Speed',
      subTitle: 'Accuracy matters , don\'t let the clock run down',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Knowledge',
      subTitle: 'Standard test',
      iconURL: 'assets/icons/courses/knowledge.png',
    ),
    CourseDetail(
      title: 'Marathon',
      subTitle: 'Race to complete all questions',
      iconURL: 'assets/icons/courses/marathon.png',
    ),
    CourseDetail(
      title: 'Autopilot',
      subTitle: 'Completing a course one topic at a time',
      iconURL: 'assets/icons/courses/autopilot.png',
    ),
    CourseDetail(
      title: 'Treadmill',
      subTitle: 'Crank up the speed, how far can you go?',
      iconURL: 'assets/icons/courses/treadmill.png',
    ),
    CourseDetail(
      title: 'Customised',
      subTitle: 'Create your own kind of quiz',
      iconURL: 'assets/icons/courses/customised.png',
    ),
    CourseDetail(
      title: 'Timeless',
      subTitle: 'Practice mode, no pressure',
      iconURL: 'assets/icons/courses/untimed.png',
    ),
    CourseDetail(
      title: 'Review',
      subTitle: 'Know the answer to every question',
      iconURL: 'assets/icons/courses/review.png',
    ),
    CourseDetail(
      title: 'Conquest',
      subTitle: 'Prepare for battle. Attempt everything',
      iconURL: 'assets/icons/courses/conquest.png',
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCourseDetails.add(courseDetails[0]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:kAdeoGray,
      body: Container(
        padding: EdgeInsets.only(top: 5.h,),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  goTo(context, MainHomePage(widget.user,),replace: true);
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
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sText("No Subscriptions",align: TextAlign.center,weight: FontWeight.w500),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      )
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()async{
                    await goTo(context, AvailableBundles(widget.user,controller: widget.controller,));

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
            getPage().values.first,
            SizedBox(height: 20,),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: ()async{
               await goTo(context, AvailableBundles(widget.user,controller: widget.controller,));
              },
              child: Container(
                child: sText("Buy Full Access",align: TextAlign.center,color: Colors.white,weight: FontWeight.w600,size: 20),
                color: Color(0xFF2692E4),
                padding: EdgeInsets.symmetric(vertical: 20),
                width: appWidth(context),
              ),
            ),

          ],
        ),
      ),
    );
  }

  learnModeWidget(){
    return   Expanded(
      child: Column(
        children: [
         Container(
           padding: EdgeInsets.symmetric(horizontal: 20),
           child:  sText("Different modes to help you understand a course.",align: TextAlign.center,weight: FontWeight.w600,size: 16),
         ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child:  sText("Choose your learning goal and achieve it with adeo",align: TextAlign.center,weight: FontWeight.normal,size: 12),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal:10),
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: learnModeDetails.length,
                  itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset("${learnModeDetails[index].iconURL}",width: 35,height: 35,),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("${learnModeDetails[index].title}",weight: FontWeight.w500),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: appWidth(context) * 0.7,
                                    child: sText("${learnModeDetails[index].subTitle}",size: 12,color: kAdeoGray2),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  testTypeWidget(){
    return   Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:  sText("Plethora of Test types",align: TextAlign.center,weight: FontWeight.w600,size: 16),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal:10),
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: testTypeDetails.length,
                  itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset("${testTypeDetails[index].iconURL}",width: 35,height: 35,),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("${testTypeDetails[index].title}",weight: FontWeight.w500),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: appWidth(context) * 0.7,
                                    child: sText("${testTypeDetails[index].subTitle}",size: 12,color: kAdeoGray2),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  noteWidget(){
    return  Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/analysis.png',
                height: 239,
                width: 239,
              ),
              SizedBox(height: 3.h),

              Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: const Text(
              "Self explanatory notes on every topic.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),

        ]),
      ),
    );
  }

  progressWidget(){
    return  Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/analysis.png',
                height: 239,
                width: 239,
              ),
              SizedBox(height: 3.h),

              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: const Text(
                  "Track your progress",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: const Text(
                  "compare your performance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),



            ]),
      ),
    );
  }
}

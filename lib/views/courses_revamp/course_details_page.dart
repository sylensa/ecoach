import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoursesDetailsPage extends StatefulWidget {
   CoursesDetailsPage({Key? key, required this.courses}) : super(key: key);
  List<Course> courses;
  @override

  State<CoursesDetailsPage> createState() => _CoursesDetailsPageState();
}

class _CoursesDetailsPageState extends State<CoursesDetailsPage> {
  List<CourseDetail> listCourseDetails = [];
  int _currentPage = 0;
  Course? course;
  Map<String, Widget> getPage() {
    switch (_currentPage) {
      case 0:
        return {'': learnModeWidget()};
      case 1:
        return {'': noteWidget()};

      case 2:
        return {'': testTypeWidget()};

      case 3:
        return {'': learnModeWidget()};
    // continue
      case 4:
        return {'': learnModeWidget()};

      case 5:
        return {'': learnModeWidget()};

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
  List<CourseDetail> noteDetails = [
    CourseDetail(
      title: 'Dragging Of Mouse',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Forms of Communication',
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCourseDetails.add(courseDetails[0]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
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
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(right: 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Course>(
                          value: widget.courses[0],
                          itemHeight: 60,
                          style: TextStyle(
                            fontSize: 16,
                            color: kDefaultBlack,
                          ),
                          onChanged: (Course? value){
                            setState((){
                              course = value;
                            });
                          },
                          items: widget.courses.map(
                                (item) => DropdownMenuItem<Course>(
                              value: item,
                              child: Container(
                                width: appWidth(context) * 0.70,
                                child: sText(
                                  "${item.name}",
                                 color: kAdeoGray3,
                                  size: 20,
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
              ],
            ),
            SizedBox(height: 40,),
            Container(
              height: 80,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                  itemCount: courseDetails.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                  return    MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
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
                                  color: listCourseDetails.contains(courseDetails[index]) ? Color(0xFF00C663) : Colors.transparent,
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(7.0),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: listCourseDetails.contains(courseDetails[index]) ? Color(0xFFCEFFE7) : Colors.transparent,
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
                        SizedBox(width: 0,),
                      ],
                    ),
                  );
              }),
            ),
            SizedBox(height: 40,),
            getPage().values.first
          ],
        ),
      ),
    );
  }


  learnModeWidget(){
    return  Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: learnModeDetails[0],
                onTap: () {
                  },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: learnModeDetails[1],
                onTap: () async {

                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: learnModeDetails[2],
                onTap: () {

                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: learnModeDetails[3],
                onTap: () {
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
  noteWidget(){
    return  Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: noteDetails[0],
                onTap: () {
                  },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: noteDetails[1],
                onTap: () async {

                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: noteDetails[2],
                onTap: () {

                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: CourseDetailCard(
                courseDetail: noteDetails[3],
                onTap: () {
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
  testTypeWidget(){
    return   Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          MultiPurposeCourseCard(
            title: 'Speed',
            subTitle:
            'Accuracy matters , don\'t let the clock run down',
            iconURL: 'assets/icons/courses/speed.png',
            onTap: () {

            },
          ),
          MultiPurposeCourseCard(
            title: 'Knowledge',
            subTitle: 'Standard test',
            iconURL: 'assets/icons/courses/knowledge.png',
            onTap: () {
            },
          ),
          MultiPurposeCourseCard(
            title: 'Marathon',
            subTitle: 'Race to complete all questions',
            iconURL: 'assets/icons/courses/marathon.png',
            onTap: () {

            },
          ),
          MultiPurposeCourseCard(
            title: 'Autopilot',
            subTitle: 'Completing a course one topic at a time',
            iconURL: 'assets/icons/courses/autopilot.png',
            onTap: () {

            },
          ),
          MultiPurposeCourseCard(
            title: 'Treadmill',
            subTitle: 'Crank up the speed, how far can you go?',
            iconURL: 'assets/icons/courses/treadmill.png',
            onTap: () async {

            },
          ),
          MultiPurposeCourseCard(
            title: 'Customised',
            subTitle: 'Create your own kind of quiz',
            iconURL: 'assets/icons/courses/customised.png',
            onTap: () {

            },
          ),
          MultiPurposeCourseCard(
            title: 'Timeless',
            subTitle: 'Practice mode, no pressure.',
            iconURL: 'assets/icons/courses/untimed.png',
            onTap: () {

            },
          ),
          MultiPurposeCourseCard(
            title: 'Review',
            subTitle: 'Know the answer to every question',
            iconURL: 'assets/icons/courses/review.png',
            onTap: () {

            },
          ),
          MultiPurposeCourseCard(
            title: 'Conquest',
            subTitle: 'Prepare for battle, attempt everything',
            iconURL: 'assets/icons/courses/conquest.png',
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}

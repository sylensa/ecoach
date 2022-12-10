import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GlossaryView extends StatefulWidget {
  GlossaryView({
    required this.user,
    required this.course,
    required this.listCourseKeywordsData,

    Key? key,
  }) : super(key: key);
  final User user;
  final Course course;
  List<CourseKeywords> listCourseKeywordsData;

  @override
  State<GlossaryView> createState() => _GlossaryViewState();
}

class _GlossaryViewState extends State<GlossaryView> {
  PageController pageControllerView = PageController(initialPage: 0);
  PageController pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool switchValue = false;
  List<CourseKeywords> courseKeywords = [];
  Map<String, List<CourseKeywords>> groupedCourseKeywordsResult = {
    'A': [],
    'B': [],
    'C': [],
    'D': [],
    'E': [],
    'F': [],
    'G': [],
    'H': [],
    'I': [],
    'J': [],
    'K': [],
    'L': [],
    'M': [],
    'N': [],
    'O': [],
    'P': [],
    'Q': [],
    'R': [],
    'S': [],
    'T': [],
    'U': [],
    'V': [],
    'W': [],
    'X': [],
    'Y': [],
    'Z': []
  };
  Map<String, List<CourseKeywords>> groupedCourseKeywordsLists = {
    'A': [],
    'B': [],
    'C': [],
    'D': [],
    'E': [],
    'F': [],
    'G': [],
    'H': [],
    'I': [],
    'J': [],
    'K': [],
    'L': [],
    'M': [],
    'N': [],
    'O': [],
    'P': [],
    'Q': [],
    'R': [],
    'S': [],
    'T': [],
    'U': [],
    'V': [],
    'W': [],
    'X': [],
    'Y': [],
    'Z': []
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.listCourseKeywordsData.isNotEmpty) {
      groupedCourseKeywordsLists = {
        'A': [],
        'B': [],
        'C': [],
        'D': [],
        'E': [],
        'F': [],
        'G': [],
        'H': [],
        'I': [],
        'J': [],
        'K': [],
        'L': [],
        'M': [],
        'N': [],
        'O': [],
        'P': [],
        'Q': [],
        'R': [],
        'S': [],
        'T': [],
        'U': [],
        'V': [],
        'W': [],
        'X': [],
        'Y': [],
        'Z': []
      };
    } else {
      groupedCourseKeywordsLists.clear();
    }
    widget.listCourseKeywordsData.forEach((courseKeyword) {
      if (groupedCourseKeywordsLists['${courseKeyword.keyword![0]}'.toUpperCase()] == null) {
        groupedCourseKeywordsLists['${courseKeyword.keyword![0]}'.toUpperCase()] = <CourseKeywords>[];
      }
      groupedCourseKeywordsLists['${courseKeyword.keyword![0]}'.toUpperCase()]!.add(courseKeyword);
    });
    groupedCourseKeywordsResult.clear();
    for (var entry in groupedCourseKeywordsLists.entries)
      if (entry.value.isNotEmpty){
        Map<String, List<CourseKeywords>> groupedCourse = {
          entry.key.toUpperCase() : entry.value
        };
        groupedCourseKeywordsResult.addAll(groupedCourse);
      }

    print("groupedCourseKeywordsResult:${groupedCourseKeywordsResult}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D289),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 120,
                padding: EdgeInsets.only(left: 2.h, top: 6.h, bottom: 2.h),
                color: Color(0XFF1D4859),
                child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    controller: pageControllerView,
                  children: [
                    for(var entries in groupedCourseKeywordsResult.entries)
                      GestureDetector(
                        onTap: () {

                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                  padding: EdgeInsets.all(7.0),
                                  height: 50,
                                  width: 50,
                                  child: sText(entries.key.toLowerCase(),color: Colors.white,align: TextAlign.center,size: 30,weight: FontWeight.w500)
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      )



                  ],
                   ),
              ),
              SizedBox(height: 20,),
              CarouselSlider.builder(
                  options:
                  CarouselOptions(
                    height:  680,
                    autoPlay: false,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    aspectRatio: 2.0,
                    pageSnapping: true,
                    onPageChanged: (index, reason) {
                      setState(
                              () {

                          });
                    },
                  ),
                  itemCount:5,
                  itemBuilder: (BuildContext context, int indexReport, int index2) {
                    return  SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlutterSwitch(
                                  width: 50.0,
                                  height: 20.0,
                                  valueFontSize: 10.0,
                                  toggleSize: 15.0,
                                  value: switchValue,
                                  borderRadius: 30.0,
                                  padding: 2.0,
                                  showOnOff: false,
                                  activeColor: Color(0xFF555555),
                                  inactiveColor: Color(0xFFD1D1D1),
                                  inactiveTextColor: Colors.red,
                                  inactiveToggleColor: Color(0xFF555555),
                                  onToggle: (val) {
                                    setState(() {
                                      switchValue = val;
                                      print(switchValue);
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            sText("Photosynthesis",color: Colors.black,size: 25,weight: FontWeight.w500),
                            SizedBox(height: 20,),
                            sText("Topic",color: Colors.grey,size: 12,weight: FontWeight.w500),
                            SizedBox(height: 10,),
                            sText("Matter",color: Colors.black,size: 16,weight: FontWeight.w500),
                            SizedBox(height: 40,),
                            sText("Definition",color: Colors.grey,size: 12,weight: FontWeight.w500),
                            SizedBox(height: 10,),
                            sText("The smallest particle of an element that can take part in a chemical reaction.",color: Colors.black,size: 16,weight: FontWeight.w500),
                            SizedBox(height: 70,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                sText("Stats",color: Colors.black,size: 25,weight: FontWeight.w500,align: TextAlign.center),
                              ],
                            ),
                            Divider(color: Colors.grey,),
                            // SizedBox(height: 20,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/objective.png",),
                                  SizedBox(width: 50,),
                                  Column(
                                    children: [
                                      Container(
                                        margin: topPadding(50),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            sText("250th",color: Colors.grey,size: 40,weight: FontWeight.bold,align: TextAlign.center),
                                          ],
                                        ),
                                      ),
                                      sText("Keyword Ranking",color: Colors.grey,size: 14,weight: FontWeight.w400),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: topPadding(50),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          sText("200",color: Colors.grey,size: 40,weight: FontWeight.bold,align: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                    sText("Appearances",color: Colors.grey,size: 14,weight: FontWeight.w400),

                                  ],
                                ),
                                SizedBox(width: 20,),
                                Container(
                                  margin: topPadding(40),
                                  color:  Color(0xFF00D289),
                                  height: 70,
                                  width: 2,
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  children: [
                                    Container(
                                      margin: topPadding(50),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          sText("125",color: Colors.grey,size: 40,weight: FontWeight.bold,align: TextAlign.center,),
                                        ],
                                      ),
                                    ),
                                    sText("Saves",color: Colors.grey,size: 14,weight: FontWeight.w400),

                                  ],
                                ),
                              ],
                            )


                          ],
                        ),
                      ),
                    );
                  }),

              Container(
                child: Column(
                  children: [
                    sText("Questions",color: Colors.white,weight: FontWeight.w600,size: 20),
                    SizedBox(height: 10,),
                    sText('These contain the word "Atom".',color: Colors.white,weight: FontWeight.normal,size: 20),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              Container(
                width: appWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    sText("What is rent income ratio?",color: Colors.white,size: 20,weight: FontWeight.w500),
                    Icon(Icons.add,color: Colors.white,)
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white,width: 2)
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: appWidth(context),
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sText("What is rent income ratio?",color: Colors.black,size: 20,weight: FontWeight.w500),
                          Icon(Icons.horizontal_rule,color: Colors.black,)
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 20,
                      width: appWidth(context),
                    ),
                    SizedBox(height: 20,),
                   Column(
                     children: [
                       for(int i = 0; i < 4; i++)
                         i == 2 ?
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                           width: appWidth(context),
                           color: Colors.white,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               sText("Sokoto",size: 25,weight: FontWeight.w500,color: Colors.black,align: TextAlign.left),
                               Image.asset("assets/images/correct.png")
                             ],
                           ),
                         )
                             :
                         Container(
                           width: appWidth(context),

                           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                           child: sText("Sokoto",size: 25,weight: FontWeight.w500,color: Colors.black,align: TextAlign.left),
                         ),

                     ],
                   ),
                    SizedBox(height: 10,),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

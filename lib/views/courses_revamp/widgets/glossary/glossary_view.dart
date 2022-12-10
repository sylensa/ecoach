import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
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
      body: Container(
        child: Column(
          children: [
            Container(
              height: 110,
              padding: EdgeInsets.only(left: 2.h, top: 5.h, bottom: 2.h),
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
                                child: sText(entries.key,color: Colors.white,align: TextAlign.center)
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
          ],
        ),
      ),
    );
  }
}

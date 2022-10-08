import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  GameWidget({Key? key,required this.course,required this.user,required this.subscription, required this.controller}) : super(key: key);
  Course course;
  User user;
  Plan subscription;
  final MainController controller;
  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
}

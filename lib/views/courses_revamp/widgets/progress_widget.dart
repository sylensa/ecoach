import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {
  ProgressWidget({Key? key,required this.course,required this.user,required this.subscription, required this.controller}) : super(key: key);
  Course course;
  User user;
  Plan subscription;
  final MainController controller;
  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
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
    return  Column(
      children: [
        MaterialButton(
          onPressed: ()async{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AnalysisView(
                    user: widget.user,
                    course: widget.course,
                  );
                },
              ),
            );

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
                    child: sText("CHECK ${widget.course.name}  STATS",color: kAdeoGray3,weight: FontWeight.bold,size: 16,align: TextAlign.center),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoach/utils/manip.dart';

class CourseDetailsPage extends StatelessWidget {
  CourseDetailsPage({this.course});

  static const String routeName = '/courses/details';
  final course;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          kCapitalizeString(course.title),
          style: TextStyle(
            fontSize: 24.0,
            color: Color(0x99000000),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        // automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: courseDetails.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: CourseDetailCard(courseDetail: courseDetails[index]),
          );
        },
      ),
    );
  }
}

import 'package:ecoach/models/ui/course_info.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard(this.user, {required this.courseInfo});
  final CourseInfo courseInfo;
  final User user;

  @override
  Widget build(BuildContext context) {
    return MultiPurposeCourseCard(
      title: courseInfo.title,
      subTitle: courseInfo.subTitle,
      progress: double.parse(courseInfo.progress.toStringAsFixed(1)),
      hasProgressed: false,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: CoursesPage.routeName),
            builder: (context) =>
                CourseDetailsPage(user, courseInfo: courseInfo),
          ),
        );
      },
    );
  }
}

import 'package:ecoach/models/ui/course.dart';
import 'package:ecoach/widgets/cards/course_card.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  static const String routeName = '/courses';
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 24.0,
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: CourseCard(course: courses[index]),
          );
        },
      ),
    );
  }
}

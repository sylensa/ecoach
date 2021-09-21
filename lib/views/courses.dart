import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/courses/course_card.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 16.0,
            ),
            child: Column(
              children: [
                CourseCard(
                  course: {'name': 'social studies'},
                  colors: kCourseColors[0],
                  iconUrl: 'assets/images/sociology.png',
                  progress: 65,
                  learnerPosition: 12,
                  numberOnRoll: 305,
                  testsTaken: 132,
                  totalNumberOfTests: 3254,
                  totalPoints: 1895,
                  times: 697,
                ),
                CourseCard(
                  course: {'name': 'science'},
                  colors: kCourseColors[1],
                  iconUrl: 'assets/images/launch.png',
                  progress: 80,
                  learnerPosition: 18,
                  numberOnRoll: 278,
                  testsTaken: 132,
                  totalNumberOfTests: 3254,
                  totalPoints: 1895,
                  times: 697,
                ),
                CourseCard(
                  course: {'name': 'ICT'},
                  colors: kCourseColors[2],
                  iconUrl: 'assets/images/sociology.png',
                  progress: 51,
                  learnerPosition: 12,
                  numberOnRoll: 305,
                  testsTaken: 132,
                  totalNumberOfTests: 3254,
                  totalPoints: 1895,
                  times: 697,
                ),
                CourseCard(
                  course: {'name': 'math'},
                  colors: kCourseColors[3],
                  iconUrl: 'assets/images/launch.png',
                  progress: 92,
                  learnerPosition: 18,
                  numberOnRoll: 278,
                  testsTaken: 132,
                  totalNumberOfTests: 3254,
                  totalPoints: 1895,
                  times: 697,
                ),
                CourseCard(
                  course: {'name': 'english lang'},
                  colors: kCourseColors[4],
                  iconUrl: 'assets/images/sociology.png',
                  progress: 49,
                  learnerPosition: 12,
                  numberOnRoll: 305,
                  testsTaken: 132,
                  totalNumberOfTests: 3254,
                  totalPoints: 1895,
                  times: 697,
                ),
                CourseCard(
                  course: {'name': 'BTC'},
                  colors: kCourseColors[5],
                  iconUrl: 'assets/images/launch.png',
                  progress: 27,
                  learnerPosition: 18,
                  numberOnRoll: 278,
                  testsTaken: 132,
                  totalNumberOfTests: 3254,
                  totalPoints: 1895,
                  times: 697,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

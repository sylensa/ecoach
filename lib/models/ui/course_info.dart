import 'package:ecoach/models/ui/course_module.dart';
import 'package:ecoach/utils/style_sheet.dart';

import '../course.dart';

class CourseInfo extends CourseModule {
  CourseInfo({
    title,
    background,
    icon,
    progress,
    progressColor,
    onTap,
    required this.rank,
    required this.tests,
    required this.totalPoints,
    required this.times,
    required this.totalTimes,
    required this.course,
  }) : super(
          title: title,
          background: background,
          icon: icon,
          progress: progress,
          progressColor: progressColor,
        );

  final Map rank;
  final Map tests;
  final num totalPoints;
  final num times;
  final num totalTimes;
  final Course course;
}

List<CourseInfo> courses = [
  // CourseInfo(
  //   title: 'social studies',
  //   background: kCourseColors[0]['background'],
  //   icon: 'social_studies.png',
  //   progress: 65,
  //   progressColor: kCourseColors[0]['progress'],
  //   rank: {
  //     'position': 12,
  //     'numberOnRoll': 305,
  //   },
  //   tests: {
  //     'testsTaken': 132,
  //     'totalNumberOfTests': 3254,
  //   },
  //   totalPoints: 1895,
  //   times: 697,
  // ),
  // CourseInfo(
  //     title: 'science',
  //     background: kCourseColors[1]['background'],
  //     icon: 'science.png',
  //     progress: 80,
  //     progressColor: kCourseColors[1]['progress'],
  //     rank: {
  //       'position': 18,
  //       'numberOnRoll': 278,
  //     },
  //     tests: {
  //       'testsTaken': 132,
  //       'totalNumberOfTests': 3254,
  //     },
  //     totalPoints: 1895,
  //     times: 697),
  // CourseInfo(
  //   title: 'ICT',
  //   background: kCourseColors[2]['background'],
  //   icon: 'ict.png',
  //   progress: 51,
  //   progressColor: kCourseColors[2]['progress'],
  //   rank: {
  //     'position': 12,
  //     'numberOnRoll': 305,
  //   },
  //   tests: {
  //     'testsTaken': 132,
  //     'totalNumberOfTests': 3254,
  //   },
  //   totalPoints: 1895,
  //   times: 697,
  // ),
  // CourseInfo(
  //   title: 'math',
  //   background: kCourseColors[3]['background'],
  //   icon: 'math.png',
  //   progress: 92,
  //   progressColor: kCourseColors[3]['progress'],
  //   rank: {
  //     'position': 12,
  //     'numberOnRoll': 305,
  //   },
  //   tests: {
  //     'testsTaken': 132,
  //     'totalNumberOfTests': 3254,
  //   },
  //   totalPoints: 1895,
  //   times: 697,
  // ),
];

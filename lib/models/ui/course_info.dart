import 'package:ecoach/models/ui/course_module.dart';
// import 'package:ecoach/utils/style_sheet.dart';

import '../course.dart';

class CourseInfo extends CourseModule {
  CourseInfo({
    title,
    subTitle,
    required this.progress,
    required this.course,
  }) : super(
          title: title,
          subTitle: subTitle,
        );

  final double progress;
  final Course course;
}

// class CourseInfo extends CourseModule {
//   CourseInfo({
//     title,
//     background,
//     icon,
//     progress,
//     progressColor,
//     onTap,
//     required this.rank,
//     required this.tests,
//     required this.totalPoints,
//     required this.times,
//     required this.totalTimes,
//     required this.course,
//   }) : super(
//           title: title,
//           background: background,
//           icon: icon,
//           progress: progress,
//           progressColor: progressColor,
//         );

//   final Map rank;
//   final Map tests;
//   final num totalPoints;
//   final num times;
//   final num totalTimes;
//   final Course course;
// }
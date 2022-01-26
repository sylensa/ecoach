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

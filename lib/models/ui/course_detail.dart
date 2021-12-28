import 'course_module.dart';

class CourseDetail extends CourseModule {
  CourseDetail({
    title,
    subTitle,
    required this.iconURL,
  }) : super(
          title: title,
          subTitle: subTitle,
        );

  final String iconURL;
}

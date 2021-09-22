import 'dart:ui';

abstract class CourseModule {
  CourseModule({
    required this.title,
    required this.background,
    required this.icon,
    required this.progress,
    required this.progressColor,
  });

  final String title;
  final Color background;
  final String icon;
  final int progress;
  final Color progressColor;
}

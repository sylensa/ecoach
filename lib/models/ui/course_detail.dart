import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

import 'course_module.dart';

class CourseDetail extends CourseModule {
  CourseDetail({
    title,
    background,
    icon,
    progress,
    progressColor,
    required this.iconLabel,
    this.subtitle1,
    this.subtitle2,
    required this.subGraphicsIsIcon,
    this.subGraphics,
    required this.onTap,
  }) : super(
          title: title,
          background: background,
          icon: icon,
          progress: progress,
          progressColor: progressColor,
        );

  final String iconLabel;
  final String? subtitle1;
  final String? subtitle2;
  final bool subGraphicsIsIcon;
  final dynamic subGraphics;
  final Function onTap;
}

List<CourseDetail> courseDetails = [
  CourseDetail(
    title: 'Matter',
    background: kCourseColors[4]['background'],
    icon: 'learn.png',
    progress: 75,
    progressColor: kCourseColors[4]['progress'],
    iconLabel: 'Learn',
    subtitle1: 'Density',
    subtitle2: 'Pressure',
    subGraphicsIsIcon: true,
    subGraphics: Icons.play_arrow_sharp,
    onTap: () {},
  ),
  CourseDetail(
    title: 'Density',
    background: kCourseColors[5]['background'],
    icon: 'notes.png',
    progress: 80,
    progressColor: kCourseColors[5]['progress'],
    iconLabel: 'Notes',
    subGraphicsIsIcon: true,
    subGraphics: Icons.pause,
    onTap: () {},
  ),
  CourseDetail(
    title: 'BECE 2020',
    background: kCourseColors[6]['background'],
    icon: 'tests.png',
    progress: 50,
    progressColor: kCourseColors[6]['progress'],
    iconLabel: 'Tests',
    subtitle1: 'Rank: 105th',
    subGraphicsIsIcon: false,
    subGraphics: 'reload.png',
    onTap: () {},
  ),
  CourseDetail(
    title: 'Challenge',
    background: kCourseColors[7]['background'],
    icon: 'games.png',
    progress: 50,
    progressColor: kCourseColors[7]['progress'],
    iconLabel: 'Games',
    subtitle1: 'Rank: 5th',
    subGraphicsIsIcon: false,
    subGraphics: 'challenge.png',
    onTap: () {},
  ),
  CourseDetail(
    title: 'LeaderBoard',
    background: kCourseColors[8]['background'],
    icon: 'progress.png',
    progress: 75,
    progressColor: kCourseColors[8]['progress'],
    iconLabel: 'Progress',
    subtitle1: 'Rank: 2nd',
    subGraphicsIsIcon: false,
    subGraphics: 'leaderboard.png',
    onTap: () {},
  )
];

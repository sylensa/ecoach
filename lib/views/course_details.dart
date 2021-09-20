import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/courses/course_card_template.dart';
import 'package:ecoach/widgets/courses/vertical_captioned_image.dart';
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
        title: Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            kCapitalizeString(course['name']),
            style: TextStyle(
              fontSize: 24.0,
              color: Color(0x99000000),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
            bottom: 32.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            children: [
              CourseCardTemplate(
                course: course,
                background: Color(0xFF00C664),
                leftWidget: VerticalCaptionedImage(
                  imageUrl: 'assets/images/learn.png',
                  caption: 'Learn',
                ),
                centerWidget: LearnCenterWidget(),
                rightWidget: CircularProgressIndicatorWrapper(
                  progress: 75,
                  progressColor: Color(0xFFFFB300),
                ),
              ),
              CourseCardTemplate(
                course: course,
                background: Color(0xFF3AAFFF),
                leftWidget: VerticalCaptionedImage(
                  imageUrl: 'assets/images/notes.png',
                  caption: 'Notes',
                ),
                centerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Density',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                rightWidget: CircularProgressIndicatorWrapper(
                  progress: 80,
                  progressColor: Color(0xFFEFFF00),
                ),
              ),
              CourseCardTemplate(
                course: course,
                background: Color(0xFFFFB444),
                leftWidget: VerticalCaptionedImage(
                  imageUrl: 'assets/images/tests.png',
                  caption: 'Tests',
                ),
                centerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/reload.png',
                      width: 24.0,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BECE 2020',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rank: 105th',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xCCFFFFFF),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                rightWidget: CircularProgressIndicatorWrapper(
                  progress: 50,
                  progressColor: Color(0xFF707070),
                ),
              ),
              CourseCardTemplate(
                course: course,
                background: Color(0xFFFF6344),
                leftWidget: VerticalCaptionedImage(
                  imageUrl: 'assets/images/games.png',
                  caption: 'Games',
                ),
                centerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/challenge.png',
                      width: 24.0,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Challenge',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rank: 5th',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xCCFFFFFF),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                rightWidget: CircularProgressIndicatorWrapper(
                  progress: 50,
                  progressColor: Color(0xFF6AC466),
                ),
              ),
              CourseCardTemplate(
                course: course,
                background: Color(0xFF707070),
                leftWidget: VerticalCaptionedImage(
                  imageUrl: 'assets/images/progress.png',
                  caption: 'Progress',
                ),
                centerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/leaderboard.png',
                      width: 24.0,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leaderboard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rank: 2nd',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xCCFFFFFF),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                rightWidget: CircularProgressIndicatorWrapper(
                  progress: 65,
                  progressColor: Color(0xFFFFB300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LearnCenterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.play_arrow_sharp,
          color: Colors.white,
        ),
        SizedBox(width: 16),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Matter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Density',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xCCFFFFFF),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Pressure',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xCCFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/***
 *
 */

import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/widgets/courses/course_card_template.dart';
import 'package:ecoach/widgets/courses/vertical_captioned_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/widgets/courses/course_detail_snippet.dart';
import 'package:ecoach/widgets/courses/learner_rank.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';

import 'circular_progress_indicator_wrapper.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({
    @required this.course,
    this.colors = '',
    this.iconUrl = 'assets/images/sociology.png',
    this.progress = 0,
    this.learnerPosition = 0,
    this.numberOnRoll = 0,
    this.testsTaken = 0,
    this.totalNumberOfTests = 0,
    this.totalPoints = 0,
    this.times = 0,
    this.onTap,
  });

  final dynamic course;
  final dynamic colors;
  final String iconUrl;
  final double progress;
  final int learnerPosition;
  final int numberOnRoll;
  final int testsTaken;
  final int totalNumberOfTests;
  final int totalPoints;
  final int times;
  final onTap;

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return CourseCardTemplate(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(
              course: widget.course,
            ),
          ),
        );
      },
      course: widget.course,
      background: widget.colors['background'],
      leftWidget: VerticalCaptionedImage(imageUrl: widget.iconUrl),
      centerWidget: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 16.0,
        ),
        child: Text(
          kCapitalizeString(widget.course['name']),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
      rightWidget: CircularProgressIndicatorWrapper(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        progress: widget.progress,
        progressColor: widget.colors['progress'],
      ),
      hasPeripheral: isExpanded,
      peripheralWidget: Container(
        decoration: BoxDecoration(
          color: kCourseCardOverlayColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
        ),
        child: Column(
          children: [
            CourseDetailSnippet(
              label: 'Rank',
              content: LearnerRank(
                position: widget.learnerPosition,
                numberOnRoll: widget.numberOnRoll,
              ),
            ),
            CourseDetailSnippet(
              label: 'Tests',
              content: LinearPercentIndicatorWrapper(
                percent: widget.testsTaken / widget.totalNumberOfTests,
                label: widget.testsTaken.toString() +
                    '/' +
                    widget.totalNumberOfTests.toString(),
                progressColor: kProgressColors[0],
              ),
            ),
            CourseDetailSnippet(
              label: 'Total Points',
              content: LinearPercentIndicatorWrapper(
                label: widget.totalPoints.toString(),
                percent: widget.totalPoints.toDouble() * 0.0001,
                progressColor: kProgressColors[1],
              ),
            ),
            CourseDetailSnippet(
              label: 'Times',
              content: LinearPercentIndicatorWrapper(
                label: widget.times.toString(),
                percent: widget.times.toDouble() * 0.001,
                progressColor: kProgressColors[2],
              ),
            )
          ],
        ),
      ),
    );
  }
}

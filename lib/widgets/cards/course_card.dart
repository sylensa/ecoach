/***
 *
 */

import 'package:ecoach/models/ui/course.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/courses/vertical_captioned_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/widgets/courses/course_detail_snippet.dart';
import 'package:ecoach/widgets/courses/learner_rank.dart';
import 'package:ecoach/widgets/courses/linear_percent_indicator_wrapper.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({required this.course});
  final Course course;

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(course: widget.course),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: widget.course.background,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: darken(widget.course.background, 10),
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  VerticalCaptionedImage(
                      imageUrl: 'assets/icons/${widget.course.icon}'),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        kCapitalizeString(widget.course.title),
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
                  ),
                  CircularProgressIndicatorWrapper(
                    progress: widget.course.progress,
                    progressColor: widget.course.progressColor,
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  )
                ],
              ),
            ),
            if (isExpanded)
              Container(
                decoration: BoxDecoration(
                  color: darken(widget.course.background, 10),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  children: [
                    CourseDetailSnippet(
                      background: widget.course.background,
                      label: 'Rank',
                      content: LearnerRank(
                        position: widget.course.rank['position'],
                        numberOnRoll: widget.course.rank['numberOnRoll'],
                      ),
                    ),
                    CourseDetailSnippet(
                      background: widget.course.background,
                      label: 'Tests',
                      content: LinearPercentIndicatorWrapper(
                        percent: widget.course.tests['testsTaken'] /
                            widget.course.tests['totalNumberOfTests'],
                        label: widget.course.tests['testsTaken'].toString() +
                            '/' +
                            widget.course.tests['totalNumberOfTests']
                                .toString(),
                        progressColor: kProgressColors[0],
                      ),
                    ),
                    CourseDetailSnippet(
                      background: widget.course.background,
                      label: 'Total Points',
                      content: LinearPercentIndicatorWrapper(
                        label: widget.course.totalPoints.toString(),
                        percent: widget.course.totalPoints.toDouble() * 0.0001,
                        progressColor: kProgressColors[1],
                      ),
                    ),
                    CourseDetailSnippet(
                      background: widget.course.background,
                      label: 'Times',
                      content: LinearPercentIndicatorWrapper(
                        label: widget.course.times.toString(),
                        percent: widget.course.times.toDouble() * 0.001,
                        progressColor: kProgressColors[2],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

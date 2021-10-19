/***
 *
 */

import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/ui/course_info.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/test_taken_db.dart';
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
  const CourseCard(this.user, {required this.courseInfo});
  final CourseInfo courseInfo;
  final User user;

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isExpanded = false;
  num courseProgress = 0;

  @override
  void initState() {
    super.initState();

    TestController()
        .getCourseProgress(widget.courseInfo.course.id)
        .then((value) {
      setState(() {
        courseProgress = value is num ? (value * 100).floor() : 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CourseDetailsPage(widget.user, courseInfo: widget.courseInfo),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: widget.courseInfo.background,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: darken(widget.courseInfo.background, 10),
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
                      imageUrl: 'assets/icons/${widget.courseInfo.icon}'),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        kCapitalizeString(widget.courseInfo.title),
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
                    progress: courseProgress,
                    progressColor: widget.courseInfo.progressColor,
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
                  color: darken(widget.courseInfo.background, 10),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  children: [
                    CourseDetailSnippet(
                      background: widget.courseInfo.background,
                      label: 'Rank',
                      content: LearnerRank(
                        position: widget.courseInfo.rank['position'],
                        numberOnRoll: widget.courseInfo.rank['numberOnRoll'],
                      ),
                    ),
                    CourseDetailSnippet(
                      background: widget.courseInfo.background,
                      label: 'Tests',
                      content: LinearPercentIndicatorWrapper(
                        percent: widget.courseInfo.tests['testsTaken'] /
                            widget.courseInfo.tests['totalNumberOfTests'],
                        label:
                            widget.courseInfo.tests['testsTaken'].toString() +
                                '/' +
                                widget.courseInfo.tests['totalNumberOfTests']
                                    .toString(),
                        progressColor: kProgressColors[0],
                      ),
                    ),
                    CourseDetailSnippet(
                      background: widget.courseInfo.background,
                      label: 'Total Points',
                      content: LinearPercentIndicatorWrapper(
                        label: widget.courseInfo.totalPoints.toString(),
                        percent: widget.courseInfo.totalPoints.toDouble(),
                        progressColor: kProgressColors[1],
                      ),
                    ),
                    CourseDetailSnippet(
                      background: widget.courseInfo.background,
                      label: 'Times',
                      content: LinearPercentIndicatorWrapper(
                        label: widget.courseInfo.times.toString(),
                        percent: widget.courseInfo.totalPoints != 0
                            ? widget.courseInfo.times.toDouble() /
                                widget.courseInfo.totalTimes
                            : 0,
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

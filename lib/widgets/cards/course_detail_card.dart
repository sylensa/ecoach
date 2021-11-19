/***
 *
 */

import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:ecoach/widgets/courses/vertical_captioned_image.dart';
import 'package:flutter/material.dart';

class CourseDetailCard extends StatelessWidget {
  CourseDetailCard(
      {required this.courseDetail, this.hideProgress = false, this.onTap});

  final CourseDetail courseDetail;
  final Function()? onTap;
  bool hideProgress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: courseDetail.background,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: darken(courseDetail.background, 10),
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
                    imageUrl: 'assets/icons/${courseDetail.icon}',
                    caption: courseDetail.iconLabel,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        courseDetail.subGraphicsIsIcon
                            ? Icon(
                                courseDetail.subGraphics,
                                color: Colors.white,
                              )
                            : Image.asset(
                                'assets/icons/${courseDetail.subGraphics}',
                                width: 32.0,
                              ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: !hideProgress ? 160.0 : 240.0,
                                  child: Text(
                                    courseDetail.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (courseDetail.subtitle1 != null)
                                  Column(
                                    children: [
                                      SizedBox(height: 4),
                                      Text(
                                        courseDetail.subtitle1.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xCCFFFFFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (courseDetail.subtitle2 != null)
                                  Column(
                                    children: [
                                      SizedBox(height: 4),
                                      Text(
                                        courseDetail.subtitle2.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xCCFFFFFF),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!hideProgress)
                    CircularProgressIndicatorWrapper(
                      progress: courseDetail.progress,
                      progressColor: courseDetail.progressColor,
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

import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class CourseDetailSnippet extends StatelessWidget {
  CourseDetailSnippet({
    this.label = 'Label',
    required this.content,
  });

  final String label;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            color: kCourseCardOverlayColor,
            width: 140.0,
            height: 40.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 24.0),
              child: content,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:ecoach/utils/manip.dart';
import 'package:flutter/material.dart';

class CourseDetailSnippet extends StatelessWidget {
  CourseDetailSnippet({
    this.label = 'Label',
    required this.content,
    required this.background,
  });

  final String label;
  final Widget content;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            color: darken(background, 20),
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

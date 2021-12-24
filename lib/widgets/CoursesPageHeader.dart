import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class CoursesPageHeader extends StatelessWidget {
  const CoursesPageHeader({required this.pageHeading});

  final String pageHeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: Center(
          child: Text(
            pageHeading,
            style: kPageHeaderStyle,
          ),
        ),
      ),
    );
  }
}

/***
 *
 */

import 'package:ecoach/utils/manip.dart';
import 'package:flutter/material.dart';

class CourseCardTemplate extends StatelessWidget {
  const CourseCardTemplate({
    required this.course,
    required this.background,
    this.leftWidget,
    this.centerWidget,
    this.rightWidget,
    this.hasPeripheral = false,
    this.peripheralWidget,
    this.onTap,
  });

  final dynamic course;
  final Color background;
  final leftWidget;
  final centerWidget;
  final rightWidget;
  final bool hasPeripheral;
  final peripheralWidget;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: darken(background, 10),
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
                  leftWidget,
                  Expanded(child: centerWidget),
                  rightWidget
                ],
              ),
            ),
            if (hasPeripheral) peripheralWidget,
          ],
        ),
      ),
    );
  }
}

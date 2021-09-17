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
        title: Text(kCapitalizeString(course['name'])),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32.0,
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Center(child: Text('Course Details')),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/study_quiz_view.dart';
import 'package:ecoach/widgets/layouts/learn_peripheral_layout.dart';
import 'package:flutter/material.dart';

class LearningWidget extends StatefulWidget {
  const LearningWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StudyController controller;

  @override
  _LearningWidgetState createState() => _LearningWidgetState();
}

class _LearningWidgetState extends State<LearningWidget> {
  final CarouselController controller = CarouselController();
  int currentSliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StudyQuizView(controller: widget.controller));
  }
}

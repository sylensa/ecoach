import 'package:ecoach/controllers/course_completion_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/course_completion_study_progress.dart';
import 'package:ecoach/new_ui_ben/screens/course_completion/course_completion_review.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/welcome_screen_provider.dart';
import '../../widgets/learn_card.dart';

class ChoseCourseCompletionMode extends StatelessWidget {
  final Function continueOngoing;
  ChoseCourseCompletionMode({required this.continueOngoing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Course Completion',
          style: TextStyle(
            fontFamily: 'Cocon',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Consumer<WelcomeScreenProvider>(
          builder: (_, welcome, __) => SingleChildScrollView(
            child: FutureBuilder<List<CourseCompletionStudyProgress?>>(
                future: StudyDB()
                    .getCouseCompletionProgressByCourse(welcome.currentCourse!),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Column(
                    children: [
                      const Text(
                        "A quick way to prep for your exam",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                      ),
                      const SizedBox(
                        height: 67,
                      ),
                      Visibility(
                        visible: snapshot.data!.isNotEmpty,
                        child: LearnCard(
                          title: 'Ongoing',
                          desc: 'Do a quick revision for an upcoming exam',
                          value: welcome.currentCourseCompletion == null
                              ? 0
                              : (((welcome.currentCourseCompletion!.level! -
                                          1)) /
                                      welcome.totalTopics) *
                                  100,
                          icon: 'assets/images/learn_mode2/hourglass.png',
                          onTap: () {
                            continueOngoing();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      LearnCard(
                        title: 'New',
                        desc: 'Discard old revision and start a new one',
                        value: 0,
                        icon: 'assets/images/learn_mode2/stopwatch.png',
                        onTap: () {
                          CourseCompletionStudyController()
                              .restartCourseCompletionProgress();
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      LearnCard(
                        subTitle: 'view',
                        secondarySubTitle: snapshot.data == null
                            ? "0"
                            : "${snapshot.data!.length}x",
                        title: 'Completed',
                        desc: 'View stats on completed revision rounds',
                        value: 100,
                        icon: 'assets/images/learn_mode2/completed.png',
                        onTap: () {
                          Get.to(() => CourseCompletionReview());
                        },
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

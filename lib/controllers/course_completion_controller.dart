import 'package:ecoach/controllers/study_cc_controller.dart';
import 'package:ecoach/controllers/study_revision_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/new_ui_ben/providers/welcome_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../database/questions_db.dart';
import '../database/topics_db.dart';
import '../models/course.dart';
import '../models/course_completion_study_progress.dart';
import '../models/question.dart';
import '../models/topic.dart';
import '../models/user.dart';
import '../views/learn/learn_course_completion.dart';
import '../views/learn/learn_revision.dart';
import '../views/learn/learning_widget.dart';
import '../views/study/study_notes_view.dart';

class CourseCompletionStudyController {
  final welcomeProvider =
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);
  // update or insert progress

  // add a new course revision if it hasn't being added
  createInitialCourseCompletionCompletion(
      CourseCompletionStudyProgress revision) async {
    print("create revision called");
    CourseCompletionStudyProgress? revisionStudyProgress = await StudyDB()
        .getCurrentCourseCompletionProgressByCourse(revision.courseId!);

    if (revisionStudyProgress == null) {
      await StudyDB().insertCourseCompletionProgress(revision);
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentCourseCompletionStudyProgress(revision);
      print("created revision: ${revisionStudyProgress!}");
    } else {
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentCourseCompletionStudyProgress(revisionStudyProgress);
      print("saved revision: ${revisionStudyProgress.toMap()}");
    }
  }

// create a function to update progress
  Future<void> updateInsertProgress(
      CourseCompletionStudyProgress progress) async {
    CourseCompletionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentCourseCompletionProgressByCourse(progress.courseId!);

        print("progress cc ${revisionStudyProgress!.toMap()}");

    if (revisionStudyProgress == null) {
      StudyDB().insertCourseCompletionProgress(progress);
    } else {
      CourseCompletionStudyProgress updatedProgress =
          CourseCompletionStudyProgress(
        id: revisionStudyProgress.id,
        courseId: progress.courseId,
        studyId: progress.studyId,
        topicId: progress.topicId,
        level: revisionStudyProgress.level! + 1,
        createdAt: revisionStudyProgress.createdAt,
        updatedAt: progress.updatedAt,
      );
      await StudyDB().updateCourseCompletionProgress(updatedProgress);
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentCourseCompletionStudyProgress(updatedProgress);

          print("progress cc ${updatedProgress.toMap()}");
    }
  }

  // restart revision
  restartCourseCompletionProgress() async {
    final welcomeProvider =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);

    CourseCompletionStudyProgress? progress =
        welcomeProvider.currentCourseCompletion;

    CourseCompletionStudyProgress? completionStudyProgress = await StudyDB()
        .getCurrentCourseCompletionProgressByCourse(progress!.courseId!);

    completionStudyProgress!.level = 1;
    await StudyDB().updateCourseCompletionProgress(completionStudyProgress);

    welcomeProvider
        .setCurrentCourseCompletionStudyProgress(completionStudyProgress);

    getCourseCompletionQuestion();
  }

  getCourseCompletionQuestion() async {
    int currentRevisionLevel = welcomeProvider.currentCourseCompletion!.level!;

    Course course = welcomeProvider.currentCourse!;

    Topic? topic =
        await TopicDB().getLevelTopic(course.id!, currentRevisionLevel);

    List<Question> questions =
        await QuestionDB().getTopicQuestions([topic!.id!], 10);

    CourseCompletionStudyProgress? studyProgress =
        await StudyDB().getCurrentCourseCompletionProgressByCourse(course.id!);
    print("this is the progress of revision: ${studyProgress!.toMap()}");

    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        settings: RouteSettings(name: LearnCourseCompletion.routeName),
        builder: (context) {
          return LearningWidget(
            controller: CourseCompletionController(
              welcomeProvider.currentUser!,
              welcomeProvider.currentCourse!,
              name: topic.name!,
              questions: questions,
              progress: welcomeProvider.progress!,
            ),
          );
        },
      ),
    );
  }
}

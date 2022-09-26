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
import '../models/question.dart';
import '../models/topic.dart';
import '../models/user.dart';
import '../views/learn/learn_revision.dart';
import '../views/learn/learning_widget.dart';

class RevisionProgressController {
  final welcomeProvider =
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);
  // update or insert progress

  // add a new course revision if it hasn't being added
  createInitialCourseRevision(RevisionStudyProgress revision) async {
    print("create revision called");
    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(revision.courseId!);

    if (revisionStudyProgress == null) {
      await StudyDB().insertRevisionProgress(revision);
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentRevisionStudyProgress(revision);
      print("created revision: ${revisionStudyProgress!.toMap()}");
    } else {
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentRevisionStudyProgress(revisionStudyProgress);
      print("saved revision: ${revisionStudyProgress.toMap()}");
    }
  }

// create a function to update progress
  Future<void> updateInsertProgress(RevisionStudyProgress progress) async {
    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(progress.courseId!);

    if (revisionStudyProgress == null) {
      StudyDB().insertRevisionProgress(progress);
    } else {
      RevisionStudyProgress updatedProgress = RevisionStudyProgress(
        id: revisionStudyProgress.id,
        courseId: progress.courseId,
        studyId: progress.studyId,
        topicId: progress.topicId,
        level: revisionStudyProgress.level! + 1,
        createdAt: revisionStudyProgress.createdAt,
        updatedAt: progress.updatedAt,
      );
      await StudyDB().updateRevisionProgress(updatedProgress);
      Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
          .setCurrentRevisionStudyProgress(updatedProgress);
    }
  }

  // restart revision

  restartRevenue() async {
    final welcomeProvider =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);

    RevisionStudyProgress? progress =
        welcomeProvider.currentRevisionStudyProgress;

    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(progress!.courseId!);

    revisionStudyProgress!.level = 1;
    await StudyDB().updateRevisionProgress(revisionStudyProgress);

    welcomeProvider.setCurrentRevisionStudyProgress(revisionStudyProgress);

    getRevisionQuestion();
  }

  getRevisionQuestion() async {
    int currentRevisionLevel =
        welcomeProvider.currentRevisionStudyProgress!.level!;

      Course course = welcomeProvider.currentCourse!;

    Topic? topic =
        await TopicDB().getLevelTopic(course.id!, currentRevisionLevel);

    List<Question> questions =
        await QuestionDB().getTopicQuestions([topic!.id!], 10);

    RevisionStudyProgress? studyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(course.id!);
    print("this is the progress of revision: ${studyProgress!.toMap()}");

    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        settings: RouteSettings(name: LearnRevision.routeName),
        builder: (context) {
          return LearningWidget(
            controller: RevisionController(
              welcomeProvider.currentUser!,
              course,
              name: topic.name ?? course.name!,
              questions: questions,
              progress: welcomeProvider.progress!,
            ),
          );
        },
      ),
    );
  }
}

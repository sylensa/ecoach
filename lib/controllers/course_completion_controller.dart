import 'package:ecoach/controllers/study_cc_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/course_completion_progress_attempt.dart';
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
import '../views/learn/learn_course_completion.dart';
import '../views/learn/learning_widget.dart';

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
    CourseCompletionStudyProgress? revisionStudyProgress = await StudyDB()
        .getCurrentCourseCompletionProgressByCourse(progress.courseId!);

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

    // CourseCompletionStudyProgress? progress =
    //     welcomeProvider.currentCourseCompletion;

    // CourseCompletionStudyProgress? completionStudyProgress = await StudyDB()
    //     .getCurrentCourseCompletionProgressByCourse(progress!.courseId!);

    CourseCompletionStudyProgress newCC = CourseCompletionStudyProgress(
      courseId: welcomeProvider.currentCourse!.id,
      level: 1,
      studyId: welcomeProvider.progress!.studyId,
      topicId: welcomeProvider.progress!.topicId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await StudyDB().insertCourseCompletionProgress(newCC);

    welcomeProvider.setCurrentCourseCompletionStudyProgress(newCC);

    print("this is the new cc: ${newCC.toMap()}");

    getCourseCompletionQuestion();
  }

  getCourseCompletionQuestion({bool questionPage = true}) async {
    // int currentRevisionLevel = welcomeProvider.currentCourseCompletion!.level!;

    Course course = welcomeProvider.currentCourse!;

    CourseCompletionStudyProgress? progress =
        await StudyDB().getCurrentCourseCompletionProgressByCourse(course.id!);

    Topic? topic = await TopicDB().getLevelTopic(course.id!, progress!.level!);

    List<Question> questions =
        await QuestionDB().getTopicQuestions([topic!.id!], 10);

    CourseCompletionStudyProgress? studyProgress =
        await StudyDB().getCurrentCourseCompletionProgressByCourse(course.id!);
    print("this is the progress of revision: ${studyProgress!.toMap()}");

    if (questionPage) {
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

  recordAttempts(double score) async {
    print("new revision attempt");
    final welcomeProvider =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);

    print(
        "current course from provider ${welcomeProvider.currentCourse!.toJson()}");

    StudyDB()
        .getCurrentCourseCompletionProgressByCourse(
            welcomeProvider.currentCourse!.id!)
        .then((studyProgress) async {
      print("progress from database ${studyProgress!.toMap()}");

      Topic? topic = await TopicDB()
          .getLevelTopic(studyProgress.courseId!, studyProgress.level!);

      print("topic for question ${topic!.toJson()}");

      CourseCompletionProgressAttempt ccProgressAttempt =
          CourseCompletionProgressAttempt(
        courseId: welcomeProvider.currentCourse!.id!,
        revisionProgressId: studyProgress.id!,
        createdAt: DateTime.now(),
        updated_at: DateTime.now(),
        score: score,
        studyId: studyProgress.studyId!,
        topicId: topic.id,
        topicName: topic.name,
      );

      print(
          "this progress attempt was added to the database ${ccProgressAttempt.toMap()}");

      await StudyDB().insertCCAttempt(ccProgressAttempt);
      final attempt =
          await StudyDB().getSingleCCAttemptByProgress(studyProgress);
      print("revision date was retrived: ${attempt.toMap()}");
    });
  }

  updateAttempts(double score) async {
    // RevisionStudyProgress revision =
    //     welcomeProvider.currentRevisionStudyProgress!;

    CourseCompletionStudyProgress? revision = await StudyDB()
        .getCurrentCourseCompletionProgressByCourse(
            welcomeProvider.currentCourse!.id!);

    print("current revision to update attempt ${revision!.toMap()}");

    CourseCompletionProgressAttempt revisionProgressAttempt =
        await StudyDB().getSingleCCAttemptByProgress(revision);

    print("revision from database: ${revisionProgressAttempt.toMap()}");

    revisionProgressAttempt.score = score;
    print("revision attempt after update: ${revisionProgressAttempt.toMap()}");

    StudyDB().updateCCAttempt(revisionProgressAttempt);
  }

  Future<List<Map<String, dynamic>>> getAllCourseCompletionAttemptsByProgress(
      CourseCompletionStudyProgress revision) async {
    List<CourseCompletionProgressAttempt> attempts =
        await StudyDB().getCCAttemptByTopicAndProgress(revision);

    print("revision attempts: $attempts");
    print("revision attempts total: ${attempts.length} ");

    //  get all topics within the current course
    List<Topic> topics =
        await TopicDB().courseTopics(welcomeProvider.currentCourse!);

    List<Map<String, dynamic>> topicsAttemptsMapList = [];

    // loop through attempts to get
    topics.forEach((topic) {
      List<CourseCompletionProgressAttempt> topicAttempts =
          attempts.where((attempt) => attempt.topicId == topic.id).toList();

      // get a list of score for each attempt
      List<double> score = List.generate(
          topicAttempts.length, (index) => topicAttempts[index].score!);

      Map<String, dynamic> topicMap = {
        "topicId": topic.id,
        "name": topic.name,
        "attempts": topicAttempts.length,
        "avgScore": topicAttempts.isEmpty
            ? 0
            : score.fold(0,
                    (num previousValue, element) => previousValue + element) /
                topicAttempts.length
      };

      topicsAttemptsMapList.add(topicMap);
    });

    print("attempt progress map: $topicsAttemptsMapList");
    return topicsAttemptsMapList;
  }
}

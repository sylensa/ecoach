import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/study_revision_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/new_ui_ben/providers/welcome_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../database/questions_db.dart';
import '../database/topics_db.dart';
import '../models/course.dart';
import '../models/question.dart';
import '../models/revision_progress_attempts.dart';
import '../models/topic.dart';
import '../views/learn/learn_revision.dart';
import '../views/learn/learning_widget.dart';
import '../views/study/study_notes_view.dart';

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
      print("created revision: ${revision.toMap()}");
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

    RevisionStudyProgress newRevisionStudyProgress = RevisionStudyProgress(
      courseId: revisionStudyProgress!.courseId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      level: 1,
      studyId: revisionStudyProgress.studyId,
      topicId: revisionStudyProgress.topicId,
    );

    await StudyDB()
        .insertRevisionProgress(newRevisionStudyProgress)
        .whenComplete(() {
      getRevisionQuestion();
    });

    // restartRevenue();

    welcomeProvider.setCurrentRevisionStudyProgress(newRevisionStudyProgress);

    print("Revision after restart ${newRevisionStudyProgress.toMap()}");
  }

  getRevisionQuestion() async {
    int currentRevisionLevel =
        welcomeProvider.currentRevisionStudyProgress!.level!;

    Course course = welcomeProvider.currentCourse!;

    RevisionStudyProgress? progress =
        await StudyDB().getCurrentRevisionProgressByCourse(course.id!);

    print("get question from this progress: ${progress!.toMap()}");

    Topic? topic = await TopicDB().getLevelTopic(course.id!, progress.level!);

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

  openStudyView() async {
    Course course =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
            .currentCourse!;

    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(course.id!);

    StudyController controller = welcomeProvider.currentStudyController!;

    Topic? topic =
        await TopicDB().getTopicById(revisionStudyProgress!.topicId!);

    controller.saveTest(Get.context!, (test, success) async {
      Navigator.push(Get.context!, MaterialPageRoute(builder: (context) {
        return StudyNoteView(topic!, controller: controller);
      }));
    });
  }

  recordAttempts(double score) async {
    print("new revision attempt");
    final welcomeProvider =
        Provider.of<WelcomeScreenProvider>(Get.context!, listen: false);

    print(
        "current course from provider ${welcomeProvider.currentCourse!.toJson()}");

    StudyDB()
        .getCurrentRevisionProgressByCourse(welcomeProvider.currentCourse!.id!)
        .then((studyProgress) async {
      print("progress from database ${studyProgress!.toMap()}");

      Topic? topic = await TopicDB()
          .getLevelTopic(studyProgress.courseId!, studyProgress.level!);

      print("topic for question ${topic!.toJson()}");

      RevisionProgressAttempt revisionProgressAttempt = RevisionProgressAttempt(
        courseId: welcomeProvider.currentCourse!.id!,
        revisionProgressId: studyProgress.id!,
        createdAt: DateTime.now(),
        updated_at: DateTime.now(),
        score: score,
        studyId: welcomeProvider.currentRevisionStudyProgress!.studyId!,
        topicId: topic!.id,
        topicName: topic.name,
      );

      print(
          "this progress attempt was add to the database ${revisionProgressAttempt.toMap()}");

      await StudyDB().insertRevisionAttempt(revisionProgressAttempt);
      final attempt =
          await StudyDB().getSingleRevisionAttemptByProgress(studyProgress);
      print("revision date was retrived: ${attempt.toMap()}");
    });
  }

  updateAttempts(double score) async {
    // RevisionStudyProgress revision =
    //     welcomeProvider.currentRevisionStudyProgress!;

    RevisionStudyProgress? revision = await StudyDB()
        .getCurrentRevisionProgressByCourse(welcomeProvider.currentCourse!.id!);

    print("current revision to update attempt ${revision!.toMap()}");

    RevisionProgressAttempt revisionProgressAttempt =
        await StudyDB().getSingleRevisionAttemptByProgress(revision!);

    print("revision from database: ${revisionProgressAttempt.toMap()}");

    revisionProgressAttempt.score = score;
    print("revision attempt after update: ${revisionProgressAttempt.toMap()}");

    StudyDB().updateRevisionAttempt(revisionProgressAttempt);
  }

  Future<List<Map<String, dynamic>>> getAllRevisionAttemptsByProgress(
      RevisionStudyProgress revision) async {
    List<RevisionProgressAttempt> attempts =
        await StudyDB().getRevisionAttemptByTopicAndProgress(revision);

    print("revision attempts: $attempts");
    print("revision attempts total: ${attempts.length} ");

    //  get all topics within the current course
    List<Topic> topics =
        await TopicDB().courseTopics(welcomeProvider.currentCourse!);

    List<Map<String, dynamic>> topicsAttemptsMapList = [];

    // loop through attempts to get
    topics.forEach((topic) {
      List<RevisionProgressAttempt> topicAttempts =
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

  getRevisionTotalScore(RevisionStudyProgress progress) async {
    final score = await StudyDB().getRevisionAttemptSumByProgress(progress);
    return score;
  }
}
